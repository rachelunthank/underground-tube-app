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

        if UserDefaults.standard.object(forKey: "lineOrder") == nil {
            let lines: [String] = TubeLines.allCases.map { $0.rawValue }
            UserDefaults.standard.register(defaults: ["lineOrder": lines])
        }

        if UserDefaults.standard.object(forKey: "lineModes") == nil {
            let lineModes: [String] = LineModes.allCases.map { $0.rawValue }
            UserDefaults.standard.register(defaults: ["lineModes": lineModes])
        }
    }

    func applicationWillResignActive(_ application: UIApplication) { }

    func applicationDidEnterBackground(_ application: UIApplication) { }

    func applicationWillEnterForeground(_ application: UIApplication) { }

    func applicationDidBecomeActive(_ application: UIApplication) { }

    func applicationWillTerminate(_ application: UIApplication) { }
}
