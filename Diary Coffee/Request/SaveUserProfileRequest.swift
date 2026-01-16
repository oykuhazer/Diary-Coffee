//
//  SaveUserProfileRequest.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 4.11.2024.
//

import Foundation
import Alamofire
import UIKit

class SaveUserProfileRequest {
    static let shared = SaveUserProfileRequest()

    func saveUserProfile(in view: UIView, completion: @escaping (Result<SaveUserProfileResponse, AFError>) -> Void) {
        let userProfile = UserProfile.shared

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"

        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"

        let birthDateString = userProfile.birthDate != nil ? dateFormatter.string(from: userProfile.birthDate!) : "N/A"
        let notificationTimeString = userProfile.notificationTime != nil ? timeFormatter.string(from: userProfile.notificationTime!) : "N/A"
        let premiumStartDateString = userProfile.premiumStartDate != nil ? dateFormatter.string(from: userProfile.premiumStartDate!) : nil

        let purchasedFeatures = PurchasedFeatures(
            stickers: userProfile.purchasedStickers,
            emotions: userProfile.purchasedEmotions
        )

        let parameters = SaveUserProfileQuery(
            uuid: userProfile.uuid,
            gender: userProfile.gender ?? "N/A",
            name: userProfile.name ?? "N/A",
            birthDate: birthDateString,
            styleSelection: userProfile.styleSelection ?? "N/A",
            isNotificationEnabled: userProfile.isNotificationEnabled,
            notificationTime: notificationTimeString,
            isPasscodeEnabled: userProfile.isPasscodeEnabled,
            passcodeType: userProfile.passcodeType ?? "N/A",
            passcodeCode: userProfile.passcodeCode ?? "N/A",
            language: userProfile.language ?? "English",
            quantityBeans: userProfile.quantityBeans ?? 0,
            profilePicture: userProfile.profilePicture ?? "N/A",
            purchasedFeatures: purchasedFeatures,
            premium: userProfile.premium,
            premiumType: userProfile.premiumType ?? "N/A",
            premiumStartDate: premiumStartDateString,
            premiumDaysLeft: userProfile.premiumDaysLeft ?? 0
        ).getBody()

        APIServices.shared.R_SaveUserProfile(with: parameters) { result in
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
