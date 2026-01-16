//
//  GetUserProfileInformationQuery.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 4.11.2024.
//

import Foundation

class GetUserProfileInformationQuery {
    var uuid: String

    init(uuid: String) {
        self.uuid = uuid
    }
    
    func getBody() -> [String: Any] {
        return [
            "uuid": uuid
        ]
    }
}
