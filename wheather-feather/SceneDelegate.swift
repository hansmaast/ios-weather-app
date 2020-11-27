//
//  SceneDelegate.swift
//  wheather-feather
//
//  Created by Hans Maast on 26/10/2020.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        print("🍺")
       
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        
        window?.windowScene = windowScene
        
        window?.rootViewController = RootController()
        
        window?.makeKeyAndVisible()
    
    }
    
}

