//
//  SceneDelegate.swift
//  iosdt-4hw
//
//  Created by Aleksey on 07.01.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    var fileTabNavigationController: UINavigationController!
    var settingsTabNavigationController: UINavigationController!
    var passwordNavigationController : UINavigationController!


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let tabBarController = UITabBarController()
        
        fileTabNavigationController = UINavigationController(rootViewController: FileViewController())
        settingsTabNavigationController = UINavigationController(rootViewController: SettingsViewController())
        passwordNavigationController = UINavigationController(rootViewController: PasswordViewController())
        
        tabBarController.viewControllers = [fileTabNavigationController, settingsTabNavigationController]
        

        let item1 = UITabBarItem(title: "Files", image: UIImage(systemName: "folder.circle"), tag: 0)
        let item2 = UITabBarItem(title: "Settings", image: UIImage(systemName: "gearshape.2"), tag: 1)
        
        fileTabNavigationController.tabBarItem = item1
        settingsTabNavigationController.tabBarItem = item2
        
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = passwordNavigationController
        window.makeKeyAndVisible()
        self.window = window
    }

    func sceneDidDisconnect(_ scene: UIScene) {}

    func sceneDidBecomeActive(_ scene: UIScene) {}

    func sceneWillResignActive(_ scene: UIScene) {}

    func sceneWillEnterForeground(_ scene: UIScene) {}

    func sceneDidEnterBackground(_ scene: UIScene) {}


}

