//
//  PrefModel.swift
//  imdbsee
//
//  Created by Gilles David on 07/03/2022.
//

import Foundation

class PrefModel {
    
    public static let shared = PrefModel()
    private init() {}
    
    private let manageCoredata = ManageCoreData.shared
    
    public func getApiKey(keyName: String) -> String? {
        return manageCoredata.getOneKey(keyName: keyName)
    }
    
    public func saveApiKeyImdb(keyName: String, key: String) -> String? {
        return manageCoredata.saveOrUpdateOneKey(keyName: keyName, key: key)
    }
    
}
