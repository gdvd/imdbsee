//
//  TopCustomTableViewCell.swift
//  imdbsee
//
//  Created by Gilles David on 10/03/2022.
//

import UIKit

class TopCustomTableViewCell: UITableViewCell {
    
    private let topModel = TopModel.shared
    private var elementToShow: FilmToShow!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBOutlet weak var titleFilm: UILabel!
    @IBOutlet weak var imgFilm: UIImageView!
    @IBOutlet weak var year: UILabel!
    @IBOutlet weak var rank: UILabel!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var crews: UILabel!
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    func configure(elementVideo: FilmToShow){
        elementToShow = elementVideo
        titleFilm.text = elementToShow.title 
        year.text = "\(elementToShow.year)"
        rank.text = "\(elementToShow.rank)"
        rating.text = "\(elementToShow.imDbRating)/\(elementToShow.imDbRatingCount)"
        crews.text = "\(elementToShow.crews)"
        
        if let dataImg = elementToShow.dataImg {
            if let img = UIImage(data: dataImg){
                imgFilm.image = img
            }
        }
        
    }

}
