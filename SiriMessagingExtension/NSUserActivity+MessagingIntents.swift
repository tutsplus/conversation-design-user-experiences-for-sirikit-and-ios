/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Extends NSUserActivity to more easily encapsulate types of activity a user would perform when using Messaging Intents.
*/

import Foundation

extension NSUserActivity {
    
    // MARK: Properties
    
    private static let messagingIdentifier = "com.example.apple-samplecode.Messaging"
    
    // MARK: Types
    
    public enum MessagingActivityType: String {
        case sentMessage
        case loginRequired
        case unknownError
        
        var identifier: String {
            return NSUserActivity.messagingIdentifier
        }
    }
    
    public struct MessagingInfoKey {
        public static let message = "message"
    }
    
    // MARK: Computed properties
    
    public var ascentActivityType: MessagingActivityType? {
        guard activityType.hasPrefix(NSUserActivity.messagingIdentifier) else {
            return nil
        }
        
        // Pull out the `messagingIdentifier` to simplify the type.
        let typeIdentifer = activityType.components(separatedBy: ".").last!
        return MessagingActivityType(rawValue: typeIdentifer)
    }
    
    // MARK: Initialization
    
    public convenience init(activityType: MessagingActivityType, info: AnyObject? = nil) {
        self.init(activityType: activityType.identifier)
        guard let info = info else { return }
        
        switch activityType {
        case .sentMessage:
            userInfo = [MessagingInfoKey.message: info]
        case .loginRequired: break
        case .unknownError:  break
        }
    }
}
