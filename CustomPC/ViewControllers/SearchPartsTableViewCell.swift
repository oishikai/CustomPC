//
//  SearchPartsTableViewCell.swift
//  CustomPC
//
//  Created by Kai on 2022/04/15.
//

import UIKit
import Nuke

class SearchPartsTableViewCell: UITableViewCell {
//    @IBOutlet private weak var repositoryImageView: UIImageView!
//    @IBOutlet private weak var repositoryTitle: UILabel!
//    @IBOutlet private weak var languageLabel: UILabel!
//    @IBOutlet weak var descriptionLabel: UILabel!
//
//    static let cellIdentifier = String(describing: RepositoriesTableViewCell.self)
//
//    func setup(repository: Repository) {
//        repositoryTitle.text = repository.fullName
//
//        if let url = repository.avatarImageUrl {
//            Nuke.loadImage(with: url, into: repositoryImageView)
//        } else {
//            repositoryImageView.image = nil
//        }
//
//        languageLabel.text = repository.language ?? ""
//        descriptionLabel.text = repository.description ?? ""
//        accessoryType = .disclosureIndicator
//    }
    
    @IBOutlet weak var partsImageView: UIImageView!
    @IBOutlet weak var partsMakerLabel: UILabel!
    @IBOutlet weak var partsTitleLabel: UILabel!
    @IBOutlet weak var partsPriceLabel: UILabel!
    
    static let cellIdentifier = String(describing: SearchPartsTableViewCell.self)
    
    func setup(parts: PcParts) {
        partsTitleLabel.text = parts.title
        partsMakerLabel.text = parts.maker
        partsPriceLabel.text = parts.price
        
        Nuke.loadImage(with: parts.image, into: partsImageView)
    }
    
    func setupCustomListCell(custom : Custom) {
        let parts = custom.parts?.allObjects as! [Parts]
        let initialPartsImage = parts[0].img!
        let msg = custom.message!
        
        partsTitleLabel.text = custom.title
        
        if (msg.contains("❗️")){
            partsMakerLabel.text = "❗️パーツの互換性に問題があります"
            partsMakerLabel.font = UIFont.systemFont(ofSize: 15.0)
        }else{
            partsMakerLabel.text = ""
        }
        
        partsPriceLabel.text = custom.price
        Nuke.loadImage(with: initialPartsImage, into: partsImageView)
    }
}
