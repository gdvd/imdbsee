//
//  ManageCoreData.swift
//  imdbsee
//
//  Created by Gilles David on 07/03/2022.
//

import CoreData

class ManageCoreData {
    
    public static let shared = ManageCoreData()
    init() {}
    

    //MARK: - TopVideo
    public func getAllDataTop(withName type: String) -> Top? {
        let request: NSFetchRequest<Top> = Top.fetchRequest()
        request.predicate = NSPredicate(format: "name == %@", type)
        
        var tops: [Top]?
        do {
            tops = try? AppDelegate.viewContext.fetch(request)
        }
        
        if let top = tops, tops!.count != 0 {
            return top[0]
        } else {
            return nil
        }
    }
    
    private func filmWithIdVideo(idFilm: String, title: String, oneVideo: ResponseVideoImdb) -> Film?{
        
        let request: NSFetchRequest<Film> = Film.fetchRequest()
        request.predicate = NSPredicate(format: "idFilm == %@", idFilm)
        let filmOpt = try? AppDelegate.viewContext.fetch(request)
        if filmOpt != nil && filmOpt != [] {
            return filmOpt![0]
        } else {
            let film = Film(context: AppDelegate.viewContext)
            film.idFilm = idFilm
            film.title = title
            let rating = oneVideo.imDbRating ?? "0.0"
            film.rating = Double(rating) ?? 0
            let ratingCount = oneVideo.imDbRatingCount ?? "0"
            film.ratingCount = Int32(ratingCount) ?? 0
            let year = oneVideo.year ?? "0"
            film.year = Int16(year) ?? 0
            film.urlImg = oneVideo.image ?? ""
            film.crews = oneVideo.crew ?? ""
            do {
                try? AppDelegate.viewContext.save()
                return film
            }
        }
    }
    
    public func deleteOneTop(type: String, completionHandler: @escaping(Bool) -> Void ) {
        let request: NSFetchRequest<Top> = Top.fetchRequest()
        request.predicate = NSPredicate(format: "name == %@", type)
        do {
            let topOpt = try AppDelegate.viewContext.fetch(request)
            for entity in topOpt {
                AppDelegate.viewContext.delete(entity)
            }
            completionHandler(true)
        } catch {
            completionHandler(false)        
        }
    }
    
    //MARK: - ApiKey
    public func getOneKey(keyName: String) -> String? {
        let request: NSFetchRequest<Pref> = Pref.fetchRequest()
        request.predicate = NSPredicate(format: "apiKeyName == %@", keyName)
        if let pref = try? AppDelegate.viewContext.fetch(request) {
            if pref != [] {
                return pref[0].key
            }
        }
        return nil
    }
    
    private func ifKeynameExistInDB(keyName: String) -> Bool{
        if keyName != "" {
            let request: NSFetchRequest<Pref> = Pref.fetchRequest()
            request.predicate = NSPredicate(format: "apiKeyName == %@", keyName)
            let res = try? AppDelegate.viewContext.fetch(request)
            return res != nil && res != []
        }
        return false
    }
    
    private func saveOneKey(keyName: String, key: String) -> String? {
        let pref = Pref(context: AppDelegate.viewContext)
        pref.key = key
        pref.apiKeyName = keyName
        do {
            try AppDelegate.viewContext.save()
        } catch {
            return nil
        }
        return pref.key
    }
    
    public func saveOrUpdateOneKey(keyName: String, key: String) -> String?{
        if ifKeynameExistInDB(keyName: keyName) {
            // Update Pref(keyName/newKey)
            return updateOneKey(keyName: keyName, newKey: key)
        } else {
            // Create new Pref(keyName/key)
            return saveOneKey(keyName: keyName, key: key)
        }
    }
    
    private func updateOneKey(keyName: String, newKey: String) -> String?{
        let request: NSFetchRequest<Pref> = Pref.fetchRequest()
        request.predicate = NSPredicate(format: "apiKeyName == %@", keyName)
        if let pref = try? AppDelegate.viewContext.fetch(request)[0] {
            pref.setValue(newKey, forKey: "apiKeyName")
            do {
                try AppDelegate.viewContext.save()
            }
            catch {
                return nil
            }
            return pref.key
        }     
        return nil
    }
    
}
