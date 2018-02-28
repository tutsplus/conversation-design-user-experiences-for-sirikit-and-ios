/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A view controller that lists recent messages sent with our app.
*/

import UIKit
import MessagingIntentsFramework

/// A `UITableViewController` displaying the messages sent to and from
/// our mock user (`messagesProvider.currentUser`).
class MessageHistoryViewController: UITableViewController {
    
    private let messagesProvider = MessagesProvider()
    
    private var messages = [Message]() {
        didSet {
            // If a new array of `Message`s has been set, reload the table view.
            guard oldValue != messages, isViewLoaded else { return }
            tableView.reloadData()
        }
    }
    
    // MARK: UIViewController
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Load the table view with the message history, in reverse order of recency.
        messages = messagesProvider.loadMessageHistory().reversed()
    }
    
    // MARK: UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MessageTableViewCell.reuseIdentifier, for: indexPath) as? MessageTableViewCell else {
            fatalError("Expected `\(MessageTableViewCell.self)` type for identifier \(MessageTableViewCell.reuseIdentifier). Check the configuration in Main.storyboard.")
        }
        
        cell.currentUser = messagesProvider.currentUser
        cell.message = messages[indexPath.row]
        return cell
    }
}
