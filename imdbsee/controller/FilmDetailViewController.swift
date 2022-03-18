//
//  FilmDetailViewController.swift
//  imdbsee
//
//  Created by Gilles David on 18/03/2022.
//

import UIKit

class FilmDetailViewController: UIViewController {

    var filmToShow: FilmToShow!
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
    }
    
    private func showInfo() {
        titleFilm.text = filmToShow.title
        desc.text = filmToShow.description
        updateImg(imgData: filmToShow.dataImg)
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
