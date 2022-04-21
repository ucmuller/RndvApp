//
//  SettingsItemCell.swift
//  Gururi
//
//  Created by Yu Shimura on 2019/10/17.
//

import UIKit

class SettingsItemCell: UITableViewCell {
    
    
    enum ItemType: Int, CaseIterable {
        case editProfile
        case referral
        case privacyPolicy
        case contact
        case unsubscribe
        
        init(cellNumber: Int) {
            switch cellNumber {
            case 0:
                self = .editProfile
            case 1:
                self = .referral
            case 2:
                self = .privacyPolicy
            case 3:
                self = .contact
            case 4:
                self = .unsubscribe
            default:
                fatalError("セルがありません")
            }
        }
        
        var name: String {
            switch self {
            case .editProfile:
                return "editProfile"
            case .referral:
                return "referral"
            case .privacyPolicy:
                return "privacyPolicy"
            case .contact:
                return "contact"
            case .unsubscribe:
                return "unsubscribe"
            }
        }
        
        var title: String {
            switch self {
            case .editProfile:
                return "プロフィール編集"
            case .referral:
                return "RNDVを紹介"
            case .privacyPolicy:
                return "利用規約&プライバシーポリシー"
            case .contact:
                return "お問い合わせ"
            case .unsubscribe:
                return "退会"
            }
        }
        
        var segueId: String {
            switch self {
            case .editProfile:
                return "goToEditProfileVC"
            case .referral:
                return "goToReferralCreateVC"
            case .privacyPolicy:
                return "goToPrivacyPolicyVC"
            case .contact:
                return "goToContactFormVC"
            case .unsubscribe:
                return "goToContactFormVC"
            }
        }
        
        var icon: UIImage!{
            switch self {
            case .editProfile:
                return UIImage(named: "settingsItemImage_1")
            case .referral:
                return UIImage(named: "settingsItemImage_1")
            case .privacyPolicy:
                return UIImage(named: "settingsItemImage_3")
            case .contact:
                return UIImage(named: "settingsItemImage_2")
            case .unsubscribe:
                return UIImage(named: "settingsItemImage_3")
            }
        }
    }

    @IBOutlet weak var settingsItemImage: UIImageView!
    @IBOutlet weak var settingsItemLabel: UILabel!
    var status: ItemType?
    var currentCellValue: Int?
    var cellCount = ItemType.allCases.count
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(indexPath: Int) {
        status = .init(cellNumber: indexPath)
        currentCellValue = status?.rawValue
//        if let cell = currentCell {
//            settingsItemImage.image = cell.icon
//            settingsItemLabel.text = cell.title
//        }
    }
    
}
