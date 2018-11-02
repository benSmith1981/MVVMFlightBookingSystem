//
//  SearchControllerTableViewController.swift
//  RyanAirBookingsTest
//
//  Created by Ben Smith on 01/11/2018.
//  Copyright © 2018 Ben Smith. All rights reserved.
//

import UIKit
import Foundation
import Foundation
import SVProgressHUD

class SearchControllerTableViewController: UITableViewController {
    var tripViewModel: TripViewModel!
    var unfilteredStations: [StationListModel] = []
    private var filteredStations: [StationListModel] = []
    var textField: BindingTextField?
    
    private var searchController: UISearchController = UISearchController(searchResultsController: nil)
    var currentSearchText: String = ""

    private var dataSource: TableViewDataSource<UITableViewCell,StationListModel>! //SourceViewModel rep each data in the cell we want to display

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()

        self.filteredStations = self.unfilteredStations
        self.filteredStations = filteredStations.sorted { $0.countryName! < $1.countryName! }
        self.dataSource = TableViewDataSource.init(cellIdentifier: R.reuseIdentifier.cell.identifier, items: self.filteredStations, configureCell: { (cell, viewModel) in
            cell.textLabel?.text = "\(viewModel.countryName ?? "Unknown"), \(viewModel.countryCode ?? "Unknown"), \(viewModel.code ?? "Unknown")"
        })
        self.tableView.dataSource = self.dataSource
    }

    func setupSearchBar(){
        
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.searchBar.returnKeyType = UIReturnKeyType.done
        searchController.searchBar.placeholder = "Search by Country or Code"
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false

        //TODO, fix the searching!!!
        self.tableView.tableHeaderView = searchController.searchBar
        searchController.searchBar.text = currentSearchText
        
    }

}

//#MARK: UITableViewDelegate
extension SearchControllerTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.searchController.searchBar.resignFirstResponder()
        self.searchController.isActive = false
        if textField?.tag == textFields.origin.rawValue {
            self.tripViewModel.origin.value = self.filteredStations[indexPath.row].code
        } else if textField?.tag == textFields.destination.rawValue {
            self.tripViewModel.destination.value = self.filteredStations[indexPath.row].code
        }
        self.navigationController?.popViewController(animated: true)
    }
}

extension SearchControllerTableViewController: UISearchBarDelegate, UISearchResultsUpdating {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchController.searchBar.resignFirstResponder()
    }
    
    //SEARCH SCHEDULER
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.isFirstResponder &&
            hasSearchTextChanged(searchBar) {
            self.filteredStations = []
            self.currentSearchText = searchBar.text!
            self.filterResults(searchBar: searchBar)
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if searchController.isActive &&
            hasSearchTextChanged(searchController.searchBar) {
            self.filteredStations = []
            self.currentSearchText = searchController.searchBar.text!
            self.filterResults(searchBar: searchController.searchBar)
        }
        
    }
    
    func hasSearchTextChanged(_ searchBar: UISearchBar) -> Bool{
        return self.currentSearchText != searchBar.text
    }
    
    func filterResults(searchBar: UISearchBar) {
        //filter
        self.filteredStations = self.unfilteredStations.filter { (results) -> Bool in
            let countryMatch = results.countryName?.lowercased().range(of:searchBar.text?.lowercased() ?? "")
            let codeMatch = results.code?.lowercased().range(of:searchBar.text?.lowercased() ?? "")

            return countryMatch != nil || codeMatch != nil ? true : false
        }
        self.dataSource.items = self.filteredStations
        self.tableView.reloadData()

    }

}
