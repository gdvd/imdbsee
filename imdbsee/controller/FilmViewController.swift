//
//  ViewController.swift
//  imdbsee
//
//  Created by Gilles David on 07/03/2022.
//

import UIKit

class FilmViewController: UIViewController {

    private let filmModel = FilmModel.shared
    
    @IBOutlet weak var btnSearch: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnSearch.titleLabel?.text = ""
    }


    @IBAction func btnSearchAction(_ sender: UIButton) {
        print("SEARCH Films")
        showdialogbox()
    }
    
    private func testAction(msg: String){
        if !msg.isEmpty {
            filmModel.serachFilm(withKeyword: msg) { 
                
                [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case .Success(response: let resp):
                    print("Return Success TopFilm size : \(resp.count)")
                case .ZeroData:
                    print("Return zero")//TODO: Next
                case .Failure(failure: let failure):
                    print("Return Failure with error :", failure.localizedDescription)
                    //TODO: Next
                }
            }
        }
    }

    private func showdialogbox(){
        let alert = UIAlertController(title: "Title request", message: nil, preferredStyle: .alert)
        /*
         [LayoutConstraints] Changing the translatesAutoresizingMaskIntoConstraints property of a UICollectionViewCell that is managed by a UICollectionView is not supported, and will result in incorrect self-sizing. View: <_UIAlertControllerTextFieldViewCollectionCell: 0x100d36360; frame = (0 0; 270 24); gestureRecognizers = <NSArray: 0x280bedd10>; layer = <CALayer: 0x2805d2280>>
         */
        //alert.view.translatesAutoresizingMaskIntoConstraints = false
        
        alert.addTextField { (textField) in
            textField.placeholder = "enter title"
        }
        alert.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Search", style: .default, handler: { [self, weak alert] (_) in
            guard let textField = alert?.textFields?[0], let userText = textField.text else { return }
            testAction(msg: userText)
        }))
                
        self.present(alert, animated: true, completion: nil)
    }
}

