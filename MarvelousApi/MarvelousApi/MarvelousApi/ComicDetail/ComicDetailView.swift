//
//  ComicDetailView.swift
//  MarvelousApi
//
//  Created by Ricardo Ramirez on 11/09/21.
//

import UIKit

class ComicDetailView: UIViewController {
    
    var coordinator: MainCoordinator?
    
    var comic: Comic?
    
    private lazy var background: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    private var blurEffectView: UIVisualEffectView = {
        let be = UIBlurEffect(style: .systemUltraThinMaterial)
        return UIVisualEffectView(effect: be)
    }()
    
    let comicImage: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private var vibrancyEffectView: UIVisualEffectView = {
        let be = UIBlurEffect(style: .systemUltraThinMaterial)
        let ve = UIVibrancyEffect(blurEffect: be)
        return UIVisualEffectView(effect: ve)
    }()
    
    let mainContainer = UIView()
    
    let stack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.alignment = .fill
        stack.spacing = 5
        return stack
    }()
    
    let comicName: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 24, weight: .heavy)
        label.numberOfLines = 0
        return label
    }()
    
    let comicDescription: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    let comicAuthors: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    let comicIsbn: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    override func loadView() {
        super.loadView()
        setupUI()
        activateConstraints()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
    }
    
    func setupUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(background)
        background.addSubview(blurEffectView)
        blurEffectView.contentView.addSubview(comicImage)
        blurEffectView.contentView.addSubview(vibrancyEffectView)
        vibrancyEffectView.contentView.addSubview(mainContainer)
        mainContainer.addSubview(stack)
        stack.addArrangedSubview(comicName)
        stack.addArrangedSubview(comicAuthors)
        stack.addArrangedSubview(comicIsbn)
        stack.addArrangedSubview(comicDescription)
    }
    
    func activateConstraints() {
        background.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            background.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            background.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            background.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            background.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            blurEffectView.topAnchor.constraint(equalTo: background.topAnchor),
            blurEffectView.leadingAnchor.constraint(equalTo: background.leadingAnchor),
            blurEffectView.trailingAnchor.constraint(equalTo: background.trailingAnchor),
            blurEffectView.bottomAnchor.constraint(equalTo: background.bottomAnchor)
        ])
        
        comicImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            comicImage.topAnchor.constraint(equalTo: blurEffectView.contentView.topAnchor, constant: 10),
            comicImage.leadingAnchor.constraint(equalTo: blurEffectView.contentView.leadingAnchor),
            comicImage.trailingAnchor.constraint(equalTo: blurEffectView.contentView.trailingAnchor),
            comicImage.heightAnchor.constraint(equalTo: blurEffectView.heightAnchor, multiplier: 0.3)
        ])
        
        vibrancyEffectView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            vibrancyEffectView.topAnchor.constraint(equalTo: comicImage.bottomAnchor),
            vibrancyEffectView.leadingAnchor.constraint(equalTo: blurEffectView.contentView.leadingAnchor),
            vibrancyEffectView.trailingAnchor.constraint(equalTo: blurEffectView.contentView.trailingAnchor),
            vibrancyEffectView.bottomAnchor.constraint(equalTo: blurEffectView.contentView.bottomAnchor)
        ])
        
        mainContainer.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainContainer.topAnchor.constraint(equalTo: vibrancyEffectView.contentView.topAnchor, constant: 10),
            mainContainer.leadingAnchor.constraint(equalTo: vibrancyEffectView.contentView.leadingAnchor, constant: 10),
            mainContainer.trailingAnchor.constraint(equalTo: vibrancyEffectView.contentView.trailingAnchor, constant: -10),
            mainContainer.bottomAnchor.constraint(equalTo: vibrancyEffectView.contentView.bottomAnchor, constant: -10)
        ])
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: mainContainer.topAnchor),
            stack.leadingAnchor.constraint(equalTo: mainContainer.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: mainContainer.trailingAnchor),
        ])
    }
    
    func updateUI(withComic comic: Comic) {
        self.comic = comic
        comicName.text = comic.title
        comicAuthors.text = comic.creators?.items?.compactMap { $0.name }.joined(separator: ",")
        comicIsbn.text = comic.isbn
        comicDescription.text = comic.description
        guard let thumbnail = comic.thumbnail?.path,
              let thumbnailExtension = comic.thumbnail?.thumbnailExtension,
              let thumbnailURL = URL(string: "\(thumbnail).\(thumbnailExtension)")
            else {
            return
        }
        background.sd_setImage(with: thumbnailURL)
        comicImage.sd_setImage(with: thumbnailURL)
    }
    
}
