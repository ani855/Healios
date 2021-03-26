//
//  TableViewDelegate.swift
//  HealiosTestApp
//
//  Created by Ani Klekchyan on 3/25/21.
//

import UIKit

class TableViewDelegate: NSObject, UITableViewDelegate {
    
    // MARK: - Properties
    
    // MARK: - Closures
    var cellSelectedInIndexPath : (Int) -> () = {_ in }

    // MARK: - Table view delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.cellSelectedInIndexPath(indexPath.row)
    }
}
