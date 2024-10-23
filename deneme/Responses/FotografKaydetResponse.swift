//
//  FotografKaydetResponse.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 7.10.2024.
//

import Foundation

struct FotografKaydetResponse: Codable {
    let resultCode: Int
    let resultMessage: String
    let insertedGUID: String?

    enum CodingKeys: String, CodingKey {
        case resultCode = "ResultCode"
        case resultMessage = "ResultMessage"
        case insertedGUID = "InsertedGUID"
    }
}
