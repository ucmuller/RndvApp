//
//  User.swift
//  Gururi
//
//  Created by Naoki Muroya on 2019/03/29.
//  Copyright © 2019 Gururi. All rights reserved.
//

import Foundation
import Firebase

public class Staff {
    public enum Role: Int, CaseIterable {
        case ownerAndManager
        case owner
        case manager
        case staff
        case partTime
        case other
        
        init(roleNumber: Int) {
            switch roleNumber {
            case 0 :
                self = .ownerAndManager
            case 1 :
                self = .owner
            case 2 :
                self = .manager
            case 3 :
                self = .staff
            case 4 :
                self = .partTime
            case 5 :
                self = .other
            default :
                fatalError("番号はありません")
            }
        }
        
        var roleName: String {
            switch self {
            case .ownerAndManager:
                return "オーナー兼店長"
            case .owner:
                return "オーナー(※店長は別にいる)"
            case .manager:
                return "店長(※オーナーは別にいる)"
            case .staff:
                return "正社員"
            case .partTime:
                return "アルバイト"
            case .other:
                return "その他"
            }
        }
    }
    
    public enum Item: Equatable {
        case displayName(String?)
        case tel(String?)
        case email(String?)
        case shopName(String?)
        case shopTel(String?)
        case role(Role?)
        
        var title: String {
            switch self {
            case .displayName:
                return "ユーザー名"
            case .tel:
                return "電話番号"
            case .email:
                return "メールアドレス"
            case .shopName:
                return "店舗名"
            case .shopTel:
                return "店舗電話番号"
            case .role:
                return "役職"
            }
        }
        
        var body: String {
            switch self {
            case let .displayName(displayName):
                guard let displayName = displayName else { return "" }
                return displayName
            case let .tel(tel):
                guard let tel = tel else { return "" }
                return tel
            case let .email(email):
                guard let email = email else { return "" }
                return email
            case let .shopName(shopName):
                guard let shopName = shopName else { return "" }
                return shopName
            case let .shopTel(shopTel):
                guard let shopTel = shopTel else { return "" }
                return shopTel
            case let .role(role):
                guard let role = role else { return "" }
                return role.roleName
            }
        }
        
        static var allCases: [Item] {
            return [.displayName(nil),
                    .tel(nil),
                    .email(nil),
                    .shopName(nil),
                    .shopTel(nil),
                    .role(nil)
            ]
        }
        
    }
    
    public enum EditableItem: Equatable {
        case displayName(String?)
        case tel(String?)
        case shopTel(String?)
        
        var title: String {
            switch self {
            case .displayName:
                return "ユーザー名"
            case .tel:
                return "電話番号"
            case .shopTel:
                return "店鋪電話番号"
            }
        }
        
        var body: String {
            switch self {
            case let .displayName(displayName):
                guard let displayName = displayName else {return ""}
                return displayName
            case let .tel(tel):
                guard let tel = tel else {return ""}
                return tel
            case let .shopTel(shopTel):
                guard let shopTel = shopTel else {return ""}
                return shopTel
            }
        }
        
        static var allCases: [EditableItem] {
            return [.displayName(nil),
                    .tel(nil),
                    .shopTel(nil)
            ]
        }
    }
    
    var id: String
    var displayName: String
    var tel: String
    var email: String
    var fullName: String
    var furiGana: String
    var shopName: String
    var shopTel: String
    var shopAddress: String?
    var shopInfo: String?
    var shopId: String
    var employmentStatusNumber: Int
    var employmentStatusString: String?
    var fcmToken: String?
    var lineMessage: String?
    var isActive: Bool
    var createdAt: Date
    var updatedAt: Date
    var role: Role
    
    init(id: String, displayName: String, tel: String, email: String, fullName: String, furiGana: String, shopName: String, shopTel: String, shopAddress: String?, shopInfo: String?, shopId: String, employmentStatusNumber: Int, fcmToken: String?, lineMessage: String?, isActive: Bool, createdAt: Timestamp, updatedAt: Timestamp) {

        self.id = id
        self.displayName = displayName
        self.tel = tel
        self.email = email
        self.fullName = fullName
        self.furiGana = furiGana
        self.shopName = shopName
        self.shopAddress = shopAddress
        self.shopInfo = shopInfo
        self.shopTel = shopTel
        self.shopId = shopId
        self.employmentStatusNumber = employmentStatusNumber
        self.fcmToken = fcmToken
        self.lineMessage = lineMessage
        self.isActive = isActive
        self.createdAt = createdAt.dateValue()
        self.updatedAt = updatedAt.dateValue()
        role = .init(roleNumber: employmentStatusNumber)
    }
    
    var items: [Item] {
        return [.displayName(displayName),
                .email(email),
                .tel(tel),
                .shopName(shopName),
                .shopTel(shopTel),
                .role(role)
        ]
    }
    
    var editableItems: [EditableItem] {
        return [.displayName(displayName),
                .tel(tel),
                .shopTel(shopTel)
        ]
    }
}

extension Staff {
    static func getCurrentStaffData(handler: @escaping(Staff?, String?)->Void) {
        if let uid = AUTH.currentUser?.uid {
            STAFF_REF.document(uid).getDocument { documentSnapshot, error in
                if let data = documentSnapshot?.data() {
                    guard
                        let displayName = data["display_name"] as? String,
                        let tel = data["tel"] as? String,
                        let email = data["email"] as? String,
                        let fullName = data["full_name"] as? String,
                        let furiGana = data["furi_gana"] as? String,
                        let shopName = data["shop_name"] as? String,
                        let shopAddress = data["shop_address"] != nil ? data["shop_address"] as? String : "",
                        let shopInfo = data["shop_info"] != nil ? data["shop_info"] as? String : "",
                        let shopTel = data["shop_tel"] as? String,
                        let shopId = data["shop_uid"] as? String,
                        let employmentStatusNumber = data["employment_status"] as? Int,
                        let fcmToken = data["fcm_token"] as? String,
                        let lineMessage = data["line_message"] as? String,
                        let isActive = data["is_active"] as? Bool,
                        let createdAt = data["created_at"] as? Timestamp,
                        let updatedAt = data["updated_at"] as? Timestamp else { return }
                    let staff = Staff(id: uid,
                                      displayName: displayName,
                                      tel: tel,
                                      email: email,
                                      fullName: fullName,
                                      furiGana: furiGana,
                                      shopName: shopName,
                                      shopTel: shopTel,
                                      shopAddress: shopAddress,
                                      shopInfo: shopInfo,
                                      shopId: shopId,
                                      employmentStatusNumber: employmentStatusNumber,
                                      fcmToken: fcmToken,
                                      lineMessage: lineMessage,
                                      isActive: isActive,
                                      createdAt: createdAt,
                                      updatedAt: updatedAt
                    )

                    EMPLOYMENT_STATUS_MASTER.getDocument { documentSnapshot, error in
                        if let data = documentSnapshot?.data() {
                            guard let employmentStatusString = data["\(employmentStatusNumber)"] as? String else { return }
                            staff.employmentStatusString = employmentStatusString
                        }
                        else {
                            guard let errorMessage = error?.localizedDescription else {return}
                            handler(nil, errorMessage)
                        }
                    }
                    handler(staff, nil)
                } else {
                    guard let errorMessage = error?.localizedDescription else {return}
                    handler(nil, errorMessage)
                }
            }
        }
    }
}
