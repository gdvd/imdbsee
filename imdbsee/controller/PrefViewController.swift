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
            print("apiKeyImdbTextField \(newkey)")
            if newkey.count > 5 {
                let resultOpt = prefModel.saveApiKeyImdb(keyName: Constants.nameApiKeyImdb, key: newkey)
                if resultOpt != nil {
                    print("=====> Success")
                    currentKeyImdb = newkey
                    changeStateForNoEditionKey()
                } else {
                    print("****** Error, canot save apikey")
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
    
}
