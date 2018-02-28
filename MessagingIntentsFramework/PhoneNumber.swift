/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Representation of a phone number.
*/

import Foundation

public struct PhoneNumber: Equatable {

    // MARK: Properties
    public let label: String
    public let phoneNumber: String
    
     // MARK: Initialization
    public init(label: String, phoneNumber: String) {
        self.label = label
        self.phoneNumber = phoneNumber
    }
    
    // MARK: Equatable
    
    public static func ==(lhs: PhoneNumber, rhs: PhoneNumber) -> Bool {
        return lhs.phoneNumber == rhs.phoneNumber
    }
}
