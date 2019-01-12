//
//  SearchViewController.swift
//  NetflixRoulette
//
//  Created by Ramzy Kermad on 22/12/2018.
//  Copyright © 2018 Ramzy Kermad. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController , UISearchBarDelegate{
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).keyboardAppearance = .dark
        self.searchBar.showsCancelButton = true
        self.searchBar.delegate = self
         self.searchBar.becomeFirstResponder()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("Canel")
        searchBar.text = nil
        searchBar.showsCancelButton = false
        searchBar.endEditing(true)
    }

}
