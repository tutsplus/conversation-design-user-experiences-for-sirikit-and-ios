/*
See LICENSE folder for this sample’s licensing information.

Abstract:
An extension of `PhoneNumber` to conform to `DictionaryRepresentable`.
*/

import Foundation

extension PhoneNumber : DictionaryRepresentable {
    
    // MARK: Types
    private enum DictionaryKey: String {
        case label
        case phoneNumber
    }
    
    // MARK: DictionaryRepresentable
    var dictionaryRepresentation: [String: Any] {
        return [
            DictionaryKey.label.rawValue: label,
            DictionaryKey.phoneNumber.rawValue: phoneNumber
        ]
    }
    
    public init?(dictionaryRepresentation dictionary: [String: Any]) {
        guard let label = dictionary[DictionaryKey.label.rawValue] as? String else {
            return nil
        }
        
        guard let phoneNumber = dictionary[DictionaryKey.phoneNumber.rawValue] as? String else {
            return nil
        }
    
        self.label = label
        self.phoneNumber = phoneNumber
    }
}
