//
//  DeleteUserProfileResponse.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 4.12.2024.
//

import Foundation

struct DeleteUserProfileResponse: Codable {
    let resultCode: Int
    let resultMessage: String
   
    
    enum CodingKeys: String, CodingKey {
        case resultCode = "ResultCode"
        case resultMessage = "ResultMessage"
      
    }
}

