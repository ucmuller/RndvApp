//
//  FirstLaunchVC.swift
//  Gururi
//
//  Created by Yu Shimura on 2019/12/13.
//
import UIKit

class FirstLaunchVC: CustomViewController, FirstLaunchDescriptionViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var descriptionView_1: FirstLaunchDescriptionView!
    @IBOutlet weak var descriptionView_2: FirstLaunchDescriptionView!
    @IBOutlet weak var descriptionView_3: FirstLaunchDescriptionView!
    @IBOutlet weak var descriptionView_4: FirstLaunchDescriptionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.isScrollEnabled = false
        descriptionView_1.delegate = self
        descriptionView_2.delegate = self
        descriptionView_3.delegate = self
        descriptionView_4.delegate = self
        configureDescriptionView()
    }
    
    func configureDescriptionView() {
        descriptionView_1.configureView(pageNumber: 1)
        descriptionView_2.configureView(pageNumber: 2)
        descriptionView_3.configureView(pageNumber: 3)
        descriptionView_4.configureView(pageNumber: 4)
    }
    
    func firstLaunchDescriptionView(didTapNextButton view: FirstLaunchDescriptionView, nextPage: Int, animated: Bool) {
        var frame: CGRect = scrollView.bounds
        frame.origin.x = frame.size.width * CGFloat(nextPage)
        frame.origin.y = 0
        scrollView.scrollRectToVisible(frame, animated: animated)
    }
    
    func firstLaunchDescriptionView(didTapStartButton view: FirstLaunchDescriptionView) {
        AppDelegate().showOnBoardingStoryboard()
    }
}
