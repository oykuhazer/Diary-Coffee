//
//  DeleteUserProfileQuery.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 4.12.2024.
//

import Foundation

class DeleteUserProfileQuery {
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
