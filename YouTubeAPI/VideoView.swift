//
//  VideoView.swift
//  YouTubeAPI
//
//  Created by GiN Eugene on 21/8/2022.
//

import SwiftUI
import WebKit

struct VideoView: UIViewRepresentable {
    typealias UIViewType = WKWebView
    
    
    let videoID: String
    
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        guard let youtubeURL = URL(string: "https://www.youtube.com/embed/\(videoID)") else {return}
        uiView.scrollView.isScrollEnabled = false
        uiView.load(URLRequest(url: youtubeURL))
    }
    
}
