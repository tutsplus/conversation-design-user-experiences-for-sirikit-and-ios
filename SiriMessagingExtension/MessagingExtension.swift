/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Choose the appropriate handlers for each intent.
*/

import Intents
import MessagingIntentsFramework

/// An implementation of `INExtension`.
class MessagingExtension: INExtension {
    
    // MARK: Properties
    
    /// Mock messages service.
    let messagesProvider = MessagesProvider()
    
    /// Mock user database.
    let userDatabase = UserDatabase()
    
    // MARK: INExtension
    
    override func handler(for intent: INIntent) -> Any {
        // Depending on the intent, we returned the appropriate handler.
        
        switch intent {
        case is INSendMessageIntent:
            return SendMessageHandler(messagesProvider: messagesProvider, userDatabase: userDatabase)
            
        case is INSearchForMessagesIntent:
            return SearchForMessagesHandler(messagesProvider: messagesProvider, database: userDatabase)
            
        case is INSetMessageAttributeIntent:
            return SetMessageAttributeHandler()
            
        default:
            fatalError("Unhandled intent: \(intent)\n" +
                "Any intent that is passed through `handler(for:)` is " +
                "definied in the Info.plist and must have a matching Intent Hander.")
        }
    }
}

