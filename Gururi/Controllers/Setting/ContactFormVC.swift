//
//  ContactFormVC.swift
//  Gururi
//
//  Created by Yu Shimura on 2019/12/25.
//

import UIKit
import MessageUI

class ContactFormVC: CustomViewController, MFMailComposeViewControllerDelegate {
    enum Page: Int {
        case contact
        case unsubscribe
        
        init(pageName: String) {
            switch pageName {
            case "contact":
                self = .contact
            case "unsubscribe":
                self = .unsubscribe
            default:
                fatalError("ページがありません")
            }
        }
        
        var sentence: String {
            switch self {
            case .contact:
                return "ご質問・ご要望・各種お問い合わせなど\nございましたらお知らせください。"
                
            case .unsubscribe:
                return "退会をご希望の方は\n退会理由をご記入の上送信してください。"
            }
        }
        
        var placeholder: String {
            switch self {
            case .contact:
                return "お問い合わせ内容"
            case .unsubscribe:
                return "退会理由"
            }
        }
    }
    
    
    var email: String?
    var page: Page?
    var cellIndex: Int?
    let fromSettingItemCell = SettingsItemCell()
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var contactForm: UITextField!
    @IBOutlet weak var sendMailButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configreView(indexPath: cellIndex)
        configureNotification()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToAfterContactVC" {
            let nextVC = segue.destination as! AfterContactVC
            nextVC.currentUserEmail = email
        }
    }
    
    func configreView(indexPath: Int?) {
        if let indexPath = indexPath {
            fromSettingItemCell.configureCell(indexPath: indexPath)
            if let pageName = fromSettingItemCell.status?.name {
                page = .init(pageName: pageName)
                descriptionLabel.text = page?.sentence
                contactForm.placeholder = page?.placeholder
            }
        }
        configureButton()
        configureTextField()
    }
    
    func configureButton() {
        sendMailButton.layer.cornerRadius = 10
    }
    
    func configureTextField() {
        contactForm.delegate = self
    }
    
    func eraseContactFormText() {
        contactForm.text = ""
    }
    
    
    @IBAction func sendMessageButtonPressed(_ sender: Any) {
        sendContactMail()
    }
    
    func sendContactMail() {

        if MFMailComposeViewController.canSendMail() {
            let fromEmail = "info@rndv.jp"
            let mail = MFMailComposeViewController()
            if let subject = page?.placeholder  {
                mail.mailComposeDelegate = self
                mail.setToRecipients([fromEmail])
                mail.setSubject("\(subject)")
                if let messageBody = contactForm.text {
                    mail.setMessageBody(messageBody, isHTML: false)
                }
            }

            self.present(mail, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "メールアカウントが有りません", message: "iPhone内のメールアカウントを設定してください。", preferredStyle: .alert)
            let dismiss = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(dismiss)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        if let error = error {
            print(error)
        } else {
            switch result {
            case .cancelled, .saved:
                self.dismiss(animated: true, completion: nil)
            case .sent:
                eraseContactFormText()
                performSegue(withIdentifier: "goToAfterContactVC", sender: nil)
            default:
                break
            }
            controller.dismiss(animated: true, completion: nil)
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.selectedTextField = textField
    }
}
