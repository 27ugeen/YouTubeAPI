//
//  PlayerViewModel.swift
//  YouTubeAPI
//
//  Created by GiN Eugene on 23/8/2022.
//

import Foundation
import UIKit

struct VideoItemsStub {
    let videoId: String
    let videoTitle: String
    let viewsCount: String
}

class PlayerViewModel {
    //MARK: - props
    private let dataModel: VideoDataModel
    
    var videoItems: [VideoItemsStub] = []
    //MARK: - init
    init(dataModel: VideoDataModel) {
        self.dataModel = dataModel
    }
    //MARK: - methods
    func getVideos(_ playlistId: String, completion: @escaping ([VideoItemsStub]) -> Void) {
        dataModel.getPlaylistItems(playlistId) { data in
            self.videoItems = []
            data.items.forEach { item in
                
                var vCount: String?
                
                let group = DispatchGroup()
                
                group.enter()
                self.dataModel.getVideo(item.videoId) { data in
                    vCount = data.items[0].viewCount
                    group.leave()
                }
                
                group.notify(queue: .main) {
                    let newVideo = VideoItemsStub(videoId: item.videoId,
                                                  videoTitle: item.videoTitle,
                                                  viewsCount: vCount ?? "nil")
                    self.videoItems.append(newVideo)
                    //TODO: - need change "10"
                    if self.videoItems.count == 10 {
                        completion(self.videoItems)
                    }
                }
            }
        }
    }
}
