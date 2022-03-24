//
//  TopCustomTableViewCell.swift
//  imdbsee
//
//  Created by Gilles David on 10/03/2022.
//

import UIKit

class TopCustomTableViewCell: UITableViewCell {
    
    private let topModel = TopModel.shared
    private var elementToShow: VideoToShow!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBOutlet weak var titleFilm: UILabel!
    @IBOutlet weak var imgFilm: UIImageView!
    @IBOutlet weak var desc: UILabel!
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    fileprivate func updateImg() {
        if let dataImg = elementToShow.dataImg {
            if let img = UIImage(data: dataImg){
                imgFilm.image = img
            }
        }
    }
    
    func configure(elementVideo: VideoToShow){
        elementToShow = elementVideo
        DispatchQueue.main.async {
            self.titleFilm.text = self.elementToShow.title
            self.desc.text = "\(self.elementToShow.year) \n#\(self.elementToShow.rank) \nScore:\(self.elementToShow.imDbRating)\nVotes:\(self.elementToShow.imDbRatingCount)"
            self.updateImg()
        }}

}
