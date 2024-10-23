//
//  APIServices.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 29.09.2024.
//

import Foundation
import Alamofire

class APIServices {
    static let shared = APIServices()

  private let baseURL = "http://172.2.2.94:3000"
    
   // private let baseURL = "http://localhost:3000"
   
    
    func R_FotografKaydet(with parameters: [String: Any], completion: @escaping (Result<FotografKaydetResponse, AFError>) -> Void) {
        let url = "\(baseURL)/FotografKaydet"
        makeRequest(url: url, method: .post, parameters: parameters, completion: completion)
    }
    
    func R_FotografSil(with parameters: [String: Any], completion: @escaping (Result<FotografSilResponse, AFError>) -> Void) {
        let url = "\(baseURL)/FotografSil"
        makeRequest(url: url, method: .delete, parameters: parameters, completion: completion)
    }
 
    func R_AniKaydet(with parameters: [String: Any], completion: @escaping (Result<AniKaydetResponse, AFError>) -> Void) {
        let url = "\(baseURL)/AniKaydet"
        makeRequest(url: url, method: .post, parameters: parameters, completion: completion)
    }
    
    func R_AniKayitlariGoster(with parameters: [String: Any], completion: @escaping (Result<AniKayitlariResponse, AFError>) -> Void) {
        let url = "\(baseURL)/AniKayitlariGoster"
        makeRequest(url: url, method: .post, parameters: parameters, completion: completion)
    }
    
    private func makeRequest<T: Codable>(url: String, method: HTTPMethod, parameters: [String: Any], completion: @escaping (Result<T, AFError>) -> Void) {
        AF.request(url, method: method, parameters: parameters, encoding: JSONEncoding.default)
            .validate()
            .responseDecodable(of: T.self) { response in
                completion(response.result)
            }
    }
}
