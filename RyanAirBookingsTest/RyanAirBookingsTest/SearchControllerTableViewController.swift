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
    private var filteredStations: [StationListModel] = []
    var unfilteredStations: [StationListModel] = []
    var textField: BindingTextField?
    private var currentSearchText: String = "" //current page we are scrolling on
    var searchController: UISearchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.filteredStations = self.unfilteredStations
        setupSearchBar()
    }

    func setupSearchBar(){
        
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.searchBar.returnKeyType = UIReturnKeyType.done
        searchController.searchBar.placeholder = "Search by Country or Code"
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        
//        self.navigationController?.navigationBar.addSubview(searchController.searchBar)
        
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
        cell.textLabel?.text = "\(station.countryName ?? "Unknown"), \(station.countryCode ?? "Unknown")"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.searchController.searchBar.resignFirstResponder()
        self.searchController.isActive = false
        self.textField?.text = self.filteredStations[indexPath.row].countryCode
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
            let tmp = results.countryName
            let range = tmp?.range(of: searchBar.text ?? "", options: NSString.CompareOptions.caseInsensitive)
            return range?.isEmpty != true
            
        }
        self.tableView.reloadData()

    }

}
