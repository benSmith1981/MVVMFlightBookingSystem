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

enum textFields: Int {
    case origin = 1
    case destination = 2
}
class TripTableViewController: UITableViewController, ShowsAlert {

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
    private var selectedTextFieldTag: textFields?
    private let datePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        createTripModel()
        bindTextfieldsToTripModel()
        showDatePicker()
        getStations()
        
        self.originTextField.delegate = self
        self.destinationTextField.delegate = self

        
    }
    
    func getStations(){
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

        if self.tripViewModel.isValid {
            self.resultsListViewModel = ResultsListViewModels(tripviewModel: self.tripViewModel)
            self.resultsListViewModel.search(tripviewModel: self.tripViewModel) { (resultListViewModels, message) in
                print(resultListViewModels)
                if resultListViewModels.resultViewModels.count > 0 {
                    self.performSegue(withIdentifier: R.segue.ryanAirBookingsTestTripTableViewController.showResults, sender: self)
                } else {
                    self.showAlert(message: "No Results")
                }
                
            }
        } else {
            print(self.tripViewModel.validationError)
            var errorString = ""
            for error in self.tripViewModel.validationError {
                errorString += "\(error.message) "
            }
            self.showAlert(message: errorString)

        }

    }
    
    @IBAction func add(_ sender: Any){
        if let button = sender as? UIButton {
            
            //TODO, make the binding work so we don't have to set the model as well as the textfiled!!!
            if button.tag == buttonTags.adults.rawValue {
                self.adultsTextField.add()
            } else if button.tag == buttonTags.teen.rawValue {
                self.teenTextField.add()
            } else if button.tag == buttonTags.children.rawValue {
                self.childrenTextField.add()
            }
        }
    }

    @IBAction func subtract(_ sender: Any){
        if let button = sender as? UIButton {
            //TODO, make the binding work so we don't have to set the model as well as the textfiled!!!
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
        if segue.identifier == R.segue.ryanAirBookingsTestTripTableViewController.showResults.identifier {
            let resultsVC = segue.destination as! ResultsTableViewController
            resultsVC.resultsListViewModel = self.resultsListViewModel
        }
        if segue.identifier == "searchView" {
            let search = segue.destination as! SearchControllerTableViewController
            
            search.unfilteredStations = self.stationListViewModel.stationListViewModels
            search.tripViewModel = self.tripViewModel
            search.textField = selectedTextFieldTag == textFields.origin ? self.originTextField : self.destinationTextField
        }

    }
}
//#MARK: Date picker things...refactor to other class?
extension TripTableViewController {
    func showDatePicker(){
        //Formate Date
        datePicker.datePickerMode = .date
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
        
        toolbar.setItems([doneButton], animated: false)
        
        departureTextField.inputAccessoryView = toolbar
        departureTextField.inputView = datePicker
        
    }
    
    @objc func donedatePicker(){
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        departureTextField.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
}


extension TripTableViewController: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField.tag == textFields.origin.rawValue || textField.tag == textFields.destination.rawValue{
            self.selectedTextFieldTag = textField.tag == textFields.origin.rawValue ? textFields.origin : textFields.destination
            self.performSegue(withIdentifier: "searchView", sender: self)
            
        }
        return true
    }
}
