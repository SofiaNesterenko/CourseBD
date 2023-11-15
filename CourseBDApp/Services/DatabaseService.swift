

import Foundation
import Supabase

enum Table {
    static let channels = "channels"
    static let messages = "messages"
    static let servers = "servers"
    static let users = "users"
}

@Observable
final class DatabaseService {
    
    var servers = [Server]()
    var userServers = [Server]()
    var users = [CourseBDUser]()
    var messages: [UUID: [Message]] = [:]
    
    static let shared = DatabaseService()
    
    var publicSchema: RealtimeChannel?
    private let supabase = SupabaseClient(supabaseURL: URL(string: Secrets.supabaseURL)!, supabaseKey: Secrets.supabaseKey)
    
    private init() {
        Task {
            do {
                try await fetchAllServers()
                try await fetchAllUsers()
            } catch {
                print(error.localizedDescription)
            }
        }
        
    }
    
    // MARK: Users
    @discardableResult
    func createUserInDatabase(_ user: DiscordUser) async throws -> DiscordUser {
        let user: DiscordUser = try await supabase
                                            .database
                                            .from(Table.users)
                                            .insert(user, returning: .representation)
                                            .single()
                                            .execute()
                                            .value
        
        return user
    }
    
    func fetchUserFromDatabase(email: String) async throws -> DiscordUser {
        let user: DiscordUser = try await supabase
                                            .database
                                            .from(Table.users)
                                            .select()
                                            .equals("email", value: email)
                                            .single()
                                            .execute()
                                            .value
        
        return user
    }

    func fetchAllUsers() async throws {
        users = try await supabase
                                .database
                                .from(Table.users)
                                .select()
                                .execute()
                                .value
    }
}

    // MARK: Servers
extension DatabaseService {
    
    func createServer(user: DiscordUser, serverName: String) async throws {
        guard let userUid = user.id else {
            return
        }
        
        let channelUid = UUID()
        let server = Server(createdAt: .now, name: serverName, imageURL: "", admin: userUid, members: [userUid], channels: [channelUid])
        
        var addedServer: Server = try await supabase
                                        .database
                                        .from(Table.servers)
                                        .insert(server, returning: .representation)
                                        .select()
                                        .single()
                                        .execute()
                                        .value
        
        guard let serverId = addedServer.id else {
            return
        }
        
        let channel = Channel(createdAt: .now, name: "general", channelUid: channelUid, admin: userUid, serverId: serverId, messages: [])
        
        try await supabase
                    .database
                    .from(Table.channels)
                    .insert(channel)
                    .select()
                    .single()
                    .execute()
        
        addedServer.channelModels.append(channel)
        userServers.append(addedServer)
    }
    
    func createChannelForServer(admin user: DiscordUser, server: Server, channel: Channel) async throws {
        guard let serverId = server.id else {
            return
        }
        var updatedServer = server
        updatedServer.channels.append(channel.channelUid)
        
        let newChannel: Channel = try await supabase
                                                .database
                                                .from(Table.channels)
                                                .insert(channel, returning: .representation)
                                                .single()
                                                .execute()
                                                .value
        
        try await supabase
                        .database
                        .from(Table.servers)
                        .update(updatedServer)
                        .eq("id", value: serverId)
                        .execute()
    }
    
    func fetchAllServers() async throws {
        let channels: [Channel] = try await supabase
                                                .database
                                                .from(Table.channels)
                                                .select()
                                                .execute()
                                                .value
        
        var servers: [Server] = try await supabase
                                            .database
                                            .from(Table.servers)
                                            .select()
                                            .execute()
                                            .value
        
        servers = servers.map { server in
            var newServer = server
            let serverChannels = channels.filter { channel in
                server.channels.contains(where: { $0 == channel.channelUid })
            }

            newServer.channelModels = serverChannels
            return newServer
        }
        
        self.servers = servers
        
        guard let user = AuthService.shared.currentUser else {
            return
        }
        
        fetchUserServers(for: user)
        fetchMessages { success in
            print(success)
        }
        listenForNewMessages()
    }
    
    func fetchUserServers(for user: DiscordUser) {
        self.userServers = servers.filter({ server in
            return server.members.contains(where: { $0 == user.id })
        })
    }
    
    func joinServer(server: Server, user: DiscordUser) async throws {
        guard let userUid = user.id, let serverId = server.id else {
            return
        }
        var updatedServer = server
        updatedServer.members.append(userUid)
        try await supabase
                    .database
                    .from(Table.servers)
                    .update(updatedServer)
                    .eq("id", value: serverId)
                    .execute()
        
        var updatedUser = user
        updatedUser.servers.append(serverId)
        try await supabase
                        .database
                        .from(Table.users)
                        .update(updatedUser)
                        .eq("id", value: userUid)
                        .execute()
        
        userServers.append(updatedServer)
    }
}

    // MARK: Messages
extension DatabaseService {
    
    func sendMessage(message: Message) async throws {
        try await supabase
            .database
            .from(Table.messages)
            .insert(message)
            .execute()
    }
    
    struct JSONData: Decodable {
        let record: Record
    }
    
    struct Record: Decodable {
        var id: UUID
        let createdAt: String
        let username: String
        let imageURL: String
        let text: String
        let channelUid: UUID
        let serverId: Int
        
        enum CodingKeys: String, CodingKey {
            case id = "id"
            case createdAt = "created_at"
            case username = "username"
            case imageURL = "image_url"
            case text = "text"
            case channelUid = "channel_uid"
            case serverId = "server_id"
        }
        
        func convertToMessage() -> Message {
            let dateFormatter = ISO8601DateFormatter()
            let realDate = dateFormatter.date(from: createdAt) ?? .now
            let message = Message(id: id, createdAt: realDate, username: username, imageURL: imageURL, text: text, channelUid: channelUid, serverId: serverId)
            return message
        }
    }
    
    func fetchMessages(completion: @escaping (Bool)-> Void) {
        userServers.forEach { server in
            server.channelModels.forEach { channel in
                Task {
                    do {
                        let messages: [Message] = try await supabase
                                                                .database
                                                                .from(Table.messages)
                                                                .select()
                                                                .in("channel_uid", value: [channel.channelUid])
                                                                .order("created_at", ascending: true)
                                                                .execute()
                                                                .value
                        
                        self.messages[channel.channelUid] = messages
                    } catch {
                        print(error.localizedDescription)
                        completion(false)
                    }
                }
            }
        }
        completion(true)
    }
    
    func listenForNewMessages() {
        supabase.realtime.connect()
        
        publicSchema = supabase
                        .realtime
                        .channel("public")
                        .on("postgres_changes", filter: ChannelFilter(event: "INSERT", schema: "public", table: Table.messages), handler: { [weak self] message in
                            guard let self = self else { return }
                            
                            if let json = message.payload["data"] as? [String: Any],
                               let jsonData = try? JSONSerialization.data(withJSONObject: json),
                               let decodedData = try? JSONDecoder().decode(JSONData.self, from: jsonData) {
                                let msg = decodedData.record.convertToMessage()
                                print(msg)
                                self.messages[msg.channelUid]?.append(msg)
                            }
                        })
        
        publicSchema?.onError({ message in
            print("ERROR")
        })
        
        publicSchema?.onClose({ message in
            print("CLOSE")
        })
        
        publicSchema?.subscribe(callback: { state, _ in
            switch state {
            case .subscribed:
                print("subscribed")
            case .timedOut:
                print("timedOut")
            case .closed:
                print("closed")
            case .channelError:
                print("channelError")
            }
        })
        
        supabase.realtime.onOpen {
            print("realtime open")
        }
        
        supabase.realtime.onClose {
            print("realtime closed")
        }
        
        supabase.realtime.onError { error, _ in
            print(error.localizedDescription)
        }
    }
}

struct Message: Codable, Identifiable, Equatable {
    var id: UUID
    let createdAt: Date
    let username: String
    let imageURL: String
    let text: String
    let channelUid: UUID
    let serverId: Int
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case createdAt = "created_at"
        case username = "username"
        case imageURL = "image_url"
        case text = "text"
        case channelUid = "channel_uid"
        case serverId = "server_id"
    }
}

struct Channel: Codable, Identifiable, Equatable {
    var id: Int?
    let createdAt: Date
    let name: String
    let channelUid: UUID
    let admin: UUID
    let serverId: Int
    var messages: [UUID]
    var messageModels = [Message]()
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case createdAt = "created_at"
        case name = "name"
        case channelUid = "channel_uid"
        case admin = "admin"
        case serverId = "server_id"
        case messages = "messages"
    }
    
    static func == (lhs: Channel, rhs: Channel) -> Bool {
        return lhs.channelUid == rhs.channelUid
    }
}
