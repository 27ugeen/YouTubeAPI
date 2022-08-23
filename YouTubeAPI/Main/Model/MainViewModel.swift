//
//  MainViewModel.swift
//  YouTubeAPI
//
//  Created by GiN Eugene on 19/8/2022.
//

import Foundation
import UIKit

struct ChannelItemsStub {
    let channelTittle: String
    let playListId: String
    let channelImg: UIImage
    let subscribers: String
}

struct PlaylistItemsStub {
    let channelTitle: String
    let playlistTitle: String
    let videoTitle: String
    let videoId: String
    let viewsCount: String
    let playlistImg: UIImage
}

class MainViewModel {
    //MARK: - props
    private let dataModel: VideoDataModel
    var channelItems: [ChannelItemsStub] = []
    var playlistItems: [PlaylistItemsStub] = []
    
    //MARK: - init
    init(dataModel: VideoDataModel) {
        self.dataModel = dataModel
    }
    //MARK: - metods
    private func getChannelsArrModel(completion: @escaping ([ChannelModel]) -> Void) {
        var channelModelArr: [ChannelModel] = []
        ChannelsId.allCases.forEach { channel in
            dataModel.getChannel(channel.rawValue) { data in
                channelModelArr.append(data)
                if channelModelArr.count == ChannelsId.allCases.count {
                    
                    completion(channelModelArr)
                }
            }
        }
    }
    
    func getAllChannels(completion: @escaping ([ChannelItemsStub]) -> Void ) {
        self.getChannelsArrModel() { arr in
            arr.forEach { item in
                let m = item.items[0]
                var chImg: UIImage?
                
                let group = DispatchGroup()
                
                group.enter()
                self.dataModel.getPlaylistItems(m.playListId) { data in
                    self.getImgFromUrl(data.items[0].imgUrl) { img in
                        chImg = img
                        group.leave()
                    }
                }
                group.notify(queue: .main) {
                    let newItem = ChannelItemsStub(channelTittle: m.title,
                                                   playListId: m.playListId,
                                                   channelImg: chImg ?? UIImage(),
                                                   subscribers: m.subscriberCount)
                    self.channelItems.append(newItem)
                    
                    if self.channelItems.count == 4 {
                        completion(self.channelItems)
                    }
                }
            }
        }
    }
    
    func getAllPlaylists(_ playlistId: String, completion: @escaping ([PlaylistItemsStub]) -> Void) {
        dataModel.getPlaylistItems(playlistId) { data in
            self.playlistItems = []
            data.items.forEach { item in
                
                var plImg: UIImage?
                var plTitle: String?
                var vCount: String?
                
                let group = DispatchGroup()
                
                group.enter()
                self.getImgFromUrl(item.imgUrl) { img in
                    plImg = img
                    group.leave()
                }
                group.enter()
                self.dataModel.getPlaylistTitle(playlistId) { data in
                    plTitle = data.items[0].playlistTitle
                    group.leave()
                }
                group.enter()
                self.dataModel.getVideo(item.videoId) { data in
                    vCount = data.items[0].viewCount
                    group.leave()
                }
                
                group.notify(queue: .main) {
                    let newPlaylist = PlaylistItemsStub(channelTitle: item.channelTitle,
                                                        playlistTitle: plTitle ?? "Playlist Title",
                                                        videoTitle: item.videoTitle,
                                                        videoId: item.videoId,
                                                        viewsCount: vCount ?? "nil",
                                                        playlistImg: plImg ?? UIImage())
                    self.playlistItems.append(newPlaylist)
                    if self.playlistItems.count == 10 {
                        completion(self.playlistItems)
                    }
                }
            }
        }
    }
    
    private func getImgFromUrl(_ link: String, completion: @escaping (UIImage) -> Void) {
        guard let url = URL(string: link) else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
            else { return }
            DispatchQueue.main.async() {
                completion(image)
            }
        }.resume()
    }
}
