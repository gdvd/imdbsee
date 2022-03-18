//
//  FilmDetailViewController.swift
//  imdbsee
//
//  Created by Gilles David on 18/03/2022.
//

import UIKit

class FilmDetailViewController: UIViewController {

    var filmToShow: FilmToShow!
    var respWiki: ResponseWiki?
    private let filmDetailModel = FilmDetailModel.shared
    
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var titleFilm: UILabel!
    @IBOutlet weak var desc: UILabel!
    
    @IBOutlet weak var segment: UISegmentedControl!

    @IBOutlet weak var viewWiki: UIView!
    @IBOutlet weak var viewMore: UIView!
    
    @IBOutlet weak var textFieldWiki: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showInfo()
        selectSegment(nb: 0)
        getInfoWiki()
    }
    
    private func showInfo() {
        titleFilm.text = filmToShow.title
        desc.text = filmToShow.description
        updateImg(imgData: filmToShow.dataImg)
    }
    
    private func getInfoWiki(){
        if let infoWiki = respWiki {
            showInfoWiki(infoWiki: infoWiki)
        } else {
            filmDetailModel.getInfoWiki(idTtImdb: filmToShow.id, language: Language.Fr){ 
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
                    textFieldWiki.text = plainText
                }
            }
        }
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
    
    @IBAction func segmentChange(_ sender: UISegmentedControl) {
        print("segment change")
        selectSegment(nb: sender.selectedSegmentIndex)
    }
    
    @IBAction func getTrailerImdb(_ sender: UIButton) {
        print("I want to see IMDB")
    }
    
    @IBAction func getTrailerYoutube(_ sender: UIButton) {
        print("I want to see Youtube")
    }
}
