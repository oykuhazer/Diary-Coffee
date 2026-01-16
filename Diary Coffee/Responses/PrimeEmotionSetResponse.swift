//
//  PrimeEmotionSetResponse.swift
//  DailyCoffee
//
//  Created by Öykü Hazer Ekinci on 10.12.2024.
//

import Foundation

struct PrimeEmotionSetResponse: Codable {
    let resultCode: Int
    let resultMessage: String
    let primeEmotionSets: [PrimeEmotionSet]?
    let primeEmotionSet: PrimeEmotionSet?

    enum CodingKeys: String, CodingKey {
        case resultCode = "ResultCode"
        case resultMessage = "ResultMessage"
        case primeEmotionSets = "PrimeEmotionSets"
        case primeEmotionSet = "PrimeEmotionSet"
    }
}

struct PrimeEmotionSet: Codable {
    let setName: String
    let images: [String]

    enum CodingKeys: String, CodingKey {
        case setName = "SetName"
        case images = "Images"
    }
}
