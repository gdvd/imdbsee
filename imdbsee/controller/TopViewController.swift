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
    
    private var step = 5
    private var updateListToShowIsRunning = false
    
    @IBOutlet weak var segment: UISegmentedControl!
    @IBOutlet weak var tableFilms: UITableView!
    
    private var listVideoToShow:[VideoToShow] = []
    private var listFilms:[VideoToShow] = []
    private var listTvs:[VideoToShow] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initTable(seg: 0)
        
        let nameFilms = Notification.Name(rawValue: Constants.strTopFilms + "ResetList")
        NotificationCenter.default.addObserver(self, selector: #selector(triggerResetListFilms), name: nameFilms, object: nil)
        
        let nameTvs = Notification.Name(rawValue: Constants.strTopTvs + "ResetList")
        NotificationCenter.default.addObserver(self, selector: #selector(triggerResetListTvs), name: nameTvs, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {

        DispatchQueue.main.async { [self] in
            switch segment.selectedSegmentIndex {
            case 0:
                if listFilms.count == 0 {
                    listVideoToShow = []
                    initTable(seg: 0)
                }
            case 1:
                if listTvs.count == 0 {
                    listVideoToShow = []
                    initTable(seg: 1)
                }
            default:
                break
            }
        }
    }
    
    @objc func triggerResetListFilms (){
        listFilms = []
    }
    
    @objc func triggerResetListTvs (){
        listTvs = []
    }
    
    private func initTable(seg: Int) {
        self.makeSegment(setup: false)
        listVideoToShow = []
        checkAndRemoveFooter()
        if seg == 0 {
            loadListTopFilms()
        } else if seg == 1 {
            loadListTopTvs()
        }
    }
    
    @IBAction func segmentChange(_ sender: UISegmentedControl) {
        initTable(seg: sender.selectedSegmentIndex)
    }
    
    private func showError(msg: String){
        let alertVC = UIAlertController(title: "Impossible", message: msg, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }
    

    //MARK: - Update tableFilms
    private func loadListTopFilms(){
        if listFilms.count == 0 {
            topModel.loadListTops(type: Constants.strTopFilms){
                
                [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case .Success(response: let resp):
                    self.listFilms = resp
                    DispatchQueue.main.async{
                        self.updateListToShow(withType: self.segment.selectedSegmentIndex)
                    }
                case .ZeroData:
                    self.showError(msg: "Data not available")
                    self.makeSegment(setup: true)
                case .Failure(let error):
                    self.showError(msg: error.localizedDescription)
                    self.makeSegment(setup: true)
                }
            }
        } else {
            self.updateListToShow(withType: self.segment.selectedSegmentIndex)
            DispatchQueue.main.async {
                self.tableFilms.reloadData() }
        }
    }
    private func makeSegment(setup: Bool){
        DispatchQueue.main.async{
            self.segment.isEnabled = setup
        }
    }
    private func updateListToShow(withType: Int) {
        // Works one by one, only
        if updateListToShowIsRunning {
            return
        } else {
            updateListToShowIsRunning = true
        }
        
        // Prepare the supplement list of videos to be shown
        let begin = listVideoToShow.count
        switch withType {
        case 0:
            let end = getRange(begin: begin, sizeMax: listFilms.count)
            let list = listFilms[begin..<end]
            updateImgsVideo(listVideoToAppend: list)
        case 1:
            let end = getRange(begin: begin, sizeMax: listTvs.count)
            let list = listTvs[begin..<end]
            updateImgsVideo(listVideoToAppend: list)
        default:
            break
        }
    }
    private func getRange(begin: Int, sizeMax: Int) -> Int {
        if (begin + step) <  sizeMax {
            return begin + step
        } else {
            return sizeMax
        }
    }
    private func updateImgsVideo(listVideoToAppend: ArraySlice<VideoToShow>) {
        var listVideoToApp = listVideoToAppend
        if listVideoToApp.count != 0 {
            let elementVideo = listVideoToApp.first
            listVideoToApp.removeFirst()
            if var video = elementVideo {
                if video.urlImg != "" {
                    topModel.searchOneImage(url: video.urlImg) {
                        [weak self] result in
                        guard let self = self else { return }

                        switch result {
                        case .Success(let dataImg):
                            video.dataImg = dataImg
                            self.listVideoToShow.append(video)
                            self.updateImgsVideo(listVideoToAppend: listVideoToApp)
                        case .Failure(failure: let error):
                            let data = UIImage(named: "filmByDefault")?.pngData()
                            video.dataImg = data
                            self.listVideoToShow.append(video)
                            print("updateImgsVideo error\(video.title)  \(video.urlImg)", error.localizedDescription)
                            self.updateImgsVideo(listVideoToAppend: listVideoToApp)
                        }
                    }
                } else {
                    let data = UIImage(named: "filmByDefault")?.pngData()
                    video.dataImg = data
                    self.listVideoToShow.append(video)
                    self.updateImgsVideo(listVideoToAppend: listVideoToApp)
                }
            }
        } else {
            checkAndRemoveFooter()
            makeSegment(setup: true)
            updateListToShowIsRunning = false
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
                    self.listTvs = resp
                    DispatchQueue.main.async{
                        let stateSegm = self.segment.selectedSegmentIndex
                        self.updateListToShow(withType: stateSegm)
                    }
                    
                case .ZeroData:
                    self.showError(msg: "Data not available")
                    self.makeSegment(setup: true)
                case .Failure(let error):
                    self.showError(msg: error.localizedDescription)
                    self.makeSegment(setup: true)
                }
            }
        } else {
            self.updateListToShow(withType: self.segment.selectedSegmentIndex)
            DispatchQueue.main.async {
                self.tableFilms.reloadData() }
        }
    }
}

//MARK: - TableViewDataSource
extension TopViewController: UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {
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
        performSegue(withIdentifier: "segueTopToDetail", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueTopToDetail" {
            let detailVC = segue.destination as! DetailOneFilmViewController
            detailVC.videoToShow = listVideoToShow[rowSelected]
        }
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        if position > (tableFilms.contentSize.height + 50 - scrollView.frame.size.height) {
            
            // Fetch more data
            DispatchQueue.main.async {
                self.tableFilms.tableFooterView = self.createSpinnerFooter()
            }
            updateListToShow(withType: segment.selectedSegmentIndex)
        }
    }
    private func createSpinnerFooter() -> UIView {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 100))
        let spinner = UIActivityIndicatorView()
        spinner.center = footerView.center
        footerView.addSubview(spinner)
        spinner.startAnimating()
        return footerView
    }
    private func checkAndRemoveFooter(){
        DispatchQueue.main.async { [self] in
            if tableFilms.tableFooterView != nil {
                tableFilms.tableFooterView = nil
            } else {
            }
            self.tableFilms.reloadData()
        }
    }
    
}
