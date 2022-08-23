//
//  AppDelegate.swift
//  YouTubeAPI
//
//  Created by GiN Eugene on 18/8/2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let dataM = VideoDataModel()
        let mainVM = MainViewModel(dataModel: dataM)
        
        let mainVC = MainViewController(viewModel: mainVM)
        let pl = PlayerViewController()
        let navigationController = UINavigationController(rootViewController: pl)
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        return true
    }


}

