//
//  Invite.swift
//  Gururi
//
//  Created by Naoki Muroya on 2019/02/25.
//  Copyright © 2019 Gururi. All rights reserved.
//

import Foundation
import Firebase

class Invitation {
    enum Status: Int, CaseIterable {
        case invited
        case waiting
        case reviewing
        case approved
        case paid

        var title: String {
            switch self {
            case .invited:
                return "招待済み"
            case .waiting:
                return "レシート待ち"
            case .reviewing:
                return "決済承認中"
            case .approved:
                return "承認済み"
            case .paid:
                return "支払い済み"
            }
        }

        var alertText: String {
            switch self {
            case .invited, .waiting:
                return "※レシートor伝票をアップロードしてください。\n※料金部分だけの撮影だと非承認になります。\n全体が映るように撮影して下さい。"
            default:
                return ""
            }
        }

        init(isReservation: Bool, reason: Int, isApproved: Bool, isPaid: Bool) {
            if !isReservation {
                self = .invited
            } else {
                if !isApproved {
                    self = reason == 1 ? .reviewing : .waiting
                } else {
                    self = isPaid ? .paid : .approved
                }
            }
        }
    }
    
    var id: String
    var staffId: String
    var staffName: String
    var shopName: String?
    var date: String
    var time: String
    var people: Int
    var guestId: String?
    var guestName: String
    var guestTel: String
    var isReservation: Bool
    var isApproved: Bool
    var isPaid: Bool
    var unapprovedReasonNumber: Int
    var unapprovedReasonString: String?
    var createdAt: Date
    var updatedAt: Date
    var status: Status
    var totalPrice: Int?
    var rewardPrice: Int?
    var receiptImageTitle: String?
    var couponPrice: Int?
    var couponBalance: Int?
    var couponNumber: String?
    var couponUrl: String?
    var couponName: String?
    var couponLogs: [[String: Any]] = []
    
    init(id: String, staffId: String, staffName: String, shopName:String?, date: String, time: String, people: Int, guestId: String?, guestName: String, guestTel: String, isReservation: Bool, isApproved: Bool, isPaid: Bool, unapprovedReasonNumber: Int, createdAt: Timestamp, updatedAt: Timestamp, totalPrice: Int?, receiptImageTitle: String?, couponPrice: Int?, couponBalance: Int?, couponNumber: String?, couponUrl: String?, couponName: String?) {

        self.id = id
        self.staffId = staffId
        self.staffName = staffName
        self.shopName = shopName
        self.date = date
        self.time = time
        self.people = people
        self.guestId = guestId
        self.guestName = guestName
        self.guestTel = guestTel
        self.isReservation = isReservation
        self.isApproved = isApproved
        self.isPaid = isPaid
        self.unapprovedReasonNumber = unapprovedReasonNumber
        self.createdAt = createdAt.dateValue()
        self.updatedAt = updatedAt.dateValue()
        status = .init(isReservation: isReservation, reason: unapprovedReasonNumber, isApproved: isApproved, isPaid: isPaid)
        self.totalPrice = totalPrice
        if let totalPrice = totalPrice {
            rewardPrice = totalPrice / 10
        }
        self.receiptImageTitle = receiptImageTitle
        self.couponNumber = couponNumber
        self.couponBalance = couponBalance
        self.couponPrice = couponPrice
        self.couponUrl = couponUrl
        self.couponName = couponName
    }

    // dammy data for tutorial
    init?(isDammyData: Bool = false) {
        guard isDammyData else { return nil }
        id = ""
        staffId = ""
        staffName = ""
        date = "2019/12/27"
        time = "19:00"
        people = 2
        guestName = "ランデブ"
        guestTel = "000-0000-0000"
        isReservation = true
        isApproved = false
        isPaid = false
        unapprovedReasonNumber = 1
        createdAt = Date()
        updatedAt = Date()
        status = .init(isReservation: isReservation, reason: unapprovedReasonNumber, isApproved: isApproved, isPaid: isPaid)
    }
}

extension Invitation {
    static func getInvitationData(handler: @escaping([Invitation]?, String?)->Void) {

          var invitations: [Invitation] = []
          
          Staff.getCurrentStaffData(handler: { staff, errorMessage in
            if let shopId = staff?.shopId {
                if let uid = AUTH.currentUser?.uid {
                    //↓ここから削除予定
                    INVITATION_REF.whereField("shop_uid", isEqualTo: "all-shop").getDocuments() { querySnapshot, error in
                        if let error = error {
                            let errorMessage = error.localizedDescription
                            handler(nil, errorMessage)
                        }
                        if let querySnapshot = querySnapshot {
                            for document in querySnapshot.documents {
                                let data = document.data()
                                let id = document.documentID
                                let shopName = data["shop_name"] as? String
                                let guestId = data["guest_uid"] as? String
                                let totalPrice = data["total_price"] as? Int
                                let receiptImageTitle = data["receipt_image_title"] as? String
                                let couponPrice = data["coupon_price"] as? Int
                                let couponNumber = data["coupon_number"] as? String
                                let couponBalance = data["coupon_balance"] as? Int
                                let couponUrl = data["coupon_url"] as? String
                                let couponName = data["coupon_name"] as? String
                        
                        
                                guard
                                    let staffName = data["staff_name"] as? String,
                                    let date = data["date"] as? String,
                                    let time = data["time"] as? String,
                                    let people = data["people"] as? Int,
                                    let guestName = data["guest_name"] as? String,
                                    let guestTel = data["guest_tel"] as? String,
                                    let isReservation = data["is_reservation"] as? Bool,
                                    let isApproved = data["is_approved"] as? Bool,
                                    let isPaid = data["is_paid"] as? Bool,
                                    let unapprovedReasonNumber = data["unapproved_reason"] as? Int,
                                    let createdAt = data["created_at"] as? Timestamp,
                                    let updatedAt = data["updated_at"] as? Timestamp else { return }

                          // create invitation instance
                                let invitation = Invitation(id: id,
                                                            staffId: uid,
                                                            staffName: staffName,
                                                            shopName: shopName,
                                                            date: date,
                                                            time: time,
                                                            people: people,
                                                            guestId: guestId,
                                                            guestName: guestName,
                                                            guestTel: guestTel,
                                                            isReservation: isReservation,
                                                            isApproved: isApproved,
                                                            isPaid: isPaid,
                                                            unapprovedReasonNumber: unapprovedReasonNumber,
                                                            createdAt: createdAt,
                                                            updatedAt: updatedAt,
                                                            totalPrice: totalPrice,
                                                            receiptImageTitle: receiptImageTitle,
                                                            couponPrice: couponPrice,
                                                            couponBalance: couponBalance,
                                                            couponNumber: couponNumber,
                                                            couponUrl: couponUrl,
                                                            couponName: couponName
                                )
                                invitations.append(invitation)
                            }
                        }
                        //↑ここまで削除予定
                        INVITATION_REF.whereField("shop_uid", isEqualTo: shopId).getDocuments() { querySnapshot, error in
                            if let error = error {
                                let errorMessage = error.localizedDescription
                                handler(nil, errorMessage)
                            }
                            if let querySnapshot = querySnapshot {
                                for document in querySnapshot.documents {
                                    let data = document.data()
                                    let id = document.documentID
                                    let shopName = data["shop_name"] as? String
                                    let guestId = data["guest_uid"] as? String
                                    let totalPrice = data["total_price"] as? Int
                                    let receiptImageTitle = data["receipt_image_title"] as? String
                                    let couponPrice = data["coupon_price"] as? Int
                                    let couponNumber = data["coupon_number"] as? String
                                    let couponBalance = data["coupon_balance"] as? Int
                                    let couponUrl = data["coupon_url"] as? String
                                    let couponName = data["coupon_name"] as? String
                                                        
                                                        
                                    guard
                                        let staffName = data["staff_name"] as? String,
                                        let date = data["date"] as? String,
                                        let time = data["time"] as? String,
                                        let people = data["people"] as? Int,
                                        let guestName = data["guest_name"] as? String,
                                        let guestTel = data["guest_tel"] as? String,
                                        let isReservation = data["is_reservation"] as? Bool,
                                        let isApproved = data["is_approved"] as? Bool,
                                        let isPaid = data["is_paid"] as? Bool,
                                        let unapprovedReasonNumber = data["unapproved_reason"] as? Int,
                                        let createdAt = data["created_at"] as? Timestamp,
                                        let updatedAt = data["updated_at"] as? Timestamp else { return }

                                                          // create invitation instance
                                    let invitation = Invitation(id: id,
                                                                staffId: uid,
                                                                staffName: staffName,
                                                                shopName: shopName,
                                                                date: date,
                                                                time: time,
                                                                people: people,
                                                                guestId: guestId,
                                                                guestName: guestName,
                                                                guestTel: guestTel,
                                                                isReservation: isReservation,
                                                                isApproved: isApproved,
                                                                isPaid: isPaid,
                                                                unapprovedReasonNumber: unapprovedReasonNumber,
                                                                createdAt: createdAt,
                                                                updatedAt: updatedAt,
                                                                totalPrice: totalPrice,
                                                                receiptImageTitle: receiptImageTitle,
                                                                couponPrice: couponPrice,
                                                                couponBalance: couponBalance,
                                                                couponNumber: couponNumber,
                                                                couponUrl: couponUrl,
                                                                couponName: couponName
                                    )

                                    INVITATION_REF.document(id).collection("log").order(by: "created_at", descending: true).getDocuments(completion: { (querySnapshot, error) in
                                        if let error = error {
                                            let errorMessage = error.localizedDescription
                                            handler(nil, errorMessage)
                                        }
                                        if let querySnapshot = querySnapshot {
                                            for document in querySnapshot.documents {
                                                let data = document.data()
                            //                                            let createdAt = data["created_at"] as? Timestamp
                            //                                            let date = data["date"] as? String
                            //                                            let payment = data["payment"] as? Int
                            //                                            let shopId = data["shop_uid"] as? String
                            //                                            let staffId = data["staff_uid"] as? String
                            //
                            //
                            //                                            let logList = ["createdAT": createdAt,
                            //                                                           "date": date,
                            //                                                           "payment": payment,
                            //                                                           "shopId": shopId,
                            //                                                           "staffId": staffId
                            //                                                ] as [String : Any?]
                                                invitation.couponLogs.append(data as [String : Any])
                                            }
                        //                                        invitation.couponLogs.sorted { g(lhs: $0, rhs: $1, f: >) }
                                        }
                                    })

                                    UNAPPROVED_REASON_MASTER.getDocument { documentSnapshot, error in
                                        if let data = documentSnapshot?.data() {
                                            guard let unapprovedReasonString = data["\(unapprovedReasonNumber)"] as? String else { return }
                                            invitation.unapprovedReasonString = unapprovedReasonString
                                        }
                                        else {
                                            guard let errorMessage = error?.localizedDescription else {return}
                                            handler(nil, errorMessage)
                                        }
                                    }
                                    invitations.append(invitation)
                                }
                            }
                            handler(invitations.sort(), nil)
                        }
                    }
                }
              } else {
                guard errorMessage != nil else {return}
              }
          })
    }
}

extension Array where Element: Invitation {
    func sort() -> [Invitation] {
        return sorted { $0.createdAt > $1.createdAt }
    }
}
