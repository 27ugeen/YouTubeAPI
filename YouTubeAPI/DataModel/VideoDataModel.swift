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
    case playlistTitle = "https://youtube.googleapis.com/youtube/v3/playlists?part=snippet&key="
    case playlist = "https://youtube.googleapis.com/youtube/v3/playlistItems?part=snippet&maxResults=10&key="
    case video = "https://youtube.googleapis.com/youtube/v3/videos?part=snippet&part=statistics&part=player&key="
}

enum ChannelsId: String, CaseIterable {
    case arminVanBuuren = "UCu5jfQcpRLm9xhmlSd5S8xw"
    case travels = "UCc3Qxl2JWMyvEUpDIbWwzXA"
    case deepMode = "UCX-USfenzQlhrEJR1zD5IYw"
    case sport = "UCb4_z-mud9YU0b0ine0vs1A"
    //    case earthRelaxation = "UCS4jPUCax8d3f-uke--YXXQ"
    //    case vevo = "UC2pmfLm7iq6Ov1UwYrWYkZA"
}

enum PlayListsId: String, CaseIterable {
    case vevo = "PL9tY0BWXOZFu8MzzbNVtUvHs0cQ_gZ03m"
    case sport = "PLchjfZeSTX5ZgpPf5mIeelFsuXAf1Z3NV"
    //    case vevo2 = "PL9tY0BWXOZFv8JKRhQtU4elLD73E3kvvo"
    case avb = "UUu5jfQcpRLm9xhmlSd5S8xw"
}

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

struct VideoModel: Decodable {
    let items: [VideoItems]
    enum CodingKeys: String, CodingKey {
        case items
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        items = try container.decode([VideoItems].self, forKey: .items)
    }
}

struct VideoItems: Decodable {
    
    enum CodingKeys: String, CodingKey {
        //        case player
        case snippet
        case statistics
    }
    
    enum SnippetCodingKeys: String, CodingKey {
        case thumbnails
    }
    
    enum ThumbnailsCodingKeys: String, CodingKey {
        case high
    }
    
    let imgUrl: String
    enum HighCodingKeys: String, CodingKey {
        case imgUrl = "url"
    }
    
    let viewCount: String
    enum StatisticsCodingKeys: String, CodingKey {
        case viewCount
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        //=====================snippet===========================
        let snippetContainer = try container.nestedContainer(keyedBy: SnippetCodingKeys.self, forKey: .snippet)
        //=====================thumbnails========================
        let thumbContainer = try snippetContainer.nestedContainer(keyedBy: ThumbnailsCodingKeys.self, forKey: .thumbnails)
        //=====================high==============================
        let highContainer = try thumbContainer.nestedContainer(keyedBy: HighCodingKeys.self, forKey: .high)
        imgUrl = try highContainer.decode(String.self, forKey: .imgUrl)
        //=====================viewCount=========================
        let statisticsContainer = try container.nestedContainer(keyedBy: StatisticsCodingKeys.self, forKey: .statistics)
        viewCount = try statisticsContainer.decode(String.self, forKey: .viewCount)
    }
}

struct PlayListTitleModel: Decodable {
    let items: [PlaylistTitleItems]
    enum CodingKeys: String, CodingKey {
        case items
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        items = try container.decode([PlaylistTitleItems].self, forKey: .items)
    }
}

struct PlaylistTitleItems: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case snippet
    }
    
    let playlistTitle: String
    enum TitleCodingKeys: String, CodingKey {
        case playlistTitle = "title"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        //=====================snippet===========================
        let snippetContainer = try container.nestedContainer(keyedBy: TitleCodingKeys.self, forKey: .snippet)
        playlistTitle = try snippetContainer.decode(String.self, forKey: .playlistTitle)
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
    let videoTitle: String
    enum SnippetCodingKeys: String, CodingKey {
        case channelTitle
        case videoTitle = "title"
        
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
    enum HighCodingKeys: String, CodingKey {
        case imgUrl = "url"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        //=====================snippet===========================
        let snippetContainer = try container.nestedContainer(keyedBy: SnippetCodingKeys.self, forKey: .snippet)
        channelTitle = try snippetContainer.decode(String.self, forKey: .channelTitle)
        videoTitle = try snippetContainer.decode(String.self, forKey: .videoTitle)
        //=====================resourceId========================
        let resourceIdContainer = try snippetContainer.nestedContainer(keyedBy: ResourceIdCodingKeys.self, forKey: .resourceId)
        videoId = try resourceIdContainer.decode(String.self, forKey: .videoId)
        //=====================thumbnails========================
        let thumbContainer = try snippetContainer.nestedContainer(keyedBy: ThumbnailsCodingKeys.self, forKey: .thumbnails)
        //=====================high==============================
        let standardContainer = try thumbContainer.nestedContainer(keyedBy: HighCodingKeys.self, forKey: .high)
        imgUrl = try standardContainer.decode(String.self, forKey: .imgUrl)
    }
}

protocol VideoDataModelProtocol {
    func getVideoData<Model: Decodable>(_ headUrl: String,
                                        _ queryIdStr: String,
                                        _ id: String,
                                        completion: @escaping (Model) -> Void)
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
    
    private func createUrl(_ headUrl: String, _ queryId: String, _ id: String) -> String {
        let head = headUrl
        let apiKey = self.encodeApiKey(apiKey)
        let qStr = "\(queryId)\(id)"
        return head + apiKey + qStr
    }
    
    func getVideoData<Model: Decodable>(_ headUrl: String,
                                        _ queryIdStr: String,
                                        _ id: String,
                                        completion: @escaping (Model) -> Void) {
        let cUrl = self.createUrl(headUrl, queryIdStr, id)
        
        if let url = URL(string: cUrl) {
            let decoder = JSONDecoder()
            let request = AF.request(url)
            
            request.validate().responseDecodable(of: Model.self, decoder: decoder) { data in
                if let uValue = data.value {
                    completion(uValue)
                }
            }
        }
    }
    
    //TODO: - need put into one func
//    func getVideo(_ vId: String, completion: @escaping (VideoModel) -> Void) {
//        let cUrl = self.createUrl(VideoURLs.video.rawValue, "&id=", vId)
//        //        print(cUrl)
//        
//        if let url = URL(string: cUrl) {
//            let decoder = JSONDecoder()
//            let request = AF.request(url)
//            
//            request.validate().responseDecodable(of: VideoModel.self, decoder: decoder) { data in
//                if let uValue = data.value {
//                    completion(uValue)
//                }
//            }
//        }
//    }
    //TODO: - need put into one func
//    func getPlaylistTitle(_ plId: String, completion: @escaping (PlayListTitleModel) -> Void) {
//        let cUrl = self.createUrl(VideoURLs.playlistTitle.rawValue, "&id=", plId)
//        
//        if let url = URL(string: cUrl) {
//            let decoder = JSONDecoder()
//            let request = AF.request(url)
//            
//            request.validate().responseDecodable(of: PlayListTitleModel.self, decoder: decoder) { data in
//                if let uValue = data.value {
//                    completion(uValue)
//                }
//            }
//        }
//    }
    //TODO: - need put into one func
//    func getPlaylistItems(_ plId: String, completion: @escaping (PlaylistModel) -> Void) {
//        let cUrl = self.createUrl(VideoURLs.playlist.rawValue, "&playlistId=", plId)
//        
//        if let url = URL(string: cUrl) {
//            let decoder = JSONDecoder()
//            let request = AF.request(url)
//            
//            request.validate().responseDecodable(of: PlaylistModel.self, decoder: decoder) { data in
//                if let uValue = data.value {
//                    
//                    completion(uValue)
//                }
//            }
//        }
//    }
    //TODO: - need put into one func
//    func getChannel(_ chId: String, completion: @escaping (ChannelModel) -> Void) {
//        let cUrl = self.createUrl(VideoURLs.channel.rawValue, "&id=", chId)
//        
//        if let url = URL(string: cUrl) {
//            let decoder = JSONDecoder()
//            let request = AF.request(url)
//            
//            request.validate().responseDecodable(of: ChannelModel.self, decoder: decoder) { data in
//                if let uValue = data.value {
//                    completion(uValue)
//                }
//            }
//        }
//    }
}
