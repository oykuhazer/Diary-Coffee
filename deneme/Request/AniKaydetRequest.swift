//
//  AniKaydetRequest.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 7.10.2024.
//

import Foundation
import Alamofire

class AniKaydetRequest {
    static let shared = AniKaydetRequest()

    func sendAniKaydet(
        userId: String,
        eventId: String,
        eventDescription: String,
        eventDate: String,
        coffeeEventDescription: String,
        images: [[String: Any]],
        completion: @escaping (Result<AniKaydetResponse, AFError>) -> Void
    ) {
        // Parametreleri hazırlıyoruz
        let parameters = AniKaydetQuery(
            userId: userId,
            eventId: eventId,
            eventDescription: eventDescription,
            eventDate: eventDate,
            coffeeEventDescription: coffeeEventDescription,
            images: images
        ).getBody()

        // API isteğini yapıyoruz
        APIServices.shared.R_AniKaydet(with: parameters, completion: completion)
    }
}
