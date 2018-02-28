/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A class that mimics asynchronous calls to send messages to a server.
*/

import Foundation

public class MessagesProvider {
    
    // MARK: Types
    
    enum ServiceError: Error {
        case userNotAuthenticated
    }
    
    // MARK: Properties
    
    private var messagesHistoryURL: URL {
        let groupIdentifier = "group.com.example.apple-samplecode.MessagingIntents"
        let containerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: groupIdentifier)
        
        guard let jsonURL = containerURL?.appendingPathComponent("History.json") else {
            fatalError("Failed to get container path")
        }
        
        return jsonURL
    }
    
    // MARK: Initialization
    
    public init() {}
    
    // MARK: Account Handling
    
    public var currentUser: User? {
        return User(givenName: "Evans", familyName: "Reily", screenName: "Evans", phoneNumbers: [])
    }
    
    public var isUserAuthenticated: Bool {
        // Check, for example, if the user's credentials are correct.
        return currentUser != nil
    }
    
    // MARK: Messaging Methods
    
    public func send(message: Message, completion: (_ success: Bool, _ sentMessage: Message?, _ error: Error?) -> Void) {
        /*
         For the purposed of this sample, we don't have a server-side component.
         Instead we're just storing the message locally.
         */
        
        guard let currentUser = currentUser, isUserAuthenticated else {
            completion(false, nil, ServiceError.userNotAuthenticated)
            return
        }
        
        // Create a new `Message` that includes the current date as the date is was created.
        let datedMessage = Message(content: message.content, sender: currentUser, recipients: message.recipients, date: Date())
        
        var messageHistory = loadMessageHistory()
        messageHistory.append(datedMessage)
        save(messageHistory)
        
        // Call the completion handler.
        completion(true, datedMessage, nil)
    }
    
    public func loadMessageHistory() -> [Message] {
        guard let historyJSON = try? Data(contentsOf: messagesHistoryURL),
            let object = try? JSONSerialization.jsonObject(with: historyJSON, options: []),
            let values = object as? [[String: Any]] else {
                return createFakeMessages()
        }
        
        let messages = values.flatMap { dict in
            return Message(dictionaryRepresentation: dict)
        }
        
        return messages
    }
    
    private func createFakeMessages() -> [Message] {
        guard let localUser = currentUser else {
            fatalError("Unable to create fake messages because there is no `currentUser`.")
        }
        
        let user = User(givenName: "John", familyName: "Doe", screenName: "John Doe", phoneNumbers: [])
        let messageContent = ["Hello", "Hi", "How are you?"]
        
        return messageContent.map { content in
            return Message(content: content, sender: user, recipients: [localUser], date: Date())
        }
    }
    
    private func save(_ messages: [Message]) {
        // Make sure the number of messages isn't too large.
        let messagesToSave = messages.suffix(50)
        
        /*
         Convert the messages to an array of dictionaries that can be saved in
         user defaults.
         */
        
        let messagesJSON: [[String: Any]] = messagesToSave.map { $0.dictionaryRepresentation }

        do {
            let jsonData = try JSONSerialization.data(withJSONObject: messagesJSON, options: [])
            try jsonData.write(to: messagesHistoryURL, options: [])
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
}
