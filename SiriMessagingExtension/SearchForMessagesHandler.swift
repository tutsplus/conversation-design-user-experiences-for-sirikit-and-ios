/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Implementation of INSearchForMessagesIntentHandling.
*/

import Intents
import MessagingIntentsFramework

/// - Tag: SearchForMessagesHandler
class SearchForMessagesHandler: NSObject, INSearchForMessagesIntentHandling {
    
    // MARK: Properties
    
    let messagesProvider: MessagesProvider
    
    let database: UserDatabase
    
    // MARK: Initialization
    
    init(messagesProvider: MessagesProvider, database: UserDatabase) {
        self.messagesProvider = messagesProvider
        self.database = database
    }
    
    // MARK: INSearchForMessagesIntentHandling
    
    func resolveSenders(for intent: INSearchForMessagesIntent, with completion: @escaping ([INPersonResolutionResult]) -> Void) {
        guard let senders = intent.senders, !senders.isEmpty else {
            completion([.needsValue()])
            return
        }
        
        // Determine the resolution result for each sender.
        let results = senders.map { sender in
            // We don't need to resolve the handle (phone number), only the recipient.
            // Handle should be resolved only when sending messages.
            database.resolve(person: sender, handleResolution: false)
        }
        
        completion(results)
    }
    
    func handle(intent: INSearchForMessagesIntent, completion: @escaping (INSearchForMessagesIntentResponse) -> Void) {
        // Implement your application logic to find a message that matches the information in the intent.
        guard let sender = intent.senders?.first,
            let databaseUser = database.findUsers(matching: sender.user).first else {
            // If the optional resolution methods are incorrectly implemented, we
            // may still be missing necessary information.
            fatalError("Missing required information to search for the message. Check the resolution methods above.")
        }
        
        let relevantMessages = messagesProvider.loadMessageHistory().filter { message -> Bool in
            return message.sender == databaseUser
        }
        
        let messages = relevantMessages.enumerated().map { indexedMessage -> INMessage in
            let (index, message) = indexedMessage
            return INMessage(identifier: "\(index)",
                             content: message.content,
                             dateSent: message.date,
                             sender: INPerson(user: message.sender),
                             recipients: message.recipients.map { INPerson(user: $0) })
        }
        
        let userActivity = NSUserActivity(activityType: NSStringFromClass(INSearchForMessagesIntent.self))
        let response = INSearchForMessagesIntentResponse(code: .success, userActivity: userActivity)
        response.messages = messages
        
        completion(response)
    }
    
}

