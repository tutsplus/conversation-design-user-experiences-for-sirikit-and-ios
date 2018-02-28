/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Represents the result of a search query for a user.
*/

public struct UserResult {
    
    // MARK: Properties
    
    /// The User this result refers to.
    public var user: User
    
    /// If the match has a high probability of being correct.
    public var isConfidentMatch: Bool {
        return !isPartialMatch && matchScore > 1
    }
    
    var matchScore: Int
    var isPartialMatch: Bool
}
