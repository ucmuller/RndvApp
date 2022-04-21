//
//  Firebase.swift
//  Gururi
//
//  Created by Naoki Muroya on 2019/02/18.
//  Copyright © 2019 Gururi. All rights reserved.
//

import Firebase

// MARK: - Global Constants
let DB = Firestore.firestore()
let STORAGE = Storage.storage()
let AUTH = Auth.auth()

let INVITATION_REF = DB.collection("invitations")
let STAFF_REF = DB.collection("staff")
let SHOPS_REF = DB.collection("shops")
let MASTER_REF = DB.collection("master")
let REFERRAL_REF = DB.collection("referral")
let NOTIFICATION_REF = DB.collection("notifications")

let EMPLOYMENT_STATUS_MASTER = MASTER_REF.document("employment_status")
let UNAPPROVED_REASON_MASTER = MASTER_REF.document("unapproved_reason")
