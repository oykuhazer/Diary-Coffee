//
//  AniKaydetResponse.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 7.10.2024.
//

import Foundation

struct AniKaydetResponse: Codable {
    let resultCode: Int
    let resultMessage: String

    enum CodingKeys: String, CodingKey {
        case resultCode = "ResultCode"
        case resultMessage = "ResultMessage"
    }
}
