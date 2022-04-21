//
//  ReusableTableViewCellManageble.swift
//  Gururi
//
//  Created by Naoki Muroya on 2019/10/22.
//

import UIKit

protocol ReusableTableViewCellManageable {
    var cellTypes: [UITableViewCell.Type] { get }
    var headerCellTypes: [UITableViewHeaderFooterView.Type] { get }
    var footerCellTypes: [UITableViewHeaderFooterView.Type] { get }

    func registerAllTableViewCells(to tableView: UITableView)
    func registerTableViewCells(to tableView: UITableView)
    func registerTableViewCell(to tableView: UITableView, cellType: UITableViewCell.Type)
    func registerTableViewHeaders(to tableView: UITableView)
    func registerTableViewHeader(to tableView: UITableView, headerType: UITableViewHeaderFooterView.Type)
    func registerTableViewFooters(to tableView: UITableView)
    func registerTableViewFooter(to tableView: UITableView, footerType: UITableViewHeaderFooterView.Type)
}

extension ReusableTableViewCellManageable {
    var cellTypes: [UITableViewCell.Type] { return [] }
    var headerCellTypes: [UITableViewHeaderFooterView.Type] { return [] }
    var footerCellTypes: [UITableViewHeaderFooterView.Type] { return [] }

    func registerAllTableViewCells(to tableView: UITableView) {
        registerTableViewCells(to: tableView)
        registerTableViewHeaders(to: tableView)
        registerTableViewFooters(to: tableView)
    }

    func registerTableViewCells(to tableView: UITableView) {
        cellTypes.forEach { cellType in
            registerTableViewCell(to: tableView, cellType: cellType)
        }
    }

    func registerTableViewCell(to tableView: UITableView, cellType: UITableViewCell.Type) {
        let name = String(describing: cellType)
        tableView.register(UINib(nibName: name, bundle: nil), forCellReuseIdentifier: name)
    }

    func registerTableViewHeaders(to tableView: UITableView) {
        headerCellTypes.forEach { cellType in
            registerTableViewHeader(to: tableView, headerType: cellType)
        }
    }

    func registerTableViewHeader(to tableView: UITableView, headerType: UITableViewHeaderFooterView.Type) {
        let name = String(describing: headerType)
        tableView.register(UINib(nibName: name, bundle: nil), forHeaderFooterViewReuseIdentifier: name)
    }

    func registerTableViewFooters(to tableView: UITableView) {
        footerCellTypes.forEach { cellType in
            registerTableViewFooter(to: tableView, footerType: cellType)
        }
    }

    func registerTableViewFooter(to tableView: UITableView, footerType: UITableViewHeaderFooterView.Type) {
        let name = String(describing: footerType)
        tableView.register(UINib(nibName: name, bundle: nil), forHeaderFooterViewReuseIdentifier: name)
    }

    func dequeueReusableCell<T: UITableViewCell>(from tableView: UITableView, cellType: T.Type, at indexPath: IndexPath) -> T {
        let name = String(describing: cellType)
        return tableView.dequeueReusableCell(withIdentifier: name) as! T
    }

    func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>(from tableView: UITableView, viewType: T.Type) -> T {
        let name = String(describing: viewType)
        return tableView.dequeueReusableHeaderFooterView(withIdentifier: name) as! T
    }
}

