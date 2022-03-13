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
    
    private let context = AppDelegate.viewContext
    
    //MARK: - TopVideo
    public func getAllDataTop(withName type: String) -> Top? {
        let request: NSFetchRequest<Top> = Top.fetchRequest()
        request.predicate = NSPredicate(format: "name == %@", type)
        
        var tops: [Top]?
        do {
            tops = try? context.fetch(request)
        }
        
        if let top = tops {
            return top[0]
        } else {
            return nil
        }
    }
    public func saveDataTop(resp: [ResponseVideoImdb], type: String) -> Bool {
        
        let top = createOrUpdateTopEntity(withName: type)
        var nbError = 0
            
            resp.forEach { oneVideo in
                if let id = oneVideo.id, let title = oneVideo.title {
                    
                    /////////
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: { 

                    let filmOpt = self.filmWithIdVideo(idFilm: id, title: title, oneVideo: oneVideo)
                    if let film = filmOpt {
                        let ftp = FilmToTop(context: self.context)
                        if let rank = oneVideo.rank {
                            ftp.rank = Int16(rank)!
                            ftp.ftpToFilm = film
                            ftp.ftpToTop = top
                            do { try self.context.save() }
                            catch {
                                nbError += 1
                                print(error.localizedDescription)
                            }
                        }
                    }
                        
                    ////////////
                    })
                    
                    if nbError > 5 { return }
                } else {
                    print("Pb")
                }
            }
        if nbError > 5 { 
            return false 
        } else {
            return true }
    }
    private func filmWithIdVideo(idFilm: String, title: String, oneVideo: ResponseVideoImdb) -> Film?{
        
        let request: NSFetchRequest<Film> = Film.fetchRequest()
        request.predicate = NSPredicate(format: "idFilm == %@", idFilm)
        let filmOpt = try? context.fetch(request)
        if filmOpt != nil && filmOpt != [] {
            return filmOpt![0]
        } else {
            let film = Film(context: context)
            film.idFilm = idFilm
            film.title = title
            let rating = oneVideo.imDbRating ?? "0.0"
            film.rating = Double(rating) ?? 0
            let ratingCount = oneVideo.imDbRatingCount ?? "0"
            film.ratingCount = Int32(ratingCount) ?? 0
            let year = oneVideo.year ?? "0"
            film.year = Int16(year) ?? 0
            film.urlImg = oneVideo.image ?? ""
            do {
                try? context.save()
                return film
            }
        }
    }
    
    private func deleteAllRank(top: Top){
        // Delete all FilmToTop with top
        let request: NSFetchRequest<FilmToTop> = FilmToTop.fetchRequest()
        request.predicate = NSPredicate(format: "ftpToTop == %@", top)
        do {
            let topOpt = try? context.fetch(request)
            for entity in topOpt! {
                print("****** Delete obj FilmToTop with rank\t\(entity.rank)")
                context.delete(entity)
            }
        }
    }
    private func createOrUpdateTopEntity(withName type: String) -> Top {
        let request: NSFetchRequest<Top> = Top.fetchRequest()
        request.predicate = NSPredicate(format: "name == %@", type)
        let topOpt = try? context.fetch(request)
        let dateNow = Calendar.current.dateComponents(in: .current, from: Date()).date! 
        if let top = topOpt, topOpt != [] {
            // Already exist, then just update dateModif
            top[0].dateModif = dateNow
            do {
                try context.save()
            }
            catch {
                print(error.localizedDescription)
            }
            deleteAllRank(top: top[0])
            return top[0]
        } else {
            // Doesn't exist, create new Top with name 'type'
            let top = Top(context: context)
            top.name = type
            top.dateModif = dateNow
            do {
                try context.save()
            } catch {
                print(error.localizedDescription)
            }
            return top
        }
    }
    //MARK: - ApiKey
    public func getOneKey(keyName: String) -> String? {
        let request: NSFetchRequest<Pref> = Pref.fetchRequest()
        request.predicate = NSPredicate(format: "apiKeyName == %@", keyName)
        if let pref = try? context.fetch(request) {
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
            let res = try? context.fetch(request)
            return res != nil && res != []
        }
        return false
    }
    private func saveOneKey(keyName: String, key: String) -> String?{
        let pref = Pref(context: context)
        pref.key = key
        pref.apiKeyName = keyName
        do {
            try context.save()
        } catch let error {
            print("***saveOneKey> ",error.localizedDescription)
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
        if let pref = try? context.fetch(request)[0] {
            //pref.key = newKey
            pref.setValue(newKey, forKey: "apiKeyName")
            do {
                try context.save()
            }
            catch {
                print("***updateOneKey> ",error.localizedDescription)
                return nil
            }
            return pref.key
        }     
        return nil
    }
    
}
