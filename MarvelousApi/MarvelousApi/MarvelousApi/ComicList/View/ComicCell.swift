//
//  ComicCell.swift
//  MarvelousApi
//
//  Created by Ricardo Ramirez on 10/09/21.
//

import UIKit
import SDWebImage

class ComicCell: UITableViewCell {
    
    static let cellIdentifier = String(describing: self)
    
    private lazy var comicImage: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private lazy var comicName: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        activateConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        contentView.addSubview(comicImage)
        contentView.addSubview(comicName)
    }
    
    func activateConstraints() {
        comicImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            comicImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            comicImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            comicImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            comicImage.widthAnchor.constraint(equalToConstant: 70),
            comicImage.heightAnchor.constraint(equalToConstant: 140)
        ])
        
        comicName.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            comicName.centerYAnchor.constraint(equalTo: comicImage.centerYAnchor),
            comicName.leadingAnchor.constraint(equalTo: comicImage.trailingAnchor, constant: 10),
            comicName.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            comicName.topAnchor.constraint(lessThanOrEqualTo: contentView.topAnchor, constant: 5),
            comicName.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -5)
        ])
    }
    
    func updateUI(withComic comic: Comic) {
        comicName.text = comic.title
        guard let thumbnail = comic.thumbnail?.path,
              let thumbnailExtension = comic.thumbnail?.thumbnailExtension,
              let thumbnailURL = URL(string: "\(thumbnail).\(thumbnailExtension)")
            else {
            return
        }
        comicImage.sd_setImage(with: thumbnailURL)
    }
    
}
