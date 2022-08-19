//
//  ViewController.swift
//  YouTubeAPI
//
//  Created by GiN Eugene on 18/8/2022.
//

import UIKit

class ViewController: UIViewController {
    
    var model = VideoDataModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        model.getChannel(ChannelsId.travels.rawValue) { data in
            print(data)
        }
        
//    model.getChannel1()
    }


}

