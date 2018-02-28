/*
See LICENSE folder for this sample’s licensing information.

Abstract:
An extension of `Message` to conform to `DictionaryRepresentable`.
*/

import Foundation

extension Message: DictionaryRepresentable {
    
    // MARK: Types
    
    private enum DictionaryKey: String {
        case content
        case sender
        case recipients
        case date
    }
    
    // MARK: Properties
    
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.string(from: Date())
        formatter.dateStyle = .full
        formatter.timeStyle = .full
        return formatter
    }()
    
    // MARK: DictionaryRepresentable
    
    var dictionaryRepresentation: [String: Any] {
        var dictionary: [String: Any] = [
            DictionaryKey.content.rawValue: content,
            DictionaryKey.sender.rawValue: sender.dictionaryRepresentation,
            DictionaryKey.recipients.rawValue: recipients.map { $0.dictionaryRepresentation }
        ]
        
        if let date = date {
            dictionary[DictionaryKey.date.rawValue] = Message.dateFormatter.string(from: date)
        }
        
        return dictionary
    }
    
    init?(dictionaryRepresentation dictionary: [String: Any]) {
        guard let content = dictionary[DictionaryKey.content.rawValue] as? String,
            let senderDictionary = dictionary[DictionaryKey.sender.rawValue] as? [String: Any],
            let recipientDictionaries = dictionary[DictionaryKey.recipients.rawValue] as? [[String: Any]],
            let sender = User(dictionaryRepresentation: senderDictionary) else {
            return nil
        }
        
        var recipients = [User]()
        for recipientDictionary in recipientDictionaries {
            guard let recipient = User(dictionaryRepresentation: recipientDictionary) else {
                return nil
            }
            
            recipients.append(recipient)
        }
        
        if let dateString = dictionary[DictionaryKey.date.rawValue] as? String,
            !dateString.isEmpty {
            self.date = Message.dateFormatter.date(from: dateString)
        } else {
            self.date = nil
        }
        
        self.content = content
        self.sender = sender
        self.recipients = recipients
    }
    
}
