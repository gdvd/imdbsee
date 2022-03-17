//
//  FilmCustomTableViewCell.swift
//  imdbsee
//
//  Created by Gilles David on 17/03/2022.
//

import UIKit

class FilmCustomTableViewCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var desc: UILabel!
    
    @IBOutlet weak var img: UIImageView!
    
    private var elementToShow: FilmToShow!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    fileprivate func updateImg() {
        if let dataImg = elementToShow.dataImg {
            if let image = UIImage(data: dataImg){
                img.image = image
            }
        }
    }

    func configure(elementVideo: FilmToShow){
        elementToShow = elementVideo
        print("elementToShow.title", elementToShow.title)
        title.text = elementToShow.title
        type.text = elementToShow.resultType
        desc.text = elementToShow.resultType
        updateImg()
    }
    
}
