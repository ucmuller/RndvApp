//
//  FirstLaunchDescriptionView.swift
//  Gururi
//
//  Created by Yu Shimura on 2019/12/13.
//

import UIKit

protocol FirstLaunchDescriptionViewDelegate {
    func firstLaunchDescriptionView(didTapNextButton view: FirstLaunchDescriptionView, nextPage: Int, animated: Bool)
    func firstLaunchDescriptionView(didTapStartButton view: FirstLaunchDescriptionView)
}

class FirstLaunchDescriptionView: AutoLoadableView {
    
    public enum Page: Int, CaseIterable {
           
        case onborading_1
        case onborading_2
        case onborading_3
        case onborading_4
           
        init(page: Int) {
            switch page {
            case 1 :
               self = .onborading_1
            case 2 :
               self = .onborading_2
            case 3 :
               self = .onborading_3
            case 4 :
               self = .onborading_4
            default :
               fatalError("ページがありません")
            }
        }
           
        var image: UIImage {
            switch self {
            case .onborading_1 :
               return UIImage(named: "onboarding_ill_1")!
            case .onborading_2 :
               return UIImage(named: "onboarding_ill_2")!
            case .onborading_3 :
               return UIImage(named: "onboarding_ill_3")!
            case .onborading_4 :
               return UIImage(named: "setupGPS_ill_4")!
            }
        }
            
        
        var title: String {
            switch self {
            case .onborading_1 :
                return "お友達を招待して\nキャッシュをゲット！"
            case .onborading_2 :
                return "LINEで送信\nかんたん代理予約"
            case .onborading_3 :
                return "予約を確定させて\nキャッシュをゲット"
            case .onborading_4 :
                return "位置情報を許可して\nもっと便利に"
            }
        }
        
        var subtitle: String {
            switch self {
            case .onborading_1 :
                return "お友達を自分の働いているお店に\n招待してキャッシュをゲット。\nお友達もお店も自分もハッピー！"
            case .onborading_2 :
                return "招待メッセージを作って\nお友達に送信\nその場ですぐに代理予約が完了！"
            case .onborading_3 :
                return "予約を確定させれば\nランデブーから\nキャッシュが入ります"
            case .onborading_4 :
                return ""
            }
        }
        
        var buttonTitle: String {
            switch self {
            case .onborading_1 :
                return "次へ"
            case .onborading_2 :
                return "次へ"
            case .onborading_3 :
                return "次へ"
            case .onborading_4 :
                return "はじめる"
            }
        }
           
       }

    @IBOutlet weak var descriptionImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var pagingButton: UIButton!
    var delegate: FirstLaunchDescriptionViewDelegate?
    var currentPage: Page? = nil
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureButton()
    }
    
    func configureView(pageNumber: Int) {
        currentPage = .init(page: pageNumber)
        if let currentPage = currentPage {
            descriptionImageView.image = currentPage.image
            titleLabel.text = currentPage.title
            subTitleLabel.text = currentPage.subtitle
            pagingButton.setTitle(currentPage.buttonTitle, for: .normal)
        }
       
    }
    
    func configureButton() {
        pagingButton.layer.cornerRadius = 20.0
    }
    
    @IBAction func pressedPagingButton(_ sender: Any) {
        if let currentPage = currentPage {
            if ( currentPage != .onborading_4 ) {
                let nextPage = currentPage.rawValue + 1
                delegate?.firstLaunchDescriptionView(didTapNextButton: self, nextPage: nextPage, animated: true)
            } else {
                delegate?.firstLaunchDescriptionView(didTapStartButton: self)
            }
            
        }
    }
    
}
