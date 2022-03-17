//
//  ListFilmFoundViewController.swift
//  imdbsee
//
//  Created by Gilles David on 17/03/2022.
//

import UIKit

class ListFilmFoundViewController: UIViewController {

    var listFilms: [FilmToShow] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBOutlet weak var tableFilmFound: UITableView!
    
    
    override func viewWillAppear(_ animated: Bool) {
        print("listFilms.count", listFilms.count)
    }
    
}
//MARK: - TableViewDataSource
extension ListFilmFoundViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listFilms.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "filmFoundCell", for: indexPath) as? FilmCustomTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(elementVideo: listFilms[indexPath.row])
        return cell
    }
    
}
