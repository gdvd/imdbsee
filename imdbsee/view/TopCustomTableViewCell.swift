//
//  TopCustomTableViewCell.swift
//  imdbsee
//
//  Created by Gilles David on 10/03/2022.
//

import UIKit

class TopCustomTableViewCell: UITableViewCell {

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

        // Configure the view for the selected state
    }

    func configure(elementVideo: FilmToShow){
        titleFilm.text = elementVideo.title 
        year.text = "\(elementVideo.year)"
        rank.text = "\(elementVideo.rank)"
        rating.text = "\(elementVideo.imDbRating)/\(elementVideo.imDbRatingCount)"
        crews.text = "\(elementVideo.crews)"
    }
    
}
