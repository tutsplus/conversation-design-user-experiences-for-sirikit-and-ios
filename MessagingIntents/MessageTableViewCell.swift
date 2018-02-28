/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Custom table view cell for `MessageHistoryViewController`.
*/

import UIKit
import MessagingIntentsFramework

/// Custom `UITableViewCell` used in `MessageHistoryViewController` to show
/// details of a `Message`.
class MessageTableViewCell: UITableViewCell {
    
    // MARK: Outlets
    
    @IBOutlet weak private var contactLabel: UILabel!
    @IBOutlet weak private var dateLabel: UILabel!
    @IBOutlet weak private var messageLabel: UILabel!
    
    // MARK: Properties
    
    static let reuseIdentifier = "MessageTableViewCell"
    
    /// Used to format message dates in table view cells.
    static private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
    
    /// The mock user that is currently logged into our sample application.
    var currentUser: User?
    
    /// The message to be displayed.
    var message: Message? {
        didSet {
            // Configure the cell with message details.
            
            guard let message = message else { return }
            
            let recipients = message.recipients
            let contactName: String
            
            if recipients.count == 1, let currentUser = currentUser,
                recipients.first == currentUser {
                // The message was sent to the local user.
                // We display the sender's name.
                contactName = "From \(message.sender.formattedName)"
            } else {
                // Display all the recipients' names.
                contactName = recipients.map({ $0.formattedName }).joined(separator: ", ")
            }
            
            contactLabel.text = contactName
            
            if let date = message.date {
                dateLabel.text = MessageTableViewCell.dateFormatter.string(from: date)
            } else {
                dateLabel.text = "-"
            }
            
            messageLabel.text = message.content
        }
    }
    
}
