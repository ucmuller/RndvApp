//
//  Receipt.swift
//  Gururi
//
//  Created by Yu Shimura on 2020/03/25.
//

import Foundation
import Firebase

class Receipt {
    
    var id: String
    var createdAt: Date
    var date: String
    var guestName: String
    var guestId: String
    var people: Int
    var receiptImageTitle: String
    var shopId: String
    var staffName: String
    var staffId: String
    var time: String
    var totalPrice: Int
    var updatedAt: Date
    
    init(id: String, createdAt: Timestamp, date: String, guestName: String, guestId: String, people: Int, receiptImageTitle: String, shopId: String, staffName: String, staffId: String, time:String, totalPrice: Int, updatedAt: Timestamp) {
        
        self.id = id
        self.createdAt = createdAt.dateValue()
        self.date = date
        self.guestName = guestName
        self.guestId = guestId
        self.people = people
        self.receiptImageTitle = receiptImageTitle
        self.shopId = shopId
        self.staffName = staffName
        self.staffId = staffId
        self.time = time
        self.totalPrice = totalPrice
        self.updatedAt = updatedAt.dateValue()
    }
}

extension Receipt {
    static func getReceiptData(handler: @escaping([Receipt]?, String?)->Void){
        var receipts: [Receipt] = []
        Staff.getCurrentStaffData { (staff, error) in
                if let staff = staff {
                    SHOPS_REF.document(staff.shopId).collection("receipts").getDocuments { ( querySnapshot, error) in
                        if let error = error {
                            let errorMessage = error.localizedDescription
                            handler(nil, errorMessage)
                        }
                        if let querySnapshot = querySnapshot {
                            for document in querySnapshot.documents {
                                let data = document.data()
                                guard
                                    let id = data["uid"] as? String,
                                    let createdAt = data["created_at"] as? Timestamp,
                                    let date = data["date"] as? String,
                                    let guestName = data["guest_name"] as? String,
                                    let guestId = data["guest_uid"] as? String,
                                    let people = data["people"] as? Int,
                                    let receiptImageTitle = data["receipt_image_title"] as? String,
                                    let shopId = data["shop_uid"] as? String,
                                    let staffName = data["staff_name"] as? String,
                                    let staffId = data["staff_uid"] as? String,
                                    let time = data["time"] as? String,
                                    let totalPrice = data["total_price"] as? Int,
                                    let updatedAt = data["updated_at"] as? Timestamp else {return}
                                
                                let receipt = Receipt(id: id,
                                                      createdAt: createdAt,
                                                      date: date,
                                                      guestName: guestName,
                                                      guestId: guestId,
                                                      people: people,
                                                      receiptImageTitle: receiptImageTitle,
                                                      shopId: shopId,
                                                      staffName: staffName,
                                                      staffId: staffId,
                                                      time: time,
                                                      totalPrice: totalPrice,
                                                      updatedAt: updatedAt)
                                receipts.append(receipt)
                            }
                            handler(receipts.sort(), nil)
                        }
                    }
                } else {
                    guard let error = error else {return}
                    print(error)
                }
        }
    }
}

extension Array where Element: Receipt {
    func sort() -> [Receipt] {
        return sorted{ $0.createdAt > $1.createdAt}
    }
}
