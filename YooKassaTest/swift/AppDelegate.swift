//
//  AppDelegate.swift
//  YooKassaTest
//
//  Created by GoodDamn on 31/01/2024.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        // Override point for customization after application launch.
        
        
        window = UIWindow(
            frame: UIScreen.main.bounds
        )
        
        window?.makeKeyAndVisible()
        window?.rootViewController = ViewController()
        
        
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


    func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey : Any] = [:]
    ) -> Bool {
        
        guard let comps = NSURLComponents(
            url: url,
            resolvingAgainstBaseURL: true
        ), let host = comps.host else {
            print("Invalid URL")
            return false
        }
        
        print("Components: \(comps)")
        
        if host != "sub" {
            print("Invalid host")
            return false
        }
        
        print("Handle sub?")
        
        let c = ViewController()
        window?.rootViewController = c
        
        return true
    }
    
}

