//
//  SceneDelegate.swift
//  RedditClone
//
//  Created by Ernesto Jose Contreras Lopez on 15/5/23.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let firstUrl = URLContexts.first?.url else {
            return
        }
        
        /// Get the query parameters from the Deeplink and map it to OAuthResponse model.
        let oauthResponse = NetworkManager.shared.getQueryItems(
            firstUrl.absoluteString
        ).objectVersion(type: OAuthResponse.self)
        
        if let response = oauthResponse {
            /// Save the secret client id in UserDefaults.
            UserDefaultsManager.shared.saveValue(response.code, type: .secretClient)
            
            /// Check if the user doesn't have a token.
            if !Helper.hasToken() {
                /// Request the token and send a notification to fetch them from requestList() method at HomeViewModel when the token is received.
                NetworkManager.shared.requestSessionToken { isSuccess in
                    if isSuccess {
                        NotificationCenter.default.post(name: .retrievePosts, object: nil)
                    }
                }
            }
        } else {
            NotificationCenter.default.post(name: .redditPermissionsDeclined, object: nil)
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {}
}

