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
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configure(elementVideo: ElementVideo){
        if let title = elementVideo.title {
            titleFilm.text = title + "\n" + (elementVideo.description ?? "")
        }
        if let img = elementVideo.img {
            imgFilm.image = UIImage(data: img)
        }
    }
    
}
