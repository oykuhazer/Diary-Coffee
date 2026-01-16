//
//  StickerQuery.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 2.11.2024.
//

import Foundation

class StickerQuery {
    var category: String

    init(category: String) {
        self.category = category
    }
    
    func getBody() -> [String: Any] {
        return [
            "category": category
        ]
    }
}
