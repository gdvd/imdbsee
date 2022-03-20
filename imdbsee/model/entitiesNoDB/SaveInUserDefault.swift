//
//  SaveInUserDefault.swift
//  intrip
//
//  Created by Gilles David on 18/01/2022.
//

import Foundation

struct SaveInUserDefault {
    static var apiKey: String {
        get {
            return UserDefaults.standard.string(forKey: Constants.nameApiKeyImdb) ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Constants.nameApiKeyImdb)
        }
    }
}
