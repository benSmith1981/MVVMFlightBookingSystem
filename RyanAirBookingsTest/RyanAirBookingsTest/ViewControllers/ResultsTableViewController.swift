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
    private var dataSource: TableViewDataSource<UITableViewCell,ResultViewModel>! //SourceViewModel rep each data in the cell we want to display
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = TableViewDataSource.init(cellIdentifier: R.reuseIdentifier.cell.identifier, items: self.resultsListViewModel.resultViewModels, configureCell: { (cell, viewModel) in
                cell.textLabel?.text = "\(viewModel.flightNumber ?? "Unknown"), \(viewModel.date.nicelyFormattedDateString() ), £\(viewModel.regularFare ?? 0)"
        })
        self.tableView.dataSource = self.dataSource
        self.tableView.reloadData()
    }


}
