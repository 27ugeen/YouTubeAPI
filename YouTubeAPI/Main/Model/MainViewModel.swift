//
//  MainViewModel.swift
//  YouTubeAPI
//
//  Created by GiN Eugene on 19/8/2022.
//

import Foundation

struct ChannelItemsStub {
    let channelTittle: String
    let playListId: String
    let channelImg: String
    let subscribers: String
}

class MainViewModel {
    //MARK: - props
    private let dataModel: VideoDataModel
    
    //MARK: - init
    init(dataModel: VideoDataModel) {
        self.dataModel = dataModel
    }
    //MARKS: - methods
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
    
    func getChannelItems(completion: @escaping ([ChannelItemsStub]) -> Void ) {
        var channelItems: [ChannelItemsStub] = []
        self.getAllChannels() { arr in
            arr.forEach { item in
                let newItem = ChannelItemsStub(channelTittle: item.items[0].title,
                                               playListId: item.items[0].playListId,
                                               channelImg: item.items[0].imgUrl,
                                               subscribers: item.items[0].subscriberCount)
                channelItems.append(newItem)
            }
            completion(channelItems)
        }
    }
    
    
}
