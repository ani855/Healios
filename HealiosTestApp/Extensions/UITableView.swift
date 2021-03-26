//
//  UITableView.swift
//  HealiosTestApp
//
//  Created by Ani Klekchyan on 3/26/21.
//

import UIKit

extension UITableView {

    func setTableHeaderView(headerView: UIView?) {
        headerView?.translatesAutoresizingMaskIntoConstraints = false
        tableHeaderView = headerView
        guard let headerView = headerView else { return }
        guard let tableHeaderViewSuperview = tableHeaderView?.superview else {
            assertionFailure("This should not be reached!")
            return
        }
        headerView.setNeedsLayout()
        headerView.layoutIfNeeded()
        tableHeaderViewSuperview.addConstraint(headerView.widthAnchor.constraint(equalTo: tableHeaderViewSuperview.widthAnchor, multiplier: 1.0))
        let height = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        tableHeaderViewSuperview.addConstraint(headerView.heightAnchor.constraint(equalToConstant: height))
    }

    func setTableFooterView(footerView: UIView?) {
        tableFooterView = footerView
        guard let footerView = footerView else { return }
        guard let tableFooterViewSuperview = tableFooterView?.superview else {
            assertionFailure("This should not be reached!")
            return
        }
        footerView.setNeedsLayout()
        footerView.layoutIfNeeded()
        tableFooterViewSuperview.addConstraint(footerView.widthAnchor.constraint(equalTo: tableFooterViewSuperview.widthAnchor, multiplier: 1.0))
        let height = footerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        tableFooterViewSuperview.addConstraint(footerView.heightAnchor.constraint(equalToConstant: height))
    }
}
