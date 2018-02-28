/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A mock user database containing sample users.
*/

import Foundation

public struct UserDatabase {
    
    // MARK: Properties
    
    public let allUsers = User.sampleUsers
    
    // MARK: Initialization
    
    public init() {}
    
    // MARK: Finding Users
    
    /// Finds all users matching the `queryUser` properties.
    ///
    /// - Parameter queryUser: The user to match to.
    /// - Returns: The collection of matching users.
    public func findUsers(matching queryUser: User) -> [User] {
        let users = allUsers.filter { user in
            return queryUser.isMatch(for: user)
        }
        return users
    }
    
    /// Finds all users matching *any* of the `queryUser` properties.
    ///
    /// For example:
    /// "Jane Doe" would return "Jane Smith", "Sally Doe", etc.
    ///
    /// - Parameter queryUser: The user to match to.
    /// - Returns: The collection of partially matching users.
    public func findUsers(partiallyMatching queryUser: User) -> [User] {
        let users = allUsers.filter { user in
            return queryUser.isPartialMatch(for: user)
        }
        
        return users
    }
    
    /// Finds and returns users first matching the `queryUser` falling back to
    /// partial matches.
    ///
    /// - Parameter queryUser: The user to compare against.
    /// - Returns: If a partial match was necessary and the found users.
    public func findAllUsers(for queryUser: User) -> (Bool, [User]) {
        let exactMatches = findUsers(matching: queryUser)
        guard exactMatches.isEmpty else { return (false, exactMatches) }
        
        let partialMatches = findUsers(partiallyMatching: queryUser)
        return (true, partialMatches)
    }
    
    // MARK: Ranking Results
    
    /// Returns users ranked and sorted by how closely they match the supplied user.
    ///
    /// - Parameter user: The user to match to.
    /// - Returns: Users sorted by rank.
    public func rankUsers(against queryUser: User) -> [UserResult] {
        let (isPartialMatch, matchedUsers) = findAllUsers(for: queryUser)
        let rankedUsers = matchedUsers.lazy.map { user -> UserResult in
            let matchScore = self.score(for: user, matching: queryUser)
            return UserResult(user: user, matchScore: matchScore, isPartialMatch: isPartialMatch)
        }
        
        return rankedUsers.sorted { user1, user2 in
            return user1.matchScore > user2.matchScore
        }
        
    }
    
    private func score(for user: User, matching queryUser: User) -> Int {
        let rankingResults = user.matchResults(against: queryUser)
        
        // Award an extra point if the user is a favorite.
        let favoritePoint = user.isFavorite ? 1 : 0
        
        let totalScore = rankingResults.reduce(favoritePoint) { totalScore, result in
            // If the result matches the supplied user, increase the `totalScore`.
            if result == .match {
                return totalScore + 1
            }
            return totalScore
        }
        
        return totalScore
    }
}

// MARK: User Match

extension User {
    
    // MARK: Types
    
    enum Match {
        /// Match where nil is involved for the supplied information.
        case insufficientInfo
        case match
        case mismatch
    }
    
    // MARK: Comparison
    
    func lowercasedCompare(_ left: String?, _ right: String?, comparison: (String, String) -> Bool) -> Match {
        guard let left = left?.lowercased(), !left.isEmpty,
              let right = right?.lowercased(), !right.isEmpty else {
                // If either of the values are nil or empty we are missing info for this match.
                return .insufficientInfo
        }
        
        return comparison(left, right) ? .match : .mismatch
    }
    
    // MARK: Predicates
    
    func matchResults(against user: User) -> [Match] {
        func contains(left: String, right: String) -> Bool {
            return left.contains(right)
        }
        
        let givenName = nameComponents?.givenName
        let familyName = nameComponents?.familyName
        
        let otherGivenName = user.nameComponents?.givenName
        let otherFamilyName = user.nameComponents?.familyName
        
        return [
            lowercasedCompare(screenName, user.screenName, comparison: contains),
            lowercasedCompare(givenName, otherGivenName, comparison: ==),
            lowercasedCompare(familyName, otherFamilyName, comparison: ==)
        ]
    }
    
    /// Returns `true` if the SearchResult comparing each of the user's
    /// properties agree* with the provided user.
    ///
    /// *Agree means that they do not directly conflict (.mismatch), but
    /// the properties may be missing info (.insufficientInfo) or match.
    ///
    /// - Parameter user: The user to match against.
    func isMatch(for user: User) -> Bool {
        let matches = matchResults(against: user)
        
        return matches.reduce(true) { result, match in
            return result && match != .mismatch
        }
    }
    
    /// Returns `true` if *any* of the SearchResults comparing the user's
    /// properties is found to be a match.
    ///
    /// - Parameter user: The user to match against.
    func isPartialMatch(for user: User) -> Bool {
        let matches = matchResults(against: user)
        
        return matches.reduce(false) { result, match in
            return result || match == .match
        }
    }
    
}
