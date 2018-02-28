/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Extension of UserDatabase for person resolution.
*/

import Intents
import MessagingIntentsFramework

extension UserDatabase {
    
    func resolve(person: INPerson, handleResolution: Bool = true) -> INPersonResolutionResult {
        
        // If the recipient's personHandle is a phone number, then we know we can identity the person (phone numbers should be unique).
        if person.personHandle?.type == .phoneNumber {
            return .success(with: person)
        }
        
        let user = person.user
        
        // Find and rank users from your database.
        let rankedUsers = rankUsers(against: user)
        switch rankedUsers.count {
        case 0:
            // If no results were found, we can't find this user.
            return .unsupported()
            
        case 1:
            let firstRankedUser = rankedUsers.first!
            
            // Construct a new INPerson to fill in additional information that may be included in the found user.
            let recipient = INPerson(user: firstRankedUser.user)
            
            /*
             Check if the ranked user has more than one phone number
            */
            if firstRankedUser.user.phoneNumbers.count > 1 && handleResolution {
                let handles = firstRankedUser.user.phoneNumbers.map { phoneNumber -> INPerson in
                    let personNumberHandle = INPersonHandle(value: phoneNumber.phoneNumber, type: .phoneNumber, label: INPersonHandleLabel(phoneNumber.label))
                    return INPerson(personHandle: personNumberHandle,
                                          nameComponents: user.nameComponents,
                                          displayName: user.formattedName,
                                          image: nil, contactIdentifier: nil, customIdentifier: nil)
                }
                
                return .disambiguation(with: handles)
            }
            
            /*
             Check if the ranked user is a confident match, meaning we're reasonably certain this is the person the user
             was referring to, otherwise ask Siri to help confirm the `recipient`.
             */
            let result: INPersonResolutionResult
            if firstRankedUser.isConfidentMatch {
                result = .success(with: recipient)
            } else {
                result = .confirmationRequired(with: recipient)
            }
            
            return result
            
        default:
            // We need Siri's help to ask user to pick one from the matches, but we don't want to provide too many.
            // Rank the results, limiting what we ask the user for to 5.
            let limitedMatches = rankedUsers.prefix(5)
            
            let ambiguousMatches = limitedMatches.map { rankedUser in
                return INPerson(user: rankedUser.user)
            }
            
            return .disambiguation(with: ambiguousMatches)
        }
    }
    
}
