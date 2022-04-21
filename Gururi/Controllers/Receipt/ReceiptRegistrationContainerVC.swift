//
//  ReceiptRegistrationContainerVC.swift
//  Gururi
//
//  Created by Naoki Muroya on 2020/03/22.
//

import UIKit
import Firebase
import FirebaseUI
import CryptoKit

class ReceiptRegistrationContainerVC: CustomViewController {
    fileprivate lazy var pageController: UIPageViewController = {
        let pageController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageController.dataSource = self
        pageController.delegate = self
        pageController.view.backgroundColor = .clear
        pageController.view.translatesAutoresizingMaskIntoConstraints = false
        return pageController
    }()

    fileprivate var currentIndex: Int = 0

    var pages: [ReceiptRegistrationPage] = ReceiptRegistrationPage.allCases
    
    var receiptRegistrationNameVC = ReceiptRegistrationNameVC()
    var receiptRegistrationDateVC = ReceiptRegistrationDateVC()
    var receiptRegistrationPeopleVC = ReceiptRegistrationPeopleVC()
    var receiptRegistrationMessageVC = ReceiptRegistrationMessageVC()
    var receiptRegistrationConfirmationVC = ReceiptRegistrationConfirmationVC()
    
    var guestName: String = ""
    var reservationDate: String = ""
    var reservationTime: String = ""
    var guestPeople: Int = 0
    var reservationMessage: String = ""
    var couponURL: String = ""
    var couponPrice: Int = 0
    
    var staff: Staff?
    
    @IBOutlet weak var ReceiptRegistrationContainerVCScrollView: UIScrollView!
    
    func viewControllerAtIndex(index: Int) -> ReceiptRegistrationPageVC? {
        switch index {
        case 0:
            return receiptRegistrationNameVC
        case 1:
            return receiptRegistrationDateVC
        case 2:
            return receiptRegistrationPeopleVC
        case 3:
            return receiptRegistrationMessageVC
        case 4:
            return nil
        default:
            return nil
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initStaff()
        configureVC()
        addChild(pageController)
        view.addSubview(pageController.view)
        pageController.view.anchorEdges(to: view)

        let initialVC = receiptRegistrationNameVC
        initialVC.receiptRegistrationNameVCDelegate = self
        pageController.setViewControllers([initialVC], direction: .forward, animated: true, completion: nil)
        pageController.didMove(toParent: self)

        let pageControl = UIPageControl.appearance(whenContainedInInstancesOf: [ReceiptRegistrationContainerVC.self])
        pageControl.pageIndicatorTintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        pageControl.currentPageIndicatorTintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }
    
    func initStaff() {
        Staff.getCurrentStaffData(handler: { staff, errorMessage in
            if let staff = staff {
                self.staff = staff
            } else {
                guard let errorMessage = errorMessage else {return}
                self.showAlert(message: errorMessage)
            }
        })
    }
    
    func configureVC() {
        receiptRegistrationNameVC.delegate = self
        receiptRegistrationNameVC.receiptRegistrationNameVCDelegate = self
        receiptRegistrationDateVC.delegate = self
        receiptRegistrationDateVC.receiptRegistrationDateVCDelegate = self
        receiptRegistrationPeopleVC.delegate = self
        receiptRegistrationPeopleVC.receiptRegistrationPeopleVCDelegate = self
        receiptRegistrationMessageVC.delegate = self
        receiptRegistrationMessageVC.receiptRegistrationMessageVCDelegate = self
        receiptRegistrationConfirmationVC.delegate = self
        receiptRegistrationConfirmationVC.receiptRegistrationConfirmationVCDelegate = self
    }
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension ReceiptRegistrationContainerVC: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return pages.count
    }

    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return currentIndex
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentVC = viewController as? ReceiptRegistrationPageVC else { return nil }
        guard let page = currentVC.page else { return nil }
        
        var index = page.index

        if index == 0 {
            return nil
        }

        index -= 1

        let vc = viewControllerAtIndex(index: index)
        return vc
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentVC = viewController as? ReceiptRegistrationPageVC else { return nil }
        guard let page = currentVC.page else { return nil }
        
        var index = page.index

        if index >= pages.count - 1 {
            return nil
        }
 
        index += 1

        let vc = viewControllerAtIndex(index: index)
        return vc
    }
}

extension ReceiptRegistrationContainerVC: ReceiptRegistrationPageDelegate, ReceiptRegistrationNameVCDelegate, ReceiptRegistrationDateVCDelegate, ReceiptRegistrationPeopleVCDelegate, ReceiptRegistrationMessageVCDelegate,
ReceiptRegistrationConfirmationVCDelegate{
    func receiptRegistrationConfirmationVC(didPressedSendButton formView: ReceiptRegistrationConfirmationVC) {
        setDataToFireStore(formView: formView)
    }
    
    
    func receiptRegistrationMessageVC(didTapKeyboardReturn formView: ReceiptRegistrationMessageVC) {
        reservationMessage = formView.message
        couponURL = formView.couponURL
        couponPrice = formView.couponPrice
        
        currentIndex += 1
        
        let nextVC = receiptRegistrationConfirmationVC
        nextVC.guestName = guestName
        nextVC.reservationDate = reservationDate
        nextVC.reservationTime = reservationTime
        nextVC.guestPeople = guestPeople
        nextVC.reservationMessage = reservationMessage
        nextVC.couponURL = couponURL
        nextVC.couponPrice = couponPrice
        
        pageController.setViewControllers([nextVC], direction: .forward, animated: true, completion: nil)
    }
    
    func receiptRegistrationPeopleVC(didTapKeyboardReturn formView: ReceiptRegistrationPeopleVC) {
        guestPeople = formView.currentPeople
        currentIndex += 1
        pageController.setViewControllers([receiptRegistrationMessageVC], direction: .forward, animated: true, completion: nil)
    }
    
    func receiptRegistrationDateVC(didTapKeyboardReturn formView: ReceiptRegistrationDateVC) {
        reservationDate = formView.date
        reservationTime = formView.time
        currentIndex += 1
        pageController.setViewControllers([receiptRegistrationPeopleVC], direction: .forward, animated: true, completion: nil)
    }
    
    
    func receiptRegistrationNameVC(didTapKeyboardReturn formView: ReceiptRegistrationNameVC) {
        guestName = formView.guestName
        currentIndex += 1
        pageController.setViewControllers([receiptRegistrationDateVC], direction: .forward, animated: true, completion: nil)
    }
    
    func receiptRegistrationPageWillAppear(_ receiptRegistrationPageVC: ReceiptRegistrationPageVC) {
        guard let page = receiptRegistrationPageVC.page else { return }
        let index = page.index
        currentIndex = index
    }
    
    func setDataToFireStore(formView: ReceiptRegistrationConfirmationVC) {
        guard let staff = self.staff else {return}
                
        let date = formView.reservationDate
        let time = formView.reservationTime
        let guestName = formView.guestName
        let lineMessage = formView.reservationMessage
        let people = formView.guestPeople
        let couponURL = formView.couponURL
        let couponPrice = formView.couponPrice
        let couponNumber = formView.couponURL != "" ? self.generateNumberFromDate() : ""

        let uid = staff.id
        let name = staff.displayName
        let shopAddress = staff.shopAddress
        let shopInfo = staff.shopInfo
        let shopName = staff.shopName
        let shopId = staff.shopId
        let tel = staff.shopTel
           
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yMdkHms"
        let timestamp = Date()
        let documentName = uid + dateFormatter.string(from: timestamp)
   
        let activityItem = ["\(lineMessage)\n【予約代行完了|ランデブ】https://guest.rndv-vip.com/\(documentName)"]
        let activityVC = UIActivityViewController(activityItems:  activityItem, applicationActivities: nil)
        self.present(activityVC, animated: true, completion: nil)
       
        activityVC.completionWithItemsHandler = { (activityType: UIActivity.ActivityType?, completed: Bool, arrayReturnedItems: [Any]?, error: Error?) in
            if completed {
                INVITATION_REF.document(documentName).setData([
                "created_at" : FieldValue.serverTimestamp(),
                "date" : date,
                "guest_name" : guestName,
                "guest_tel" : "",
                "guest_uid" : "",
                "is_approved" : false,
                "is_reservation" : false,
                "is_paid" : false,
                "line_message": lineMessage,
                "people" : people,
                "receipt_image_title": "",
                "staff_name": name,
                "staff_tel" : tel,
                "staff_uid" : uid,
                "shop_name" : shopName,
                "shop_address" : shopAddress ?? "",
                "shop_info" : shopInfo ?? "",
                "shop_uid" : shopId,
                "time" : time,
                "unapproved_reason" : 0,
                "coupon_url" : couponURL,
                "coupon_price" : couponPrice,
                "coupon_balance" : couponPrice,
                "coupon_number" : couponNumber,
                "updated_at" : FieldValue.serverTimestamp()
               ]) { error in
                   if let error = error {
                       self.showAlert(message: error.localizedDescription)
                       return
                   }
                   self.dismiss(animated: true, completion: {
                       NotificationCenter.default.post(name: .didFinishCreateInvitaion, object: nil)
                       return
                   })
               }
               
               STAFF_REF.document(uid).updateData([
                   "line_message" : lineMessage
                   ])
           } else {
               self.showAlert(message: "キャンセル")
           }
           if let shareError = error {
               self.showAlert(message: "\(shareError.localizedDescription)")
           }
        }
    }
    
    func generateNumberFromDate() -> String {
        let today = Date();
        let sec = today.timeIntervalSince1970
        let number = String(UInt64(sec * 100000)).suffix(6)
        return String(number)
    }
}

