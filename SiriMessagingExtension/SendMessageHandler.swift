/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Implementation of INSendMessageIntentHandling.
*/

import Intents
import MessagingIntentsFramework

/// - Tag: SendMessageHandler
class SendMessageHandler: NSObject, INSendMessageIntentHandling {
    
    // MARK: Properties
    
    /// Mock messages service.
    let messagesProvider: MessagesProvider
    
    /// Mock user database
    let userDatabase: UserDatabase
    
    init(messagesProvider: MessagesProvider, userDatabase: UserDatabase) {
        self.messagesProvider = messagesProvider
        self.userDatabase = userDatabase
    }
    
    // MARK: INSendMessageIntentHandling
    
    func resolveContent(for intent: INSendMessageIntent, with completion: @escaping (INStringResolutionResult) -> Void) {
        let result: INStringResolutionResult
        if let text = intent.content, !text.isEmpty {
            result = .success(with: text)
        } else {
            result = .needsValue()
        }
        
        completion(result)
    }
    
    func resolveRecipients(for intent: INSendMessageIntent, with completion: @escaping ([INPersonResolutionResult]) -> Void) {
        guard let recipients = intent.recipients, !recipients.isEmpty else {
            completion([.needsValue()])
            return
        }
        
        // Determine the resolution result for each intended recipients.
        let results = recipients.map { recipient in
            userDatabase.resolve(person: recipient)
        }
        
        completion(results)
    }

    // Once resolution is completed, perform validation on the intent and provide confirmation (optional).
    func confirm(intent: INSendMessageIntent, completion: @escaping (INSendMessageIntentResponse) -> Void) {
        let response: INSendMessageIntentResponse
        
        // Verify user is authenticated and your app is ready to send a message.
        if messagesProvider.isUserAuthenticated {
            response = INSendMessageIntentResponse(code: .ready, userActivity: nil)
        } else {
            let activity = NSUserActivity(activityType: .loginRequired)
            response = INSendMessageIntentResponse(code: .failureRequiringAppLaunch, userActivity: activity)
        }
        
        completion(response)
    }
    
    func handle(intent: INSendMessageIntent, completion: @escaping (INSendMessageIntentResponse) -> Void) {
        guard let content = intent.content, let recipients = intent.recipients, let sender = messagesProvider.currentUser else {
            // If the optional resolution methods are incorrectly implemented, we
            // may still be missing necessary information.
            fatalError("Missing required information to send the message. Check the resolution methods above.")
        }
        
        let userRecipients = recipients.map { recipient in
            return recipient.user
        }
        
        let message = Message(content: content, sender: sender, recipients: userRecipients, date: Date())
        
        messagesProvider.send(message: message) { success, message, _ in
            guard success else {
                let activity = NSUserActivity(activityType: .unknownError, info: NSString(string: content))
                completion(INSendMessageIntentResponse(code: .failure, userActivity: activity))
                return
            }
            
            // Inform the host app that a message has been sent.
            let activity = NSUserActivity(activityType: .sentMessage, info: NSString(string: content))
            completion(INSendMessageIntentResponse(code: .success, userActivity: activity))
        }
    }
    
}
