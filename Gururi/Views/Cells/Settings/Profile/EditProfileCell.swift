//
//  EditProfileCell.swift
//  Gururi
//
//  Created by Yu Shimura on 2020/04/10.
//

import UIKit

protocol EditProfileCellDelegate {
    func textFieldEditingChanged(cell:EditProfileCell,value:String)
}

class EditProfileCell: UITableViewCell, UITextFieldDelegate{
    
    enum itemType: Int, CaseIterable {
        case name
        case email
        case tel
        
        init(cellNumber: Int) {
            switch cellNumber {
            case 0:
                self = .name
            case 1:
                self = .email
            case 2:
                self = .tel
            default:
                fatalError("セルがありません")
            }
        }
        
        var name: String {
            switch self {
            case .name:
                return "name"
            case .email:
                return "email"
            case .tel:
                return "tel"
            }
        }
    }
    
    
    @IBOutlet weak var editProfileTitleLabel: UILabel!
    @IBOutlet weak var editProfileTextfield: UITextField!
    
    let underline: UIView = UIView()
    
    var delegate: EditProfileCellDelegate? = nil
    
    var kind: String? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.editProfileTextfield.delegate = self
        editProfileTextfield.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        composeUnderline()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func composeUnderline() {
        let border = CALayer()
        let width = CGFloat(2.0)

        border.borderColor = RndvColor(name: "yellow")?.uiColor.cgColor
        border.frame = CGRect(x: 0, y: editProfileTextfield.frame.size.height, width:  editProfileTextfield.frame.size.width, height: 1)
        border.borderWidth = width

        editProfileTextfield.layer.addSublayer(border)
        
        editProfileTextfield.borderStyle = .none
    }
    
    @objc func editingChanged(textField: UITextField) {
        print(textField)
        self.delegate?.textFieldEditingChanged(cell: self, value: textField.text!)
    }
}
