//
//  ManageCoreDataBG.swift
//  imdbsee
//
//  Created by Gilles David on 21/03/2022.
//

import CoreData

class ManageCoreDataBG {
    
    private let coreDataContainer: NSPersistentContainer
    
    init(context: NSPersistentContainer) {
        self.coreDataContainer = context
        self.coreDataContainer.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    public func saveTop(resp: [ResponseVideoImdb], type: String){

        coreDataContainer.viewContext.performAndWait {
            let top = self.createOrUpdateTopEntity(withName: type)
            resp.forEach { oneVideo in
                if let id = oneVideo.id, let title = oneVideo.title {
                    let filmOpt = self.filmWithIdVideo(idFilm: id, title: title, oneVideo: oneVideo)
                    if let film = filmOpt {
                        let ftp = FilmToTop(context: AppDelegate.viewContext)
                        if let rank = oneVideo.rank {
                            ftp.rank = Int16(rank)!
                            ftp.ftpToFilm = film
                            ftp.ftpToTop = top
                            do { try AppDelegate.viewContext.save() }
                            catch {
                                print("**********saveTop> 1",error.localizedDescription)
                            }
                        }
                    }
                } else {
                    print("***********saveTop> 2")
                }
            }
        }
            
    }
    
    public func createOrUpdateTopEntity(withName type: String) -> Top {
        let dateNow = Calendar.current.dateComponents(in: .current, from: Date()).date! 
        
        let request: NSFetchRequest<Top> = Top.fetchRequest()
        request.predicate = NSPredicate(format: "name == %@", type)
        if let top = try? AppDelegate.viewContext.fetch(request) {
            if top != [] {
                // Already exist, then just update dateModif
                top[0].dateModif = dateNow
                do {
                    try AppDelegate.viewContext.save()
                }
                catch {
                    print("*******createOrUpdateTopEntity 2>",error.localizedDescription)
                }
                return top[0]
            }
        }
        
        // Doesn't exist, create new Top with name 'type'
        let top = Top(context: AppDelegate.viewContext)
        top.name = type
        top.dateModif = dateNow
        do {
            try AppDelegate.viewContext.save()
        } catch {
            print("*************createOrUpdateTopEntity>",error.localizedDescription)
        }
        return top
        
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
    
}
