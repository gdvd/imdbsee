//
//  TopViewController.swift
//  imdbsee
//
//  Created by Gilles David on 07/03/2022.
//

import UIKit

class TopViewController: UIViewController {
    
    private let topModel = TopModel.shared
    private var rowSelected = 0
    
    @IBOutlet weak var listsSegmented: UISegmentedControl!
    @IBOutlet weak var tableFilms: UITableView!
    
    private var listVideoToShow:[VideoToShow] = []
    private var listFilms:[VideoToShow] = []
    private var listTvs:[VideoToShow] = []
    
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
    

    //MARK: - TopFilm
    private func loadListTopFilms(){
        if listFilms.count == 0 {
            topModel.loadListTops(type: Constants.strTopFilms){
                
                [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case .Success(response: let resp):
                    print("Return Success TopFilm size : \(resp.count)")
                    self.listFilms = resp
                    self.listVideoToShow = resp
                    self.updateImgsFilm(findNb: 0)
                    DispatchQueue.main.async {
                        self.tableFilms.reloadData()
                    }
                case .ZeroData:
                    print("Return zero")
                    //TODO: Next
                case .Failure(let error):
                    print("Return Failure with error :", error.localizedDescription)
                    //TODO: Next
                }
            }
            //TODO: get data and show them
        } else {
            print("=== TopFilm size : \(listFilms.count)")
            listVideoToShow = listFilms
            updateImgsFilm(findNb: 0)
            DispatchQueue.main.async {
                self.tableFilms.reloadData() }
        }
    }
    private func updateImgsFilm(findNb: Int) {
        if findNb < listVideoToShow.count && findNb < listFilms.count {
            let urlImgToDowloadNow = listVideoToShow[findNb].urlImg
            if urlImgToDowloadNow.count > 10 {
                topModel.searchOneImage(url: urlImgToDowloadNow) {
                    [self] result in
                    switch result {
                    case .Success(let dataImg):
                        self.listFilms[findNb].dataImg = dataImg
                        self.listVideoToShow[findNb].dataImg = dataImg
                        DispatchQueue.main.async {
                            self.tableFilms.reloadData()
                        }
                        updateImgsFilm(findNb: findNb + 1)
                    case .Failure(failure: let error):
                        print("******TVCupdateImgsFilm> error\(listVideoToShow[findNb].title)  \(urlImgToDowloadNow) ", error.localizedDescription)
                    }
                }
            }else {
                updateImgsFilm(findNb: findNb + 1)
            }
        }
    }
    //MARK: - TopTv
    private func loadListTopTvs() {
        if listTvs.count == 0 {
            topModel.loadListTops(type: Constants.strTopTvs){
                
                [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case .Success(response: let resp):
                    print("Return Success TopFilmTV size : \(resp.count)")
                    self.listTvs = resp
                    self.listVideoToShow = resp
                    self.updateImgsTv(findNb: 0)
                    DispatchQueue.main.async {
                        self.tableFilms.reloadData()
                    }
                case .ZeroData:
                    print("Return zero")
                    //TODO: Next
                case .Failure(let error):
                    print("Return Failure with error :", error.localizedDescription)
                    //TODO: Next
                }
            }
            //TODO: get data and show them
        } else {
            print("=== TopFilmTV size : \(listTvs.count)")
            listVideoToShow = listTvs
            updateImgsTv(findNb: 0)
            DispatchQueue.main.async {
                self.tableFilms.reloadData() }
        }
    }
    private func updateImgsTv(findNb: Int) {
        if findNb < listVideoToShow.count && findNb < listTvs.count {
            let urlImgToDowloadNow = listVideoToShow[findNb].urlImg
            if urlImgToDowloadNow.count > 10 {
                topModel.searchOneImage(url: urlImgToDowloadNow) {
                    [self] result in
                    switch result {
                    case .Success(let dataImg):
                        self.listVideoToShow[findNb].dataImg = dataImg
                        self.listTvs[findNb].dataImg = dataImg
                        DispatchQueue.main.async {
                            self.tableFilms.reloadData()
                        }
                        updateImgsFilm(findNb: findNb + 1)
                        
                    case .Failure(failure: let error):
                        print("******updateImgsTv> error", error.localizedDescription)
                    }
                }
            }else {
                updateImgsFilm(findNb: findNb + 1)
            }
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        rowSelected = indexPath[1]
//        print("--->rowSelected", rowSelected)
        performSegue(withIdentifier: "segueTopToDetail", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueTopToDetail" {
            let detailVC = segue.destination as! DetailOneFilmViewController
            detailVC.videoToShow = listVideoToShow[rowSelected]
        }
    }
    
}
