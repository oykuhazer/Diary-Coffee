//
//  FotografKaydetRequest.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 7.10.2024.
//

import Foundation
import Alamofire


class FotografKaydetRequest {
    static let shared = FotografKaydetRequest()

    func uploadPhoto(fileName: String, userID: String, eventID: String, eventDate: String, photoContent: String, completion: @escaping (Result<FotografKaydetResponse, AFError>) -> Void) {
        
       
        let parameters = FotografKaydetQuery(
            fileName: fileName,
            userID: userID,
            eventID: eventID,
            eventDate: eventDate,
            photoContent: photoContent
        ).getBody()
        
     
        APIServices.shared.R_FotografKaydet(with: parameters, completion: completion)
    }
}
