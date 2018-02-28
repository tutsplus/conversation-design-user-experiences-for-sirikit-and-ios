/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Message struct encapsulating general information about a message.
*/

import Foundation

public struct Message: Equatable {
    
    // MARK: Properties
    
    public let date: Date?
    public let sender: User
    public let content: String
    public let recipients: [User]
    
    // MARK: Initialization
    
    public init(content: String, sender: User, recipients: [User], date: Date? = nil) {
        self.content = content
        self.recipients = recipients
        self.sender = sender
        self.date = date
    }
    
    // MARK: Equatable
    
    static public func ==(lhs: Message, rhs: Message) -> Bool {
        return lhs.content == rhs.content &&
            lhs.recipients == rhs.recipients &&
            lhs.sender == rhs.sender &&
            lhs.date == rhs.date
    }
    
}
