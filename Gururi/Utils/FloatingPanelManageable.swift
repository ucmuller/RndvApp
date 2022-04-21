//
//  FloatingPanelManageable.swift
//  Gururi
//
//  Created by Naoki Muroya on 2020/03/15.
//

import FloatingPanel
import UIKit

protocol FloatingPanelManageable: class {
    var fpc: FloatingPanelController? { set get }
    func prepareFloatingPanel(vc: UIViewController, scrollView: UIScrollView?, delegate: FloatingPanelControllerDelegate?, cornerRadius: CGFloat, isRemovalInteractionEnabled: Bool)
}

extension FloatingPanelManageable where Self: UIViewController {
    func prepareFloatingPanel(vc: UIViewController, scrollView: UIScrollView? = nil, delegate: FloatingPanelControllerDelegate? = nil, cornerRadius: CGFloat = 6.0, isRemovalInteractionEnabled: Bool = true) {
        let fpc = FloatingPanelController()

        fpc.delegate = delegate
        fpc.surfaceView.cornerRadius = cornerRadius
        fpc.isRemovalInteractionEnabled = isRemovalInteractionEnabled
        fpc.set(contentViewController: vc)
        fpc.track(scrollView: scrollView)

        present(fpc, animated: true)

        self.fpc = fpc
    }

    func removeFloatingPanel(fpc: FloatingPanelController, animated: Bool = false) {
        fpc.dismiss(animated: animated, completion: nil)
        self.fpc = nil
    }

    func resetScrollview(scrollView: UIScrollView, reloadsLayout: Bool = true) {
        fpc?.track(scrollView: scrollView)
        if reloadsLayout {
            fpc?.updateLayout()
        }
    }
}

class ModalPanelLayout: FloatingPanelLayout {
    func insetFor(position: FloatingPanelPosition) -> CGFloat? {
        return nil
    }

    var supportedPositions: Set<FloatingPanelPosition> {
        return [.full]
    }

    var initialPosition: FloatingPanelPosition {
        return .full
    }
}

