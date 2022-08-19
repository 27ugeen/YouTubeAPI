//
//  Model.swift
//  YouTubeAPI
//
//  Created by GiN Eugene on 18/8/2022.
//

import Foundation
import Alamofire

enum VideoURLs: String {
    case channels = "https://youtube.googleapis.com/youtube/v3/channels?part=contentDetails&part=statistics&part=snippet&key="

    case playList = "https://youtube.googleapis.com/youtube/v3/playlistItems?part=snippet&key="
    case video = ""
}

enum ChannelsId: String {
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

class VideoDataModel {
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
    
    private func createURLForChannels(_ chId: String) -> String {
        let headRL = VideoURLs.channels.rawValue
        let apiKey = self.encodeApiKey(apiKey)
        let qStr = "&id=\(chId)"
        let resultURL = headRL + apiKey + qStr
        return resultURL
    }
    
//    private func createURLForPlayList(_ plId: String) -> String {
//        let headRL = VideoURLs.playList.rawValue
//        let apiKey = self.encodeApiKey(apiKey)
//        let qStr = "&playlistId=\(plId)"
//        let resultURL = headRL + apiKey + qStr
//        return resultURL
//    }
    
    func getChannel(_ chId: String, completion: @escaping (ChannelModel) -> Void) {
        let cUrl = self.createURLForChannels(chId)
        
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
    
    func getChannel1() {
        let cUrl = self.createURLForChannels(ChannelsId.travels.rawValue)

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
