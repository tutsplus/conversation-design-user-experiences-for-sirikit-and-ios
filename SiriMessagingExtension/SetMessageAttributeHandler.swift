/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Implementation of INSetMessageAttirbuteIntentHandling.
*/

import Intents
import MessagingIntentsFramework

/// - Tag: SetMessageAttributeHandler
class SetMessageAttributeHandler: NSObject, INSetMessageAttributeIntentHandling {
    
    // MARK: SetMessageAttributeHandler
    
    func resolveAttribute(for intent: INSetMessageAttributeIntent, with completion: @escaping (INMessageAttributeResolutionResult) -> Void) {
        completion(.success(with: .read))
    }
    
    func handle(intent: INSetMessageAttributeIntent, completion: @escaping (INSetMessageAttributeIntentResponse) -> Void) {
        let userActivity = NSUserActivity(activityType: NSStringFromClass(INSetMessageAttributeIntent.self))
        let response = INSetMessageAttributeIntentResponse(code: .success, userActivity: userActivity)
        completion(response)
    }
}
