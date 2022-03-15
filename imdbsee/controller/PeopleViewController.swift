//
//  PrefViewController.swift
//  imdbsee
//
//  Created by Gilles David on 07/03/2022.
//

import UIKit

class PeopleViewController: UIViewController {
    
    @IBOutlet weak var btnSearchPeople: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnSearchPeople.titleLabel?.text = ""
    }

    @IBAction func searchPeopleAction(_ sender: UIButton) {
        print("SEARCH People")
    }
    
}
