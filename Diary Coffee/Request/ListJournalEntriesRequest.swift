//
//  ListJournalEntriesRequest.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 4.11.2024.
//

import Foundation
import Alamofire
import UIKit

class ListJournalEntriesRequest {
    static let shared = ListJournalEntriesRequest()

    func listJournalEntries(
        userId: String,
        journalDate: String?,
        journalId: String?,
        in view: UIView,
        completion: @escaping (Result<ListJournalEntriesResponse, AFError>) -> Void
    ) {
        let parameters = ListJournalEntriesQuery(
            userId: userId,
            journalDate: journalDate ?? "",
            journalId: journalId ?? ""
        ).getBody()
        
        APIServices.shared.R_ListJournalEntries(with: parameters) { result in
            switch result {
            case .success(let response):
                if response.resultCode == 200 {
                    completion(.success(response))
                } else if response.resultCode == 404,
                          response.resultMessage == "Kayıt bulunamadı.",
                          response.journalEntriesInfoList?.isEmpty == true {
                   
                    completion(.failure(AFError.explicitlyCancelled))
                } else {
                 
                    DispatchQueue.main.async {
                        self.showProblemView(state: .defaultState)
                    }
                    completion(.failure(AFError.explicitlyCancelled))
                }
            case .failure:
               
              DispatchQueue.main.async {
                    self.showProblemView(state: .defaultState)
                }
                completion(.failure(AFError.explicitlyCancelled))
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

