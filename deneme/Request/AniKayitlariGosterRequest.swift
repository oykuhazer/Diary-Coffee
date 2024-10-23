//
//  AniKayitlariGosterRequest.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 8.10.2024.
//

import Foundation
import Alamofire

class AniKayitlariGosterRequest {
    static let shared = AniKayitlariGosterRequest()

    func fetchAniKayitlari(userId: String, eventId: String, completion: @escaping (Result<AniKayitlariResponse, AFError>) -> Void) {
        
       
        let parameters = AniKayitlariGosterQuery(userId: userId, eventId: eventId).getBody()

      
        APIServices.shared.R_AniKayitlariGoster(with: parameters, completion: completion)
    }
}
