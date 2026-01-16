//
//  GetUserProfileInformationRequest.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 4.11.2024.
//


import Foundation
import Alamofire
import UIKit

class GetUserProfileInformationRequest {
    static let shared = GetUserProfileInformationRequest()

    func fetchUserProfile(
        uuid: String,
        completion: @escaping (Result<GetUserProfileInformationResponse, AFError>) -> Void
    ) {
        let parameters = GetUserProfileInformationQuery(uuid: uuid).getBody()

        APIServices.shared.R_GetUserProfileInformation(with: parameters) { result in
            switch result {
            case .success(let response):
                if response.resultCode == 200 {
                    completion(.success(response))
                } else {
                /*    DispatchQueue.main.async {
                        self.showProblemView(state: .maintenance)
                    } */
                    completion(.failure(AFError.explicitlyCancelled))
                }
            case .failure(let error):
               /* DispatchQueue.main.async {
                  self.showProblemView(state: .maintenance)
                }*/
                completion(.failure(error))
            }
        }
    }

    private func showProblemView(state: ProblemView.ProblemState) {
        guard let window = UIApplication.shared.windows.first else { return }

        window.subviews.forEach { subview in
            if subview is ProblemView {
                subview.removeFromSuperview()
            }
        }

        let problemView = ProblemView(frame: window.bounds)
        problemView.state = state
        problemView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        window.addSubview(problemView)
        window.bringSubviewToFront(problemView)
    }
}
