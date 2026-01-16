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
    
    private let baseURL = "http://172.2.1.51:3000"
    
    private var requestCount: Int = 0
    
    func R_StickerList(with parameters: [String: Any], completion: @escaping (Result<StickerResponse, AFError>) -> Void) {
        let url = "\(baseURL)/GetStickers"
        makeRequest(url: url, method: .post, parameters: parameters, completion: completion)
    }
    
    func R_GetEmotionSetList(with parameters: [String: Any], completion: @escaping (Result<EmotionSetResponse, AFError>) -> Void) {
        let url = "\(baseURL)/GetEmotionSet"
        makeRequest(url: url, method: .post, parameters: parameters, completion: completion)
    }
    
    func R_GetPrimeEmotionSet(with parameters: [String: Any], completion: @escaping (Result<PrimeEmotionSetResponse, AFError>) -> Void) {
        let url = "\(baseURL)/GetPrimeEmotionSet"
        makeRequest(url: url, method: .post, parameters: parameters, completion: completion)
    }
    
    func R_SaveUserProfile(with parameters: [String: Any], completion: @escaping (Result<SaveUserProfileResponse, AFError>) -> Void) {
        let url = "\(baseURL)/SaveUserProfile"
        makeRequest(url: url, method: .post, parameters: parameters, completion: completion)
    }
   
    func R_GetUserProfileInformation(with parameters: [String: Any], completion: @escaping (Result<GetUserProfileInformationResponse, AFError>) -> Void) {
        let url = "\(baseURL)/GetUserProfileInformation"
        makeRequest(url: url, method: .post, parameters: parameters, completion: completion)
    }
 
    func R_SaveJournalEntry(with parameters: [String: Any], completion: @escaping (Result<SaveJournalEntryResponse, AFError>) -> Void) {
        let url = "\(baseURL)/SaveJournalEntry"
        makeRequest(url: url, method: .post, parameters: parameters, completion: completion)
    }

    func R_ListJournalEntries(with parameters: [String: Any], completion: @escaping (Result<ListJournalEntriesResponse, AFError>) -> Void) {
        let url = "\(baseURL)/ListJournalEntries"
        makeRequest(url: url, method: .post, parameters: parameters, completion: completion)
    }
 
    func R_DeleteJournalEntry(with parameters: [String: Any], completion: @escaping (Result<DeleteJournalEntryResponse, AFError>) -> Void) {
        let url = "\(baseURL)/DeleteJournalEntry"
        makeRequest(url: url, method: .post, parameters: parameters, completion: completion)
    }

    func R_DeleteUserProfile(with parameters: [String: Any], completion: @escaping (Result<DeleteUserProfileResponse, AFError>) -> Void) {
        let url = "\(baseURL)/DeleteUserProfile"
        makeRequest(url: url, method: .post, parameters: parameters, completion: completion)
    }
    
    private func makeRequest<T: Codable>(url: String, method: HTTPMethod, parameters: [String: Any], completion: @escaping (Result<T, AFError>) -> Void) {
        requestCount += 1
        print("\(requestCount)")


        AF.request(url, method: method, parameters: parameters, encoding: JSONEncoding.default)
            .validate()
            .responseDecodable(of: T.self) { response in
                switch response.result {
                case .success(let data): break
                    
                case .failure(let error):
                    print("❌ Error #\(self.requestCount): \(error)")
                }
                completion(response.result)
            }
    }
}
