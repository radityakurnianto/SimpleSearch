//
//  FilterController.swift
//  SimpleSearch
//
//  Created by Raditya Kurnianto on 3/15/18.
//  Copyright © 2018 Raditya. All rights reserved.
//

import UIKit
protocol FilterDelegate {
    func didReceiveFilter(filter: FilteredValue)
}

class FilterController: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navigationBarHeight: NSLayoutConstraint!
    
    var delegate: FilterDelegate?
    var resetValue = false
    var filter:FilteredValue?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTableView()
    }
    
    func setupTableView() -> Void {
        tableView.dataSource = self
        tableView.estimatedRowHeight = 120
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.register(UINib(nibName: String(describing: FilterCell.self), bundle: nil), forCellReuseIdentifier: String(describing: FilterCell.self))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        navigationBarHeight.constant = 64
    }
    
    // MARK: Button function
    @IBAction func closeButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func resetButton(_ sender: Any) {
        resetValue = true
        self.tableView.reloadData()
    }
    
    @IBAction func applyButton(_ sender: Any) {
        for cellItem in tableView.visibleCells {
            if cellItem.isKind(of: FilterCell.classForCoder()) {
                let cell = cellItem as! FilterCell
                delegate?.didReceiveFilter(filter: cell.getFilterValue())
                break
            }
        }
        
        self.dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension FilterController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: FilterCell.self), for: indexPath) as! FilterCell
        cell.setupFilterCell(shouldReset: resetValue, applyFilter: filter)
        cell.onSelection = { (result) -> () in
            // do stuff with the result
            self.present(result, animated: true, completion: nil)
        }
        resetValue = false
        
        return cell
    }
}
