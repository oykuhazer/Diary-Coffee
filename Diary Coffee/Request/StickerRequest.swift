//
//  StickerRequest.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 2.11.2024.
//


import Alamofire
import UIKit

class StickerRequest {
    static let shared = StickerRequest()

    func uploadSticker(category: String, completion: @escaping (Result<StickerResponse, AFError>) -> Void) {
        let parameters = StickerQuery(category: category).getBody()

        APIServices.shared.R_StickerList(with: parameters) { result in
            switch result {
            case .success(let response):
                if response.resultCode == 200 {
                    completion(.success(response))
                } else {
                    DispatchQueue.main.async {
                        self.showProblemView(state: .defaultState)
                    }
                    completion(.failure(AFError.explicitlyCancelled))
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.showProblemView(state: .defaultState)
                }
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
