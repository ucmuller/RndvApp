//
//  Shop.swift
//  Gururi
//
//  Created by Yu Shimura on 2020/07/16.
//

import Firebase

public class Shop {
    
    var id: String
    var address: String
    var imageName: String
    var isActive: Bool
    var mapUrl: String
    var name: String
    var tel: String
    var website: String
    var createdAt: Date
    var updatedAt: Date
    
    init(id: String, address: String, tel: String, imageName: String, isActive: Bool, mapUrl: String, name: String, website: String, createdAt: Timestamp, updatedAt: Timestamp) {

        self.id = id
        self.address = address
        self.imageName = imageName
        self.tel = tel
        self.isActive = isActive
        self.mapUrl = mapUrl
        self.name = name
        self.website = website
        self.createdAt = createdAt.dateValue()
        self.updatedAt = updatedAt.dateValue()
    }
}

extension Shop {
    static func getCurrentShopData(shopId: String, handler: @escaping(Shop?, String?)->Void) {
        SHOPS_REF.document(shopId).getDocument { (documentSnapshot, error) in
            if let data = documentSnapshot?.data() {
                guard
                    let id = data["name"] as? String,
                    let address = data["address"] as? String,
                    let imageName = data["image_name"] as? String,
                    let tel = data["tel"] as? String,
                    let isActive = data["is_active"] as? Bool,
                    let mapUrl = data["map_url"] as? String,
                    let name = data["name"] as? String,
                    let website = data["website"] as? String,
                    let createdAt = data["created_at"] as? Timestamp,
                    let updatedAt = data["updated_at"] as? Timestamp else { return }
                
                let shop = Shop(id: id,
                                address: address,
                                tel: tel,
                                imageName: imageName,
                                isActive: isActive,
                                mapUrl: mapUrl,
                                name: name,
                                website: website,
                                createdAt: createdAt,
                                updatedAt: updatedAt
                )
                handler(shop, nil)
            } else {
                guard let errorMessage = error?.localizedDescription else {return}
                handler(nil, errorMessage)
            }
        }
    }
}
