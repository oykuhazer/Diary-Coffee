//
//  EmotionSetQuery.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 29.11.2024.
//

import Foundation

class EmotionSetQuery {
    var emotionSet: String

    init(emotionSet: String) {
        self.emotionSet = emotionSet
    }
    
    func getBody() -> [String: Any] {
        return [
            "emotionSet": emotionSet
        ]
    }
}
