//
//  AppDelegate.swift
//  MatchApp1
//
//  Created by 石井治樹 on 2021/08/02.
//

import UIKit
import Firebase
import IQKeyboardManagerSwift
import KeychainSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        FirebaseApp.configure()
        IQKeyboardManager.shared.enable = true
//
//        let firebaseAuth = Auth.auth()
//        do {
//            try firebaseAuth.signOut()
//        }catch let signOutError as NSError {
//            print("Error signing out: %@", signOutError)
//        }
//        let keychain = KeychainSwift()
//        keychain.clear()
        
        UINavigationBar.appearance().tintColor = Util.setChatColor(jibun: true)
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: Util.setChatColor(jibun: true)]
        (UINavigationBar.appearance() as UINavigationBar).setBackgroundImage(UIImage(), for: .default)
        
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

