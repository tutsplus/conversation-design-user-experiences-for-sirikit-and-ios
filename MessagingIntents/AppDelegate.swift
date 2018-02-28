/*
See LICENSE folder for this sample’s licensing information.

Abstract:
The application delegate.
*/

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
        
        // Pass the activity to the view controllers to handle. The user activity
        // will be used by each view controller.
        if let navigationController = window?.rootViewController as? UINavigationController {
            restorationHandler(navigationController.viewControllers)
        }
        
        return true
    }
    
}

