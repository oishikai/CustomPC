//
//  SearchPartsTableViewCell.swift
//  CustomPC
//
//  Created by Kai on 2022/04/15.
//

import UIKit

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
    @IBOutlet weak var partsPriceLavel: UILabel!
    
    static let cellIdentifier = String(describing: SearchPartsTableViewCell.self)
    
    func setup(title: String) {
        partsTitleLabel.text = title
    }
}
