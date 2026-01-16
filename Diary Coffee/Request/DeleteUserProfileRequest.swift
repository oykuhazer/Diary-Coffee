//
//  DeleteUserProfileRequest.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 4.12.2024.
//

import Foundation
import Alamofire
import UIKit

class DeleteUserProfileRequest {
    static let shared = DeleteUserProfileRequest()

    func deleteUserProfile(
        uuid: String,
        completion: @escaping (Result<DeleteUserProfileResponse, AFError>) -> Void
    ) {
        let parameters = DeleteUserProfileQuery(uuid: uuid).getBody()

        APIServices.shared.R_DeleteUserProfile(with: parameters) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    if response.resultCode == 200 {
                        completion(.success(response))
                    } else {
                        self.showProblemView(state: .defaultState)
                        completion(.failure(AFError.explicitlyCancelled))
                    }
                case .failure(let error):
                    self.showProblemView(state: .defaultState)
                    completion(.failure(error))
                }
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
