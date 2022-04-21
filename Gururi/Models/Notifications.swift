//
//  Invite.swift
//  Gururi
//
//  Created by Naoki Muroya on 2019/02/25.
//  Copyright © 2019 Gururi. All rights reserved.
//

import Foundation
import Firebase

class Notifications {
    
    var title: String
    var message: String
    var createdAt: Date
    var snsURLs: [String]

    init(title: String, message: String, createdAt: Timestamp, snsURLs: [String]) {
        self.title = title
        self.message = message
        self.createdAt = createdAt.dateValue()
        self.snsURLs = snsURLs
    }
}

extension Notifications {
    static func getNotificationData(handler: @escaping([Notifications]?, String?)->Void) {

        var notifications: [Notifications] = []

        NOTIFICATION_REF.getDocuments() { querySnapshot, error in
            if let error = error {
                let errorMessage = error.localizedDescription
                handler(nil, errorMessage)
            }
            if let querySnapshot = querySnapshot {
                for document in querySnapshot.documents {
                    let data = document.data()
                    guard
                        let title = data["title"] as? String,
                        let message = data["message"] as? String,
                        let createdAt = data["created_at"] as? Timestamp,
                        let snsURLs = [data["twitterURL"], data["facebookURL"], data["instagramURL"]] as? [String] else { return }
                    let notification = Notifications(title: title, message: message, createdAt: createdAt, snsURLs: snsURLs)
                    notifications.append(notification)
                }

                handler(notifications.sort(), nil)
            }
        }
    }
}

extension Array where Element: Notifications {
    func sort() -> [Notifications] {
        return sorted { $0.createdAt > $1.createdAt }
    }
}
