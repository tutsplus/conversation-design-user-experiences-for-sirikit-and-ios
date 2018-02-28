/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A type that implements the `DictionaryRepresentable` can be represented as and initialized with a `Dictionary`.
*/

import Foundation

protocol DictionaryRepresentable {
    var dictionaryRepresentation: [String: Any] { get }
    
    init?(dictionaryRepresentation dictionary: [String: Any])
}
