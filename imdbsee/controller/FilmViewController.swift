//
//  ViewController.swift
//  imdbsee
//
//  Created by Gilles David on 07/03/2022.
//

import UIKit

class FilmViewController: UIViewController {

    private let filmModel = FilmModel.shared
    private var listFilms: [VideoToShow] = []
    
    @IBOutlet weak var btnSearch: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnSearch.titleLabel?.text = ""
        if #available(iOS 13.0, *) {
            activityIndicator.style = .large
        } else {
            activityIndicator.style = .whiteLarge
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        activityIndicatorAction(state: false)
    }
    override func viewWillAppear(_ animated: Bool) {
        activityIndicatorAction(state: false)
    }


    @IBAction func btnSearchAction(_ sender: UIButton) {
        showdialogbox()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "segueListFilm" {
                let destinationVC = segue.destination as! ListFilmFoundViewController
                destinationVC.listVideoToShow = listFilms
            }
        }
    func goToListFilmFound(){
        DispatchQueue.main.async { 
            self.performSegue(withIdentifier: "segueListFilm", sender: self)
        }
    }
    
    private func goToSearchFilm(msg: String){
        if !msg.isEmpty {
            activityIndicatorAction(state: true)
            filmModel.serachFilm(withKeyword: msg) { 
                [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case .Success(response: let responseSearchFilm):
                    self.activityIndicatorAction(state: false)
                    self.listFilms = responseSearchFilm
                    self.updateImgsFilm(findNb: 0)
                case .ZeroData:
                    self.activityIndicatorAction(state: false)
                    self.showError(msg: "Data not available")
                case .Failure(failure: let error):
                    self.activityIndicatorAction(state: false)
                    self.showError(msg: error.localizedDescription)
                }
            }
        }
    }
    
    private func activityIndicatorAction(state: Bool) {
        if state {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.activityIndicator.startAnimating()
                self.activityIndicator.isHidden = false
                self.btnSearch.isHidden = true
            }
        } else {
            DispatchQueue.main.async { 
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
                self.btnSearch.isHidden = false
            }
            
        }
    }
    
    private func updateImgsFilm(findNb: Int) {
        if findNb < listFilms.count {
            let urlImgToDowloadNow = listFilms[findNb].urlImg
            if urlImgToDowloadNow.count > 10 {
                filmModel.searchOneImage(url: urlImgToDowloadNow) {
                    [weak self] result in
                    guard let self = self else { return }
                    
                    switch result {
                    case .Success(let dataImg):
                        self.listFilms[findNb].dataImg = dataImg
                        self.updateImgsFilm(findNb: findNb + 1)
                    case .Failure(failure: let error):
                        self.showError(msg: error.localizedDescription)
                    }
                }
            }else {
                updateImgsFilm(findNb: findNb + 1)
            }
        } else {
            goToListFilmFound()
        }
    }
    
    private func showdialogbox(){
        let alert = UIAlertController(title: "Title request", message: nil, preferredStyle: .alert)
        
        alert.view.translatesAutoresizingMaskIntoConstraints = false
        
        alert.addTextField { (textField) in
            textField.placeholder = "enter title"
            textField.textContentType = .name
            
        }
        
        alert.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Search", style: .default, handler: { [self, weak alert] (_) in
            guard let textField = alert?.textFields?[0], let userText = textField.text else { return }
            goToSearchFilm(msg: userText)
        }))

        self.present(alert, animated: true, completion: nil)
    }
    
    private func showError(msg: String){
        let alertVC = UIAlertController(title: "Impossible", message: msg, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }
}

