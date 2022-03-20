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
    
    
    @IBOutlet weak var viewMore: UIView!
    @IBOutlet weak var buttonInfoA: UIButton!
    @IBOutlet weak var buttonInfoB: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("videoToShow:", videoToShow as VideoToShow)
        showInfo()
        selectSegment(nb: 0)
        getInfoWiki()
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
        if nb == 0 {
            viewWiki.isHidden = false
            viewMore.isHidden = true
        } else {
            viewWiki.isHidden = true
            viewMore.isHidden = false
        }
    }
    
    //MARK: -Youtube
    private func showInfoYoutube(infoYoutube: ResponseYoutube){
        if let urlYt = infoYoutube.videoId, infoYoutube.errorMessage == "" {
            if let url = URL(string: urlYt) {
                UIApplication.shared.open(url)
            }
        } else {
            if let err = infoYoutube.errorMessage {
                print("*******ErrorReturnErrYT", err)
            } else {
                print("*******ErrorReturnErrYT without msg")
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
                    print("======ResponseYoutube>",resp)
                    self.showInfoYoutube(infoYoutube: resp)
                case .Failure(failure: let err):
                    print("*****error", err.localizedDescription)
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
                [weak self] 
                response in
                guard let self = self else { return }

                switch response {
                case .Success(response: let resp):
                    print(resp)
                    self.respWiki = resp
                    self.showInfoWiki(infoWiki: resp)
                case .Failure(failure: let err):
                    print("*****error", err.localizedDescription)
                }
            }
        }
    }
    
    private func showInfoWiki(infoWiki: ResponseWiki) {
        if let plot = infoWiki.plotShort {
            if let plainText = plot.plainText {
                DispatchQueue.main.async { [self] in
                    print(plainText)
                    textWiki.text = plainText
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
        print("I want to see Youtube")
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
}
