//
//  SaveJournalEntryResponse.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 4.11.2024.
//

import Foundation

struct SaveJournalEntryResponse: Codable {
    let resultCode: Int
    let resultMessage: String
   
    enum CodingKeys: String, CodingKey {
        case resultCode = "ResultCode"
        case resultMessage = "ResultMessage"
       
    }
}
