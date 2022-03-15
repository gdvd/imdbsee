//
//  TopViewController.swift
//  imdbsee
//
//  Created by Gilles David on 07/03/2022.
//

import UIKit

class TopViewController: UIViewController {
    
    private let topModel = TopModel.shared
    
    @IBOutlet weak var listsSegmented: UISegmentedControl!
    @IBOutlet weak var tableFilms: UITableView!
    
    private var listVideoToShow:[ElementVideo] = []
    private var listFilms:[ElementVideo] = []
    private var listTvs:[ElementVideo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initTable(seg: 0)
    }

    private func initTable(seg: Int) {
        if seg == 0 {
            loadListTopFilms()
        } else if seg == 1 {
            loadListTopTvs()
        }
    }
    private func loadListTopFilms(){
        if listFilms.count == 0 {
            topModel.loadListTops(type: Constants.strTopFilms){
                result in
                switch result {
                case .Success(response: let resp):
                    print("Return Success")
                    print(resp.count)
                    //TODO: Next
                case .ZeroData:
                    print("Return zero")
                    //TODO: Next
                case .Failure(let error):
                    print("Return Failure with error :", error)
                    //TODO: Next
                }
            }
            //TODO: get data and show them
        } else {
            listVideoToShow = listFilms
            tableFilms.reloadData()
        }
        
    }
    private func loadListTopTvs() {
        if listTvs.count == 0 {
            //topModel.loadListTopTvs()
            //TODO: get data and show them
        } else {
            listVideoToShow = listTvs
            tableFilms.reloadData()
        }
    }

    @IBAction func segmentChange(_ sender: UISegmentedControl) {
        initTable(seg: sender.selectedSegmentIndex)
    }
}

//MARK: - TableViewDataSource
extension TopViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listVideoToShow.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TopCell", for: indexPath) as? TopCustomTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(elementVideo: listVideoToShow[indexPath.row])
        return cell
    }
    
}
