//
//  FotografSilRequest.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 7.10.2024.
//

import Foundation
import Alamofire

class FotografSilRequest {
    static let shared = FotografSilRequest()

    func deletePhoto(guid: String, completion: @escaping (Result<FotografSilResponse, AFError>) -> Void) {
        
     
        let parameters = FotografSilQuery(guid: guid).getBody()
        
    
        APIServices.shared.R_FotografSil(with: parameters, completion: completion)
    }
}
