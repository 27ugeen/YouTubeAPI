//
//  Model.swift
//  YouTubeAPI
//
//  Created by GiN Eugene on 18/8/2022.
//

import Foundation
import Alamofire

enum VideoURLs: String {
    case channel = "https://youtube.googleapis.com/youtube/v3/channels?part=contentDetails&part=statistics&part=snippet&key="
    case playlist = "https://youtube.googleapis.com/youtube/v3/playlistItems?part=snippet&maxResults=1&key="
    case video = ""
}



enum ChannelsId: String, CaseIterable {
    case arminVanBuuren = "UCu5jfQcpRLm9xhmlSd5S8xw"
    case earthRelaxation = "UCS4jPUCax8d3f-uke--YXXQ"
    case travels = "UCc3Qxl2JWMyvEUpDIbWwzXA"
    case deepMode = "UCX-USfenzQlhrEJR1zD5IYw"
}

//enum PlayListsId: String {
//    case vevo = "PL9tY0BWXOZFvcTuePgQKjjbdTmCIn5SHW"
//}

struct ChannelModel: Decodable {
    let items: [ChannelItems]
    enum CodingKeys: String, CodingKey {
        case items
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        items = try container.decode([ChannelItems].self, forKey: .items)
    }
}

struct ChannelItems: Decodable {

    enum CodingKeys: String, CodingKey {
        case contentDetails
        case snippet
        case statistics
    }
    //===contentDetails===
    enum ContDetCodingKeys: String, CodingKey {
        case relatedPlaylists
    }
    
    let playListId: String
    enum RelatedPlaylistCodingKeys: String, CodingKey {
        case playListId = "uploads"
    }
    //===snippet==========
    let title: String
    enum SnippetCodingKeys: String, CodingKey {
        case thumbnails
        case title
    }

    enum ThumbnailsCodingKeys: String, CodingKey {
        case hImgUrl = "high"
    }

    let imgUrl: String
    enum ImgUrlCodingKeys: String, CodingKey {
        case imgUrl = "url"
    }
    //===statistics=======
    let subscriberCount: String
    enum SubscriberCodingKeys: String, CodingKey {
        case subscriberCount
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        //=====================contentDetails====================
        let contDetContainer = try container.nestedContainer(keyedBy: ContDetCodingKeys.self, forKey: .contentDetails)
        //=====================relatedPlaylists==================
        let relatedPLContainer = try contDetContainer.nestedContainer(keyedBy: RelatedPlaylistCodingKeys.self, forKey: .relatedPlaylists)
        playListId = try relatedPLContainer.decode(String.self, forKey: .playListId)
        //=====================snippet===========================
        let snippetContainer = try container.nestedContainer(keyedBy: SnippetCodingKeys.self, forKey: .snippet)
        title = try snippetContainer.decode(String.self, forKey: .title)
        //=====================thumbnails========================
        let thumbContainer = try snippetContainer.nestedContainer(keyedBy: ThumbnailsCodingKeys.self, forKey: .thumbnails)
        //=====================hImgUrl===========================
        let hImgUrlContainer = try thumbContainer.nestedContainer(keyedBy: ImgUrlCodingKeys.self, forKey: .hImgUrl)
        imgUrl = try hImgUrlContainer.decode(String.self, forKey: .imgUrl)
        //=====================statistics========================
        let statContainer = try container.nestedContainer(keyedBy: SubscriberCodingKeys.self, forKey: .statistics)
        subscriberCount = try statContainer.decode(String.self, forKey: .subscriberCount)
    }
}

struct PlaylistModel: Decodable {
    let items: [PlaylistItems]
    enum CodingKeys: String, CodingKey {
        case items
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        items = try container.decode([PlaylistItems].self, forKey: .items)
    }
}

struct PlaylistItems: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case snippet
    }
    
    let channelTitle: String
    let playlistTitle: String
    enum SnippetCodingKeys: String, CodingKey {
        case channelTitle
        case playlistTitle = "title"

        case resourceId
        case thumbnails
    }

    let videoId: String
    enum ResourceIdCodingKeys: String, CodingKey {
        case videoId
    }

    enum ThumbnailsCodingKeys: String, CodingKey {
        case high
    }

    let imgUrl: String
    enum StandardcodingKeys: String, CodingKey {
        case imgUrl = "url"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        //=====================snippet===========================
        let snippetContainer = try container.nestedContainer(keyedBy: SnippetCodingKeys.self, forKey: .snippet)
        channelTitle = try snippetContainer.decode(String.self, forKey: .channelTitle)
        playlistTitle = try snippetContainer.decode(String.self, forKey: .playlistTitle)
        //=====================resourceId========================
        let resourceIdContainer = try snippetContainer.nestedContainer(keyedBy: ResourceIdCodingKeys.self, forKey: .resourceId)
        videoId = try resourceIdContainer.decode(String.self, forKey: .videoId)
        //=====================thumbnails========================
        let thumbContainer = try snippetContainer.nestedContainer(keyedBy: ThumbnailsCodingKeys.self, forKey: .thumbnails)
        //=====================high==============================
        let standardContainer = try thumbContainer.nestedContainer(keyedBy: StandardcodingKeys.self, forKey: .high)
        imgUrl = try standardContainer.decode(String.self, forKey: .imgUrl)
    }
}

protocol VideoDataModelProtocol {
    func createUrl(_ headUrl: String, _ queryId: String, _ id: String) -> String
}

class VideoDataModel: VideoDataModelProtocol {
    //MARK: - props
    private var apiKey: Data {
        get {
            guard let filePath = Bundle.main.path(forResource: "Info", ofType: "plist") else {
                fatalError("Couldn't find file 'Info.plist'.")
            }
            let plist = NSDictionary(contentsOfFile: filePath)
            guard let value = plist?.object(forKey: "API_KEY") as? Data else {
                fatalError("Couldn't find key 'API_KEY' in 'Info.plist'.")
            }
            return value
        }
    }
    //MARK: - methods
    private func encodeApiKey(_ key: Data) -> String {
        let key = String(data: key, encoding: .utf8)
        return key ?? ""
    }
    
//    private func createURLForChannels(_ chId: String) -> String {
//        let headRL = VideoURLs.channels.rawValue
//        let apiKey = self.encodeApiKey(apiKey)
//        let qStr = "&id=\(chId)"
//        let resultURL = headRL + apiKey + qStr
//        return resultURL
//    }
    
//    private func createURLForPlayList(_ plId: String) -> String {
//        let headRL = VideoURLs.playList.rawValue
//        let apiKey = self.encodeApiKey(apiKey)
//        let qStr = "&playlistId=\(plId)"
//        let resultURL = headRL + apiKey + qStr
//        return resultURL
//    }
    
    func createUrl(_ headUrl: String, _ queryId: String, _ id: String) -> String {
        let head = headUrl
        let apiKey = self.encodeApiKey(apiKey)
        let qStr = "\(queryId)\(id)"
        return head + apiKey + qStr
    }
    
    func getPlaylist(_ plId: String, completion: @escaping (PlaylistModel) -> Void) {
        let cUrl = self.createUrl(VideoURLs.playlist.rawValue, "&playlistId=", plId)
//        print(cUrl)
        
        if let url = URL(string: cUrl) {
            let decoder = JSONDecoder()
            let request = AF.request(url)
            
            request.validate().responseDecodable(of: PlaylistModel.self, decoder: decoder) { data in
                if let uValue = data.value {
                    completion(uValue)
                }
            }
        }
    }
    
    func getChannel(_ chId: String, completion: @escaping (ChannelModel) -> Void) {
        let cUrl = self.createUrl(VideoURLs.channel.rawValue, "&id=", chId)
        
        if let url = URL(string: cUrl) {
            let decoder = JSONDecoder()
            let request = AF.request(url)
            
            request.validate().responseDecodable(of: ChannelModel.self, decoder: decoder) { data in
                if let uValue = data.value {
                    completion(uValue)
                }
            }
        }
    }
    
    func decodeModelFromData(_ channelId: String, completion: @escaping (ChannelModel, PlaylistModel) -> Void) {
        self.getChannel(channelId) { channelModel in
            self.getPlaylist(channelModel.items[0].playListId) { playlistModel in
                completion(channelModel, playlistModel)
            }
        }
    }
    
    
    
    
    func getData() {
        let cUrl = self.createUrl(VideoURLs.playlist.rawValue, "&playlistId=", "PLh9bWygNPws3eKPY1NEp4eC_buZVqXNQu")
//        print(cUrl)
        
        let req = AF.request(cUrl)

        req.responseJSON { data in
            print(data)

        }
    }
    
//    func getPlayList() {
//        let cUrl = self.createURLForPlayList(PlayListsId.vevo.rawValue)
//
//        let req = AF.request(cUrl)
//
//        req.responseJSON { data in
//            print("Data: \(data)")
//
//        }
//
//    }
}
