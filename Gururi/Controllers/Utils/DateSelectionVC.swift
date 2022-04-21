//
//  CalendarPopupVC.swift
//  Gururi
//
//  Created by Yu Shimura on 2020/01/08.
//

import UIKit
import FSCalendar
import CalculateCalendarLogic

protocol DateSelectionVCDelegate {
    func dateSelection(willDisappear dateSelectionVC: DateSelectionVC)
}

class DateSelectionVC: CustomViewController, FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var selectButton: UIButton!
    @IBOutlet weak var calendar: FSCalendar!

    var date: String?
    
    var delegate: DateSelectionVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureButton()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        delegate?.dateSelection(willDisappear: self)
    }
    
    func configureButton() {
        selectButton.layer.cornerRadius = 10.0
    }
    fileprivate let gregorian: Calendar = Calendar(identifier: .gregorian)
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()


    func judgeHoliday(_ date : Date) -> Bool {
        let tmpCalendar = Calendar(identifier: .gregorian)
        let year = tmpCalendar.component(.year, from: date)
        let month = tmpCalendar.component(.month, from: date)
        let day = tmpCalendar.component(.day, from: date)
        let calculateCalendarLogic = CalculateCalendarLogic()

        return calculateCalendarLogic.judgeJapaneseHoliday(year: year, month: month, day: day)
    }

    func getWeekdayIndex(_ date: Date) -> Int{
        let tmpCalendar = Calendar(identifier: .gregorian)
        return tmpCalendar.component(.weekday, from: date)
    }

    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        
        if self.judgeHoliday(date){
            return UIColor.red
        }

        let weekday = self.getWeekdayIndex(date)
        if weekday == 1 {
            return UIColor.red
        }
        else if weekday == 7 {
            return UIColor.blue
        }

        return nil
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let tmpDate = Calendar(identifier: .gregorian)
        let year = tmpDate.component(.year, from: date)
        let month = tmpDate.component(.month, from: date)
        let day = tmpDate.component(.day, from: date)
        self.date = "\(year)/\(month)/\(day)"
    }
    
    
    @IBAction func selectButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
