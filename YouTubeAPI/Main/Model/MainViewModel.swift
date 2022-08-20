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
    let videoId: String
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
    //MARKS: - methods
    func getChannels(completion: @escaping ([ChannelItemsStub], [PlaylistItemsStub]) -> Void) {
        var channelModelArr: [ChannelModel] = []
        ChannelsId.allCases.forEach { channel in
            dataModel.decodeModelFromData(channel.rawValue) { chModel, plModel in
                channelModelArr.append(chModel)
                
                let channel = chModel.items[0]
                let playlist = plModel.items[0]
                
                var chImg: UIImage?
                var plImg: UIImage?
                
                let group = DispatchGroup()
                
                group.enter()
                self.getImgFromUrl(playlist.imgUrl) { img in
                    chImg = img
                    group.leave()
                }
                group.enter()
                self.getImgFromUrl(playlist.imgUrl) { img in
                    plImg = img
                    group.leave()
                }
                group.notify(queue: .main) {
                    
                    let newChannel = ChannelItemsStub(channelTittle: channel.title,
                                                      playListId: channel.playListId,
                                                      channelImg: chImg ?? UIImage(),
                                                      subscribers: channel.subscriberCount)
                    self.channelItems.append(newChannel)
                    
                    let newPlaylist = PlaylistItemsStub(channelTitle: playlist.channelTitle,
                                                       playlistTitle: playlist.playlistTitle,
                                                       videoId: playlist.videoId,
                                                       playlistImg: plImg ?? UIImage())
                    self.playlistItems.append(newPlaylist)
                    
                    if channelModelArr.count == ChannelsId.allCases.count {
                        completion(self.channelItems, self.playlistItems)
                    }
                }
            }
        }
    }
    
    private func getAllChannels(completion: @escaping ([ChannelModel]) -> Void) {
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
    
    func getImgFromUrl(_ link: String, completion: @escaping (UIImage) -> Void) {
////        func downloaded(from url: URL, contentMode mode: ContentMode = .scaleAspectFit) {
//            print("URL: \(url)")
//        contentMode: ContentMode = .scaleAspectFit
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
//        }
    }
    
//    func getChannelItems(completion: @escaping ([ChannelItemsStub]) -> Void ) {
//        self.getAllChannels() { arr in
//            arr.forEach { item in
//                let newItem = ChannelItemsStub(channelTittle: item.items[0].title,
//                                               playListId: item.items[0].playListId,
//                                               channelImg: item.items[0].imgUrl,
//                                               subscribers: item.items[0].subscriberCount)
//                self.channelItems.append(newItem)
//            }
//            completion(self.channelItems)
//        }
//    }
    
    func getAllPlaylists(_ playlistId: String, completion: @escaping (PlaylistModel) -> Void) {
        print("LIST: \(channelItems)")
//        dataModel.getPlaylist(playlistId) { data in
//            completion(data)
//
//        }
    }
    
    
}
