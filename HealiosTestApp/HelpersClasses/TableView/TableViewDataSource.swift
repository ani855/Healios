//
//  PostsDataSource.swift
//  HealiosTestApp
//
//  Created by Ani Klekchyan on 3/23/21.
//

import UIKit

class TableViewDataSource<CELL : UITableViewCell,T> : NSObject, UITableViewDataSource {
    
    // MARK: - Properties
    private var cellIdentifier : String!
    private var items : [T]!
    
    // MARK: - Closures
    var configureCell : (CELL, T) -> () = {_,_ in }
    
    // MARK: - class lifecycle
    init(cellIdentifier : String, items : [T], configureCell : @escaping (CELL, T) -> ()) {
        self.cellIdentifier = cellIdentifier
        self.items =  items
        self.configureCell = configureCell
    }
    
    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
         let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CELL
        
        let item = self.items[indexPath.row]
        self.configureCell(cell, item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

