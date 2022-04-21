//
//  InvitationListTutorialVC.swift
//  Gururi
//
//  Created by Naoki Muroya on 2019/12/27.
//

import UIKit

class InvitationListTutorialVC: InvitationListVC {
    enum State {
        case first
        case third
        case fifth
    }

    var state: State = .first {
        didSet {
            state != .first ? NotificationCenter.default.post(name: .floatingInvitationButtonHide, object: nil) : NotificationCenter.default.post(name: .floatingInvitationButtonAppear, object: nil)
        }
    }

    var instructionImageView1: UIImageView?
    var instructionImageView4: UIImageView?

    override func viewDidAppear(_ animated: Bool) {
        switch state {
        case .first:
            DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
                self.setupInstructionImageView1()
            }
        case .third:
            setupInstructionImageView4()
        case .fifth:
            setupPopup()
        }
        // need to wait until tabBarVC.viewDidAppear get called
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 80, right: 0)
        tabBarController?.tabBar.isHidden = true
    }

    func setupInstructionImageView1() {
        guard let tabBarVC = tabBarController as? CustomTabBarController else { return }
        guard let button = tabBarVC.floatingInvitationButton else { return }
        let buttonPosition: CGRect = button.frame
        let imageView = UIImageView()
        let imageWidth = view.frame.width / 2.1
        let imageHeight = imageWidth / 234 * 82
        imageView.image = UIImage(named: "tutorial_fukidashi_1")
        imageView.frame = CGRect(x: buttonPosition.minX - imageWidth, y: buttonPosition.minY + ((buttonPosition.height - imageHeight) / 2), width: imageWidth, height: imageHeight)
        instructionImageView1 = imageView
        self.view.addSubview(instructionImageView1!)
    }

    func setupInstructionImageView4() {
        let imageView = UIImageView()
        let imageWidth = view.frame.width / 1.5
        let imageHeight = imageWidth / 283 * 88
        imageView.image = UIImage(named: "tutorial_fukidashi_4")
        imageView.frame = CGRect(x: (view.frame.width - imageWidth) / 2, y: imageHeight / 2 + tableView.headerView(forSection: 1)!.frame.maxY, width: imageWidth, height: imageHeight)
        instructionImageView4 = imageView
        self.view.addSubview(instructionImageView4!)
    }

    func setupPopup() {
        let popupView = TutorialDonePopupView()
        popupView.delegate = self
        view.addSubview(popupView)
        popupView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        popupView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        popupView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        popupView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.7).isActive = true
    }

    // no need to fetch real data
    override func fetchInvitations() {}

    override func loadView() {
          if let view = UINib(nibName: "InvitationListVC", bundle: Bundle.main).instantiate(withOwner: self, options: nil).first as? UIView{
              self.view = view
          }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? InvitationDetailTutorialVC {
            vc.ensureViewIsLoaded()
            vc.invitation = sender as? Invitation
        }
    }

    @objc
    override func floatingInvitationButtonTapped(notification: Notification) {
        performSegue(withIdentifier: "showInvitationCreateTutorialVC", sender: nil)
    }

//    override func scrollViewDidScroll(_ scrollView: UIScrollView) {}
//
//    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {}
//
//    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {}

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height: CGFloat
        switch state {
        case .first:
            height = 200
        case .third:
            height = 115
        default:
            height = 0
        }
        return indexPath.section == 0 ? headerViewMaxHeight : height
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = dequeueReusableCell(from: tableView, cellType: SummaryHeaderCell.self, at: indexPath)
            headerView = cell.contentView
            cell.apply(invitations: invitations)
            return cell
        } else {
            switch state {
            case .first:
                let cell = dequeueReusableCell(from: tableView, cellType: InvitationTutorialCell.self, at: indexPath)
                return cell
            case .third:
                let cell = dequeueReusableCell(from: tableView, cellType: ReceiptItemCell.self, at: indexPath)
//                cell.apply(invitation: Invitation(isDammyData: true)!)
                return cell
            default:
                return UITableViewCell()
            }

        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            performSegue(withIdentifier: "showInvitationDetailTutorialVC", sender: Invitation(isDammyData: true)!)
        }
    }
}

extension InvitationListTutorialVC: TutorialDonePopupViewDelegate {
    func tutorialDonePopupView(didButtonTapped view: TutorialDonePopupView) {
        view.removeFromSuperview()
        AppDelegate().showNavigationStoryboard()
    }
}
