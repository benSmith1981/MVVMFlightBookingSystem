//
//  ResultsTableViewController.swift
//  RyanAirBooker
//
//  Created by Ben Smith on 30/10/2018.
//  Copyright © 2018 Ben Smith. All rights reserved.
//

import UIKit

class ResultsTableViewController: UITableViewController {

    var resultsListViewModel: ResultsListViewModels!
    private var dataAccess: DataAccess!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.resultsListViewModel.resultViewModels.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.cell.identifier, for: indexPath)
        let resultViewModel = self.resultsListViewModel.resultViewModels[indexPath.row]
        cell.textLabel?.text = "\(resultViewModel.flightNumber ?? "Unknown"), \(resultViewModel.date ?? "Unknown"), \(resultViewModel.regularFare ?? 0)"
        return cell
    }

}
