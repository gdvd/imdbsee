//
//  DetailOneFilmViewController.swift
//  imdbsee
//
//  Created by Gilles David on 19/03/2022.
//

import UIKit

class DetailOneFilmViewController: UIViewController {

    var videoToShow: VideoToShow!
    var respWiki: ResponseWiki?
    var respYoutube: ResponseYoutube?
    private let filmDetailModel = FilmDetailModel.shared

    
    
    @IBOutlet weak var titleFilm: UILabel!
    @IBOutlet weak var desc: UILabel!
    
    @IBOutlet weak var img: UIImageView!
    
    @IBOutlet weak var segment: UISegmentedControl!
    
    @IBOutlet weak var viewWiki: UIView!
    @IBOutlet weak var textWiki: UITextView!

    @IBOutlet weak var viewWikiFull: UIView!
    @IBOutlet weak var textWikiFull: UITextView!
    
    @IBOutlet weak var viewMore: UIView!
    @IBOutlet weak var buttonInfoA: UIButton!
    @IBOutlet weak var buttonInfoB: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showInfo()
        getInfoWiki()
        selectSegment(nb: 0)
    }
    
    //MARK: -Init
    private func showInfo() {
        titleFilm.text = "\n" + videoToShow.title
        desc.text = videoToShow.crews
        updateImg(imgData: videoToShow.dataImg)
    }
    
    fileprivate func updateImg(imgData: Data?) {
        if let dataImg = imgData {
            if let image = UIImage(data: dataImg){
                img.image = image
            }
        }
    }
    private func selectSegment(nb: Int) {
        switch nb {
        case 0:
            viewWiki.isHidden = false
            viewWikiFull.isHidden = true
            viewMore.isHidden = true
        case 1:
            viewWiki.isHidden = true
            viewWikiFull.isHidden = false
            viewMore.isHidden = true
        case 2:
            viewWiki.isHidden = true
            viewWikiFull.isHidden = true
            viewMore.isHidden = false
        default:
            viewWiki.isHidden = false
            viewWikiFull.isHidden = true
            viewMore.isHidden = true
        }
        
    }
    
    //MARK: -Youtube
    private func showInfoYoutube(infoYoutube: ResponseYoutube){
        if let urlYt = infoYoutube.videoUrl, infoYoutube.errorMessage == "" {
            if let url = URL(string: urlYt) {
                DispatchQueue.main.async { 
                    UIApplication.shared.open(url)
                }
            }
        } else {
            if let err = infoYoutube.errorMessage {
                self.showError(msg: err)
            } else {
                self.showError(msg: "Data not available (YT)")
            }
            
        }
    }
    
    private func getUrlYoutube(){
        if let youtube = respYoutube {
            showInfoYoutube(infoYoutube: youtube)
        } else {
            filmDetailModel.getUrlYoutube(idTtImdb: videoToShow.id, language: Language.Fr){ 
                [weak self] 
                response in
                guard let self = self else { return }

                switch response {
                case .Success(response: let resp):
                    self.showInfoYoutube(infoYoutube: resp)
                case .Failure(failure: let err):
                    self.showError(msg: err.localizedDescription)
                }
            }
        }
    }
    //MARK: -Wiki
    private func getInfoWiki(){
        if let infoWiki = respWiki {
            showInfoWiki(infoWiki: infoWiki)
        } else {
            filmDetailModel.getInfoWiki(idTtImdb: videoToShow.id, language: Language.Fr){ 
                [weak self] response in
                guard let self = self else { return }

                switch response {
                case .Success(response: let resp):
                    self.respWiki = resp
                    self.showInfoWiki(infoWiki: resp)
                case .Failure(failure: let err):
                    self.showError(msg: err.localizedDescription)
                }
            }
        }
    }
    
    private func showInfoWiki(infoWiki: ResponseWiki) {
        DispatchQueue.main.async { [self] in
            if let plot = infoWiki.plotShort {
                if let plainText = plot.plainText {
                    textWiki.text = plainText
                }
            }
            if let plotfull = infoWiki.plotFull {
                if let plainTextFull = plotfull.plainText {
                    textWikiFull.text = plainTextFull
                }
            }
        }
    }

    //MARK: -Actions
    @IBAction func segmentAction(_ sender: UISegmentedControl) {
        selectSegment(nb: sender.selectedSegmentIndex)
    }
    
    @IBAction func infoAAction(_ sender: Any) {
        openUrlImdb()
    }
    @IBAction func infoBAction(_ sender: Any) {
        getUrlYoutube()
    }
    
    private func openUrlImdb(){
        if let url = URL(string: Constants.urlImdbWithTitle + videoToShow.id) {
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func closeAction(_ sender: UIButton) {
        if((self.presentingViewController) != nil){
            self.dismiss(animated: true, completion: nil)
           }
    }
    
    private func showError(msg: String){
        let alertVC = UIAlertController(title: "Impossible", message: msg, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }
}
