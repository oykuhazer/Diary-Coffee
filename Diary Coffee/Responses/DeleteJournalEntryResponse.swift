//
//  DeleteJournalEntryResponse.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 5.11.2024.
//

import Foundation


struct DeleteJournalEntryResponse: Codable {
    let resultCode: Int
    let resultMessage: String
   
    enum CodingKeys: String, CodingKey {
        case resultCode = "ResultCode"
        case resultMessage = "ResultMessage"
       
    }
}
