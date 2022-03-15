//
//  ViewController.swift
//  imdbsee
//
//  Created by Gilles David on 07/03/2022.
//

import UIKit

class FilmViewController: UIViewController {

    @IBOutlet weak var btnSearch: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnSearch.titleLabel?.text = ""
    }


    @IBAction func btnSearchAction(_ sender: UIButton) {
        print("SEARCH Films")
    }
}

