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
        let plVM = PlayerViewModel(dataModel: dataM)
        
        let mainVC = MainViewController(viewModel: mainVM, playerVM: plVM)
        let navigationController = UINavigationController(rootViewController: mainVC)
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        return true
    }
}

