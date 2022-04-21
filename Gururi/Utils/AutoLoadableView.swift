//
//  CustomUIView.swift
//  Gururi
//
//  Created by Naoki Muroya on 2019/09/23.
//

import UIKit

class AutoLoadableView: UIView {

    // loaded view from nib file
    var contentView: UIView!

    // use Auto layout?
    var useAutoLayout: Bool = true

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNib()
        appendContentView()
        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        loadNib()
        appendContentView()
        setupViews()
    }


    fileprivate func loadNib() {
        let className = String(describing: type(of: self))
        guard let view = UINib(nibName: className, bundle: nil).instantiate(withOwner: self, options: nil).first as? UIView else { return }
         contentView = view
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        setupViews()
    }

    fileprivate func appendContentView() {
        addSubview(contentView)

        // use auto layout
        if useAutoLayout {
            translatesAutoresizingMaskIntoConstraints = false
            contentView.translatesAutoresizingMaskIntoConstraints = false

            addConstraintToFillParentView(contentView)
        }
    }

    // MARK: override this function for containing view setups
    func setupViews() {
    }

    // MARK: utility functions
    func addConstraintToFillParentView(_ view: UIView) {
        let views: [String: UIView] = ["item": view]

        if let _ = view.superview {
            NSLayoutConstraint.activate(
                NSLayoutConstraint.constraints(withVisualFormat: "|[item]|", options: [], metrics: nil, views: views)
                    + NSLayoutConstraint.constraints(withVisualFormat: "V:|[item]|", options: [], metrics: nil, views: views)
            )
        }
    }
}
