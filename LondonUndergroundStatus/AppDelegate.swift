//
//  Copyright © 2019 rachelunthank. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        window = UIWindow(frame: UIScreen.main.bounds)

        setUpDefaultUserSettings()

        let networkService = LineStatusFetcher()
        let storageInteractor = StorageManager()
        let statusViewController = LineStatusViewController(service: networkService,
                                                            storage: storageInteractor)
        let navController = UINavigationController(rootViewController: statusViewController)
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
        return true
    }

    func setUpDefaultUserSettings() {

        guard UserDefaults.standard.object(forKey: "lineOrder") == nil else { return }
        UserDefaults.standard.register(defaults: [
            "lineOrder": ["bakerloo",
                          "central",
                          "circle",
                          "district",
                          "hammersmith-city",
                          "jubilee",
                          "metropolitan",
                          "northern",
                          "piccadilly",
                          "victoria",
                          "waterloo-city",
                          "london-overground",
                          "dlr",
                          "tram",
                          "tfl-rail",
                          "emirates-air-line"]
            ])
    }

    func applicationWillResignActive(_ application: UIApplication) { }

    func applicationDidEnterBackground(_ application: UIApplication) { }

    func applicationWillEnterForeground(_ application: UIApplication) { }

    func applicationDidBecomeActive(_ application: UIApplication) { }

    func applicationWillTerminate(_ application: UIApplication) { }
}
