//
//  TripTableViewController.swift
//  RyanAirBooker
//
//  Created by Ben Smith on 30/10/2018.
//  Copyright © 2018 Ben Smith. All rights reserved.
//

import UIKit

enum buttonTags: Int {
    case adults = 0
    case teen
    case children
}
class TripTableViewController: UITableViewController {

    @IBOutlet var originTextField: BindingTextField! {
        didSet {
            originTextField.bind { self.tripViewModel.origin.value = $0 }
        }
    }
    @IBOutlet var destinationTextField: BindingTextField!{
        didSet {
            destinationTextField.bind { self.tripViewModel.destination.value = $0 }
        }
    }
    @IBOutlet var departureTextField: BindingTextField!{
        didSet {
            departureTextField.bind { self.tripViewModel.departure.value = $0 }
        }
    }
    @IBOutlet var adultsTextField: BindingTextField!{
        didSet {
            adultsTextField.bind { self.tripViewModel.adults.value = $0 }
        }
    }
    @IBOutlet var teenTextField: BindingTextField!{
        didSet {
            teenTextField.bind { self.tripViewModel.teen.value = $0 }
        }
    }
    @IBOutlet var childrenTextField: BindingTextField!{
        didSet {
            childrenTextField.bind { self.tripViewModel.children.value = $0 }
        }
    }
    
    private var tripViewModel: TripViewModel!
    private var resultsListViewModel: ResultsListViewModels!
    private var stationListViewModel: StationListViewModel = StationListViewModel.init()

    private var dataAccess: DataAccess!

    override func viewDidLoad() {
        super.viewDidLoad()

        createTripModel()
        bindTextfieldsToTripModel()
        
        self.stationListViewModel.getAllStations { (stationListViewModel, success) in
            if success {
                self.stationListViewModel = stationListViewModel
            } else {
                print("Failed to get stations")
            }
        }
    }
    
    func createTripModel() {
        self.tripViewModel = TripViewModel.init(origin: originTextField.text!,
                                                destination: destinationTextField.text!,
                                                departure: departureTextField.text!,
                                                adults: adultsTextField.text!,
                                                teen: teenTextField.text!,
                                                children: childrenTextField.text!)
    }
    
    func bindTextfieldsToTripModel() {
        self.tripViewModel.adults.bind(listener: {self.adultsTextField.text = $0})
        self.tripViewModel.teen.bind(listener: {self.teenTextField.text = $0})
        self.tripViewModel.children.bind(listener: {self.childrenTextField.text = $0})
        self.tripViewModel.departure.bind(listener: {self.departureTextField.text = $0})
        self.tripViewModel.destination.bind(listener: {self.destinationTextField.text = $0})
        self.tripViewModel.origin.bind(listener: {self.originTextField.text = $0})
    }
    
    @IBAction func search() {
        print(self.tripViewModel.destination.value)
        print(self.tripViewModel.adults.value)

        if self.tripViewModel.isValid {
            self.resultsListViewModel = ResultsListViewModels(tripviewModel: self.tripViewModel)
            self.resultsListViewModel.search(tripviewModel: self.tripViewModel) { (resultListViewModels, message) in
                print(resultListViewModels)
                self.performSegue(withIdentifier: R.segue.ryanAirBookingsTestTripTableViewController.showResults, sender: self)
            }
        } else {
            print(self.tripViewModel.validationError)
        }

    }
    
    @IBAction func add(_ sender: Any){
        if let button = sender as? UIButton {
            
            if button.tag == buttonTags.adults.rawValue {
                self.adultsTextField.add()
                print(self.tripViewModel.adults.value)
            } else if button.tag == buttonTags.teen.rawValue {
                self.teenTextField.add()
            } else if button.tag == buttonTags.children.rawValue {
                self.childrenTextField.add()
            }
        }
    }

    @IBAction func subtract(_ sender: Any){
        if let button = sender as? UIButton {
            
            if button.tag == buttonTags.adults.rawValue {
                self.adultsTextField.subtract()
            } else if button.tag == buttonTags.teen.rawValue {
                self.teenTextField.subtract()
            } else if button.tag == buttonTags.children.rawValue {
                self.childrenTextField.subtract()
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let resultsVC = segue.destination as! ResultsTableViewController
        resultsVC.resultsListViewModel = self.resultsListViewModel
    }
}
