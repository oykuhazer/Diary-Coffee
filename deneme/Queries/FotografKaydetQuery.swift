//
//  FotografKaydetmeQuery.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 7.10.2024.
//

import Foundation

class FotografKaydetQuery {
    var fileName: String
    var userID: String
    var eventID: String
    var eventDate: String
    var photoContent: String
    
    init(fileName: String, userID: String, eventID: String, eventDate: String, photoContent: String) {
        self.fileName = fileName
        self.userID = userID
        self.eventID = eventID
        self.eventDate = eventDate
        self.photoContent = photoContent
    }
    
    func getBody() -> [String: Any] {
        return [
            "FileName": fileName,
            "UserID": String(userID),
            "EventID": String(eventID),
            "EventDate": eventDate,
            "PhotoContent": photoContent
        ]
    }
}
