//
//  FotografSilQuery.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 7.10.2024.
//

import Foundation

class FotografSilQuery {
    var guid: String
    
    init(guid: String) {
        self.guid = guid
    }
    
    func getBody() -> [String: Any] {
        return ["GUID": guid]
    }
}
