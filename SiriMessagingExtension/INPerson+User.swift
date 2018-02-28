/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Extension of INPerson to relate to our User model.
*/

import Intents
import MessagingIntentsFramework

extension INPerson {
    
    var user: User {
        let screenName = personHandle?.value ?? ""
        
        let components: PersonNameComponents?
        if let nameComponents = nameComponents {
            components = nameComponents
        } else {
            // Try to recover the components from the `displayName`.
            let formatter = PersonNameComponentsFormatter()
            components = formatter.personNameComponents(from: displayName)
        }
        
        let givenName = components?.givenName
        let familyName = components?.familyName
        return User(givenName: givenName, familyName: familyName, screenName: screenName, phoneNumbers: [])
    }
    
    convenience init(user: User) {
        let handle = INPersonHandle(value: user.screenName, type: .unknown)
        
        self.init(personHandle: handle,
                  nameComponents: user.nameComponents,
                  displayName: user.formattedName,
                  image: nil,
                  contactIdentifier: nil,
                  customIdentifier: user.screenName)
        
    }
}
