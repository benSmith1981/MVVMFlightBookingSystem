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
    var textField: BindingTextField?
    var textFieldType: textFields?
    
    private var searchController: UISearchController = UISearchController(searchResultsController: nil)
    private var filteredStations: [StationListModel] = []
    private var currentSearchText: String = "" //current page we are scrolling on

    override func viewDidLoad() {
        super.viewDidLoad()

        self.filteredStations = self.unfilteredStations
        self.filteredStations = filteredStations.sorted { $0.countryName! < $1.countryName! }

        setupSearchBar()
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
        self.navigationController?.navigationItem.titleView = searchController.searchBar
        
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.filteredStations.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let station = self.filteredStations[indexPath.row]
        cell.textLabel?.text = "\(station.countryName ?? "Unknown"), \(station.countryCode ?? "Unknown"), \(station.code ?? "Unknown")"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.searchController.searchBar.resignFirstResponder()
        self.searchController.isActive = false
        //I am only setting thte tripview model here because the binding doesnt work on textfield, TODO
        if textFieldType == textFields.destination {
            self.tripViewModel.destination.value = self.filteredStations[indexPath.row].code
        } else if textFieldType == textFields.origin{
            self.tripViewModel.origin.value = self.filteredStations[indexPath.row].code
        }
        self.textField?.text = self.filteredStations[indexPath.row].code
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
        self.tableView.reloadData()

    }

}
