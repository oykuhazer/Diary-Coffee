//
//  EmotionSetResponse.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 29.11.2024.
//

import Foundation

struct EmotionSetResponse: Codable {
    let resultCode: Int
    let resultMessage: String
    let emotionSets: [EmotionSet]?
    let emotionSet: EmotionSet?

    enum CodingKeys: String, CodingKey {
        case resultCode = "ResultCode"
        case resultMessage = "ResultMessage"
        case emotionSets = "EmotionSets"
        case emotionSet = "EmotionSet"
    }
}

struct EmotionSet: Codable {
    let setName: String
    let images: [String]

    enum CodingKeys: String, CodingKey {
        case setName = "SetName"
        case images = "Images"
    }
}
