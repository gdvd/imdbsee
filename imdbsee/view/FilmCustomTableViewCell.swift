//
//  FilmCustomTableViewCell.swift
//  imdbsee
//
//  Created by Gilles David on 17/03/2022.
//

import UIKit

class FilmCustomTableViewCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var img: UIImageView!
    
    private var elementToShow: FilmToShow!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func configure(elementVideo: FilmToShow){
//        if let element = elementVideo {
            elementToShow = elementVideo
            print("elementToShow.title", elementVideo.title)
            title.text = elementVideo.title
            desc.text = elementVideo.description
            updateImg(imgData: elementVideo.dataImg)
//        }
    }
    
    fileprivate func updateImg(imgData: Data?) {
        if let dataImg = imgData {
            if let image = UIImage(data: dataImg){
                img.image = image
            }
        }
    }
    
}
