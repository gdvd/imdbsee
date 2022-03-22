//
//  PrefViewController.swift
//  imdbsee
//
//  Created by Gilles David on 07/03/2022.
//

import UIKit

class PrefViewController: UIViewController, UITextFieldDelegate {

    let prefModel = PrefModel.shared
    var currentKeyImdb = ""
    
    @IBOutlet weak var apiKeyImdbTextField: UITextField!
    @IBOutlet weak var btnApikeyImdb: UIButton!
    
    @IBOutlet weak var btnEraseTopFilms: UIButton!
    @IBOutlet weak var btnEraseTopTvs: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initData()
    }
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        changeStateForNoEditionKey()
    }
    internal func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        saveKey()
        return true
    }
    
    //MARK: - Manage APIKey 
    private func initData() {
        if let apiKeyImdb = prefModel.getApiKey(keyName: Constants.nameApiKeyImdb) {
            apiKeyImdbTextField.text = apiKeyImdb
            currentKeyImdb = apiKeyImdb
            changeStateForNoEditionKey()
        } else {
            changeStateForEditionKey()
        }
    }
    
    private func saveKey() {
        if let newkey = apiKeyImdbTextField?.text {
            if newkey.count > 5 {
                let resultOpt = prefModel.saveApiKeyImdb(keyName: Constants.nameApiKeyImdb, key: newkey)
                if resultOpt != nil {
                    currentKeyImdb = newkey
                    changeStateForNoEditionKey()
                } else {
                    showError(msg: "Error, canot save apikey")
                    apiKeyImdbTextField.text = currentKeyImdb
                }
            }
        }
    }
    private func changeStateForEditionKey() {
        apiKeyImdbTextField.becomeFirstResponder()
        apiKeyImdbTextField.isUserInteractionEnabled = true
        btnApikeyImdb.setTitle(Constants.txtSave, for: .normal)
    }
    private func changeStateForNoEditionKey() {
        apiKeyImdbTextField.text = currentKeyImdb
        apiKeyImdbTextField.resignFirstResponder()
        apiKeyImdbTextField.isUserInteractionEnabled = false
        btnApikeyImdb.setTitle(Constants.txtEdit, for: .normal)
    }

    @IBAction func actionApikeyImdb(_ sender: UIButton) {
        if btnApikeyImdb.titleLabel?.text == Constants.txtEdit {
            changeStateForEditionKey()
        } else {
            saveKey()
        }
    }
    
    //MARK: - Manage delete topList
    private func eraseList(type: String) {
        print("I go to delete list", type)
        
        prefModel.deleteListTop(type: type) {
            result in
            switch result {
            case true:
                print("===============It's done")
            case false:
                self.showError(msg: "Operation failed")
            }
        }
    }
    
    private func showError(msg: String){
        let alertVC = UIAlertController(title: "Impossible", message: msg, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }
    
    
    @IBAction func actionEraseTopFilms(_ sender: UIButton) {
        showdialogbox(type: Constants.strTopFilms)
    }
    
    
    @IBAction func actionEraseTopTvs(_ sender: UIButton) {
        showdialogbox(type: Constants.strTopTvs)
    }
    
    private func showdialogbox(type: String){
        let alert = UIAlertController(title: "Warning", message: "Are you sure ?", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Delete 'Top \(type)'", style: .destructive, handler: { 
            [self] (_) in
            self.eraseList(type: type)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }

}
