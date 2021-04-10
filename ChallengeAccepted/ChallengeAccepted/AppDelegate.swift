//
//  AppDelegate.swift
//  ChallengeAccepted
//
//  Created by Subomi Popoola on 3/19/21.
//

import UIKit
import Parse

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let parseConfig = ParseClientConfiguration {
//              $0.applicationId = "7megvzwBN2WkLxQxBtezhjNSkSzpcS6RoOo3hMYJ"
//              $0.clientKey = "6hHo5nBVWYfCmQ8QqRaQesOfRUAQGetxmSqHK5ex"
//              $0.server = "https://parseapi.back4app.com"
            
            $0.applicationId = "1NBQ5VgY7PwzaNeAPWu4BislAplupXNOVkDlGVBm"
            $0.clientKey = "B4ResQb1oEbzFiOLshThJxpbY18DeRAZ2ZLsdYjC"
            $0.server = "https://parseapi.back4app.com"
          }
          Parse.initialize(with: parseConfig)
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

