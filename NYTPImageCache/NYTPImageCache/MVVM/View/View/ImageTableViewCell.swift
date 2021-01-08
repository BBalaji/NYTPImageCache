//
//  ImageTableViewCell.swift
//  NYTPImageCache
//
//  Created by Besta, Balaji (623-Extern) on 08/01/21.
//

import Foundation
import UIKit
class ImageTableViewCell: UITableViewCell {
    static let identifier = "ImageTableViewCell"
    var rowViewModel : ImageRowViewModel? {
        didSet {
            guard let rowItem = rowViewModel else { return }
                
            if let title = rowItem.filename {
                titleLabel.text = title
            }
            if let description = rowItem.author {
                if description.isEmpty{
                    descriptionLabel.text = " "
                }else{
                    descriptionLabel.text = description
                }
            }
            if let imageString = rowItem.id {
                let imageStringURL = imagePath + String(imageString)
                self.update(imageUrl: imageStringURL)
            }
            }
        }

// MARK: - Image
let photoView:UIImageView = {
    let img = UIImageView()
    img.contentMode = .scaleAspectFill // image will never be strecthed vertially or horizontally
    img.translatesAutoresizingMaskIntoConstraints = false // enable autolayout
    img.layer.cornerRadius = 25
    img.clipsToBounds = true
    return img
}()

// MARK: - Title
let titleLabel:UILabel = {
    let label = UILabel()
    label.font = UIFont.boldSystemFont(ofSize: 20)
    label.textColor = .black
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
}()
// MARK: - Description
let descriptionLabel:UILabel = {
    let label = UILabel()
    label.font = UIFont.boldSystemFont(ofSize: 14)
    label.textColor =  .white
    label.numberOfLines = 0
    label.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
    label.layer.cornerRadius = 5
    label.clipsToBounds = true
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
}()

// MARKL: - image lazy loading
func update(imageUrl: String) {
    photoView.setImage(url: imageUrl, placeholderImage: UIImage(named: "apple"))
}
override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    self.contentView.addSubview(photoView)
    self.contentView.addSubview(titleLabel)
    self.contentView.addSubview(descriptionLabel)
    
    let views = [
        "image" : photoView,
        "title"  : titleLabel,
        "description" : descriptionLabel,
        ]
    
    var allConstraints: [NSLayoutConstraint] = []
    allConstraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-[image(50)]", options: [], metrics: nil, views: views)
    allConstraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-[title]-[description]-|", options: [], metrics: nil, views: views)
    allConstraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-[image(50)]-[title]-|", options: [], metrics: nil, views: views)
    allConstraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-[image]-[description]-|", options: [], metrics: nil, views: views)
    
     NSLayoutConstraint.activate(allConstraints)
    
}
required init?(coder aDecoder: NSCoder) {
    
    super.init(coder: aDecoder)
}

}
