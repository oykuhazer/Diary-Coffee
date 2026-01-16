//
//  PrimeEmotionSet.swift
//  DailyCoffee
//
//  Created by Öykü Hazer Ekinci on 10.12.2024.
//

import Foundation

class PrimeEmotionSetQuery {
    var primeEmotionSet: String

    init(primeEmotionSet: String) {
        self.primeEmotionSet = primeEmotionSet
    }
    
    func getBody() -> [String: Any] {
        return [
            "primeEmotionSet": primeEmotionSet
        ]
    }
}
