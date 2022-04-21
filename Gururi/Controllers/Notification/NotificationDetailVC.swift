//
//  NotificationDetailVC.swift
//  Gururi
//
//  Created by Yu Shimura on 2020/01/22.
//

import UIKit

class MyTapGestureRecognizer: UITapGestureRecognizer {
    var targetURL: String?
}

class NotificationDetailVC: CustomViewController {
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet var snsIcons: [UIImageView]!
    var snsTitles: [String] =  ["twitter", "facebook", "instagram"]
    
    var notificationData: (Notifications ,Staff)? {
        didSet{
            if let notificationData = notificationData {
                titleLabel.text = notificationData.0.title
                
                var message = notificationData.0.message.replacingOccurrences(of: "\\n", with: "\n")
                message = message.replacingOccurrences(of: "user", with: "\(notificationData.1.displayName)")
                
                messageLabel.isUserInteractionEnabled = true
                let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapGesture))
                messageLabel.addGestureRecognizer(tapGestureRecognizer)
                
                let attributedString = NSMutableAttributedString(string: message)
                
                attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.blue, range: NSString(string: message).range(of: "【紹介はコチラ】"))
                
                messageLabel.attributedText = attributedString
                configureIcon(snsURL: notificationData.0.snsURLs)
            }
        }
    }
    
    var message: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func configureIcon(snsURL: [String]) {
        snsTitles.forEach {
            for (index, value) in snsURL.enumerated(){
                if value.contains($0) {
                    snsIcons[index].image = UIImage(named: "\($0)_icon")
                    let gesture = MyTapGestureRecognizer(target: self, action: #selector(self.snsIconTapped(sender:)))
                    gesture.targetURL = value
                    snsIcons[index].addGestureRecognizer(gesture)
                }
            }
        }
    }
}

extension NotificationDetailVC{
    @objc func snsIconTapped(sender: MyTapGestureRecognizer) {
        if let URL = sender.targetURL {
            openURL(URL)
        }
    }
    
    func openURL(_ link:String) {
        if link.prefix(7) == "http://" || link.prefix(8) == "https://" {
            guard let url = URL(string: link) else {return}
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        }
    }
    
    @objc func tapGesture(gestureRecognizer: UITapGestureRecognizer) {
        guard let text = messageLabel.text else { return }
        let touchPoint = gestureRecognizer.location(in: messageLabel)
        let textStorage = NSTextStorage(attributedString: NSAttributedString(string:  "【紹介はコチラ】"))
        let layoutManager = NSLayoutManager()
        textStorage.addLayoutManager(layoutManager)
        let textContainer = NSTextContainer(size: messageLabel.frame.size)
        layoutManager.addTextContainer(textContainer)
        textContainer.lineFragmentPadding = 0
        let toRange = (text as NSString).range(of:  "【紹介はコチラ】")
        let glyphRange = layoutManager.glyphRange(forCharacterRange: toRange, actualCharacterRange: nil)
        let glyphRect = layoutManager.boundingRect(forGlyphRange: glyphRange, in: textContainer)
        if glyphRect.contains(touchPoint) {
            print("Tapped")
        }
    }
}
//
//extension NotificationDetailVC: UITextViewDelegate {
//    public func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
//
//        let urlString = URL.absoluteString
//        if urlString == "TermOfUseLink" {
//            let storyboard: UIStoryboard = UIStoryboard(name: "Settings", bundle: nil)
//            let vc = storyboard.instantiateViewController(withIdentifier: "referralCreateVC") as! ReferralCreateVC
//            self.show(vc, sender: self)
//        }
//        return false
//    }
//}
