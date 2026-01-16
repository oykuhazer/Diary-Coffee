//
//  StickerResponse.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 2.11.2024.
//

import Foundation


struct StickerResponse: Codable {
    let resultCode: Int
    let resultMessage: String
    let images: [String]

    enum CodingKeys: String, CodingKey {
        case resultCode = "ResultCode"
        case resultMessage = "ResultMessage"
        case images = "Images"
    }
}
