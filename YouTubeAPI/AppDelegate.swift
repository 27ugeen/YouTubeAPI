//
//  AppDelegate.swift
//  YouTubeAPI
//
//  Created by GiN Eugene on 18/8/2022.
//

import UIKit
import MediaPlayer

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let dataM = VideoDataModel()
        let mainVM = MainViewModel(dataModel: dataM)
        let plVM = PlayerViewModel(dataModel: dataM)
        let volumeView = MPVolumeView()
        
        let mainVC = MainViewController(viewModel: mainVM, playerVM: plVM, volumeView: volumeView)
        
        let navigationController = UINavigationController(rootViewController: mainVC)
        navigationController.navigationBar.prefersLargeTitles = true
        setupAppearance()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        return true
    }
    
    func setupAppearance() {
        let coloredAppearance = UINavigationBarAppearance()
        coloredAppearance.configureWithTransparentBackground()
        coloredAppearance.backgroundColor = .black
        coloredAppearance.shadowColor = .clear
        coloredAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        coloredAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        UINavigationBar.appearance().standardAppearance = coloredAppearance
        UINavigationBar.appearance().compactAppearance = coloredAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = coloredAppearance
        UINavigationBar.appearance().tintColor = .white
    }
}

