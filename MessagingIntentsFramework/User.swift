/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A struct that defines a user that can receive messages from our app.
*/

import Foundation

public struct User: Equatable {
    
    // MARK: Properties
    
    private static let nameFormatter = PersonNameComponentsFormatter()
    
    public var isFavorite: Bool
    public let screenName: String
    public let nameComponents: PersonNameComponents?
    public let phoneNumbers: [PhoneNumber]
    
    public var givenName: String {
        guard let nameComponents = nameComponents else {
            return ""
        }
        
        return nameComponents.givenName ?? ""
    }
    public var lastName: String {
        guard let nameComponents = nameComponents else {
            return ""
        }
        
        return nameComponents.familyName ?? ""
    }
    public var formattedName: String {
        guard let nameComponents = nameComponents else {
            return ""
        }
        return User.nameFormatter.string(from: nameComponents)
    }
    
    // MARK: Initialization
    
    public init(givenName: String?, familyName: String?, screenName: String, favorite: Bool = false, phoneNumbers: [PhoneNumber]) {
        var nameComponents = PersonNameComponents()
        nameComponents.givenName = givenName
        nameComponents.familyName = familyName
        
        self.nameComponents = nameComponents
        self.screenName = screenName
        self.isFavorite = favorite
        self.phoneNumbers = phoneNumbers
    }

    /// Loads users from the Contacts.plist
    ///
    /// - Returns: An array of valid users.
    public static var sampleUsers: [User] = {
        let frameworkBundle = Bundle.messagingIntentsFramework
        guard let contactsURL = frameworkBundle.url(forResource: "Contacts", withExtension: "plist", subdirectory: nil, localization: nil) else {
            fatalError("Failed to find Contacts.plist.")
        }
        
        let contacts = NSDictionary(contentsOf: contactsURL)!
        
        guard let friendDictionaries = contacts["Friends"] as? [[String: Any]] else {
            fatalError("Missing 'Friends' key in Contacts.plist.")
        }

        return friendDictionaries.map { dict in
            guard let user = User(dictionaryRepresentation: dict) else {
                fatalError("Invalid entry \(dict)")
            }
            return user
        }
    }()
    
    // MARK: Equatable
    
    public static func ==(lhs: User, rhs: User) -> Bool {
        return lhs.givenName == rhs.givenName && lhs.lastName == rhs.lastName
    }
}

extension Bundle {
    
    fileprivate static var messagingIntentsFramework: Bundle {
        class ClassForBundle {}
        return Bundle(for: ClassForBundle.self)
    }
}
