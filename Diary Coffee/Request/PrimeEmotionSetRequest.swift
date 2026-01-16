//
//  PrimeEmotionSetRequest.swift
//  DailyCoffee
//
//  Created by Öykü Hazer Ekinci on 10.12.2024.
//

import Foundation
import Alamofire
import UIKit

class PrimeEmotionSetRequest {
    static let shared = PrimeEmotionSetRequest()

    func uploadPrimeEmotionSet(
        primeEmotionSet: String,
        in view: UIView,
        completion: @escaping (Result<PrimeEmotionSetResponse, AFError>) -> Void
    ) {
        let parameters = PrimeEmotionSetQuery(primeEmotionSet: primeEmotionSet).getBody()

        APIServices.shared.R_GetPrimeEmotionSet(with: parameters) { result in
            switch result {
            case .success(let response):
                if response.resultCode == 200 {
                   
                    completion(.success(response))
                } else {
                   
                    DispatchQueue.main.async {
                        self.showProblemView(state: .maintenance)
                    }
                    completion(.failure(AFError.explicitlyCancelled))
                }
            case .failure(let error):
               
                DispatchQueue.main.async {
                    self.showProblemView(state: .maintenance)
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
