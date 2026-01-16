//
//  SaveJournalEntryRequest.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 4.11.2024.
//

import Foundation
import Alamofire
import UIKit

class SaveJournalEntryRequest {
    static let shared = SaveJournalEntryRequest()

    func saveJournalEntry(
        userId: String,
        journalEntryId: String,
        journalEntryDate: String,
        coffeeMoodType: String,
        coffeeMomentType: String,
        coffeeType: String,
        coffeeJournalText: String,
        coffeeMomentPhotoList: [[String: String]],
        coffeeMomentStickerList: [[String: String]],
        completion: @escaping (Result<SaveJournalEntryResponse, AFError>) -> Void
    ) {
        let parameters = SaveJournalEntryQuery(
            userId: userId,
            journalEntryId: journalEntryId,
            journalEntryDate: journalEntryDate,
            coffeeMoodType: coffeeMoodType,
            coffeeMomentType: coffeeMomentType,
            coffeeType: coffeeType,
            coffeeJournalText: coffeeJournalText,
            coffeeMomentPhotoList: coffeeMomentPhotoList,
            coffeeMomentStickerList: coffeeMomentStickerList
        ).getBody()

        APIServices.shared.R_SaveJournalEntry(with: parameters) { result in
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
