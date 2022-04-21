//
//  CustomTabBarController.swift
//  Gururi
//
//  Created by Naoki Muroya on 2019/12/24.
//

import UIKit

extension Notification.Name {
    static let tabBarShouldHide = Notification.Name("tabBarShouldHide")
    static let tabBarShouldAppear = Notification.Name("tabBarShouldAppear")
    static let floatingInvitationButtonHide = Notification.Name("floatingInvitationButtonHide")
    static let floatingInvitationButtonAppear = Notification.Name("floatingInvitationButtonAppear")
    static let floatingInvitationButtonTapped = Notification.Name("floatingInvitationButtonTapped")
}

class CustomTabBarController: UITabBarController, UITabBarControllerDelegate {
    let floatingInvitationButtonMargin: CGFloat = 20
    var floatingInvitationButton: FloatingInvitationButton?
    var floatingInvitationButtonBottomMarginConstraint: NSLayoutConstraint!

    var isHiddenTabBar: Bool = false {
        didSet {
            isHiddenTabBar ? hideTabbar() : showTabbar()
        }
    }

    var isHiddenFloatingInvitationButton = false {
        didSet {
            updateFloatingMenuButton()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        subscribeTabCustomEvents()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupInvitationButton()
    }

    fileprivate func setupInvitationButton() {
        let floatingInvitationButton = FloatingInvitationButton(frame: view.bounds)
        floatingInvitationButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTapInvitationButton)))
        view.addSubview(floatingInvitationButton)
        floatingInvitationButtonBottomMarginConstraint = floatingInvitationButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: tabBar.frame.height + floatingInvitationButtonMargin + view.safeAreaInsets.bottom)
        floatingInvitationButtonBottomMarginConstraint.isActive = true
        floatingInvitationButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -floatingInvitationButtonMargin).isActive = true

        self.floatingInvitationButton = floatingInvitationButton

        updateFloatingMenuButton()
    }

    func updateFloatingMenuButton() {
        changeFloatingMenuButtonDisplayState(hidden: isHiddenFloatingInvitationButton)

        let tabBarHeight = isHiddenTabBar ? 0 : tabBar.bounds.height
        let bottomMargin = -(tabBarHeight + floatingInvitationButtonMargin)
        floatingInvitationButtonBottomMarginConstraint.constant = bottomMargin
    }

    func changeFloatingMenuButtonDisplayState(hidden: Bool) {
        let animationFadeIn = { [weak self] () -> Void in
            self?.floatingInvitationButton?.alpha = 1.0
        }
        let animationFadeOut = { [weak self] () -> Void in
            self?.floatingInvitationButton?.alpha = 0.0
        }
        UIView.animate(
            withDuration: 0.2,
            delay: 0.0,
            options: .curveEaseOut,
            animations: hidden ? animationFadeOut : animationFadeIn,
            completion: nil
        )
    }

    func subscribeTabCustomEvents() {
        let center = NotificationCenter.default
        center.addObserver(
            self,
            selector: #selector(type(of: self).tabBarShouldHide(notification:)),
            name: .tabBarShouldHide,
            object: nil
        )
        center.addObserver(
            self,
            selector: #selector(type(of: self).tabBarShouldAppear(notification:)),
            name: .tabBarShouldAppear,
            object: nil
        )
        center.addObserver(
            self,
            selector: #selector(type(of: self).floatingInvitationButtonShouldHide(notification:)),
            name: .floatingInvitationButtonHide,
            object: nil
        )
        center.addObserver(
            self,
            selector: #selector(type(of: self).floatingInvitationButtonShouldAppear(notification:)),
            name: .floatingInvitationButtonAppear,
            object: nil
        )
    }

    @objc
    func onTapInvitationButton() {
        NotificationCenter.default.post(name: .floatingInvitationButtonTapped, object: nil)
    }

    @objc
    func tabBarShouldHide(notification: Notification) {
        isHiddenTabBar = true
    }

    @objc
    func tabBarShouldAppear(notification: Notification) {
        isHiddenTabBar = false
    }

    @objc
    func floatingInvitationButtonShouldHide(notification: Notification) {
        isHiddenFloatingInvitationButton = true
    }

    @objc
    func floatingInvitationButtonShouldAppear(notification: Notification) {
        isHiddenFloatingInvitationButton = false
    }

    fileprivate func hideTabbar() {
        changeTabbarDisplayState(hidden: true)
    }

    fileprivate func showTabbar() {
        changeTabbarDisplayState(hidden: false)
    }

    fileprivate func changeTabbarDisplayState(hidden: Bool) {
        if hidden && tabBar.isHidden { return }

        let parentBounds = tabBar.superview!.bounds
        let barHeight = tabBar.bounds.height

        let animationPullUp = { [weak self] () -> Void in
            // pull tabBar's position up
            if let frame = self?.tabBar.frame {
                let newBarFrame = CGRect(
                    x: frame.origin.x,
                    y: parentBounds.height - barHeight,
                    width: frame.width,
                    height: frame.height
                )
                self?.tabBar.frame = newBarFrame
            }
        }

        let animationPullDown = { [weak self] () -> Void in
            // pull tabBar's position down
            if let frame = self?.tabBar.frame {
                let newBarFrame = CGRect(
                    x: frame.origin.x,
                    y: parentBounds.height,
                    width: frame.width,
                    height: frame.height
                )
                self?.tabBar.frame = newBarFrame
            }
        }

        tabBar.alpha = 1
        tabBar.isHidden = false

        UIView.animate(
            withDuration: 0.2,
            delay: 0.0,
            options: UIView.AnimationOptions.curveEaseOut,
            animations: hidden ? animationPullDown : animationPullUp,
            completion: { [weak self] _ in
                self?.tabBar.alpha = hidden ? 0 : 1
                self?.tabBar.isHidden = hidden
            }
        )
    }
}
