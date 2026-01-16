//
//   DeleteJournalEntryRequest.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 5.11.2024.
//

import Foundation
import Alamofire
import UIKit

class DeleteJournalEntryRequest {
    static let shared = DeleteJournalEntryRequest()

    func deleteJournalEntry(
        userId: String,
        journalEntryId: String,
        completion: @escaping (Result<DeleteJournalEntryResponse, AFError>) -> Void
    ) {
        let parameters = DeleteJournalEntryQuery(
            userId: userId,
            journalEntryId: journalEntryId
        ).getBody()

        APIServices.shared.R_DeleteJournalEntry(with: parameters) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    if response.resultCode == 200 {
                        completion(.success(response))
                    } else if response.resultCode == 404 {
                        completion(.failure(AFError.explicitlyCancelled))
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
