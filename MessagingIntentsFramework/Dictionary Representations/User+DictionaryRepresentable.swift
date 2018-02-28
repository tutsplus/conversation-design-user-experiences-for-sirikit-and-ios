/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Extends `User` to allow it to be represented as and initialized with an `NSDictionary`.
*/

import Foundation

extension User: DictionaryRepresentable {
    
    // MARK: Types
    
    private enum DictionaryKey: String {
        case fullName
        case screenName
        case isFavorite
        case phoneNumbers
    }
    
    // MARK: DictionaryRepresentable
    
    var dictionaryRepresentation: [String: Any] {
        return [
            DictionaryKey.fullName.rawValue: formattedName,
            DictionaryKey.screenName.rawValue: screenName,
            DictionaryKey.isFavorite.rawValue: isFavorite,
            DictionaryKey.phoneNumbers.rawValue: phoneNumbers
        ]
    }
    
    public init?(dictionaryRepresentation dictionary: [String: Any]) {
        guard let screenName = dictionary[DictionaryKey.screenName.rawValue] as? String else {
            return nil
        }
        
        let fullName = dictionary[DictionaryKey.fullName.rawValue] as? String
        let isFavorite = dictionary[DictionaryKey.isFavorite.rawValue] as? Bool ?? false
        let phoneNumbersArray = dictionary[DictionaryKey.phoneNumbers.rawValue] as? [[String: Any]]

        phoneNumbers = phoneNumbersArray?.map { dict in
            guard let phoneNumber = PhoneNumber(dictionaryRepresentation: dict) else {
                fatalError("Invalid PhoneNumber entry '\(dict)'")
            }
            return phoneNumber
        } ?? []

        let formatter = PersonNameComponentsFormatter()
        
        let nameComponents: PersonNameComponents?
        
        if let fullName = fullName {
            nameComponents = formatter.personNameComponents(from: fullName)
        } else {
            nameComponents = nil
        }
        
        self.nameComponents = nameComponents
        self.screenName = screenName
        self.isFavorite = isFavorite
    }
}
