//
//  GameTableViewCell.swift
//  rawgGamesSearch
//
//  Created by Artem Kvashnin on 16.08.2022.
//

import UIKit

class GameTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "GameCell"
    
    private var placeholderImage = UIImage(systemName: "photo")!.withTintColor(.black)
    
    lazy var gameImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = placeholderImage
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .cyan
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .yellow
        label.numberOfLines = 0
        label.lineBreakMode = .byTruncatingTail
        label.font = .preferredFont(forTextStyle: .title1)
        label.textColor = .systemBrown
        label.textAlignment = .left
        return label
    }()
    
    let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.textColor = .systemGray
        label.textAlignment = .left
        return label
    }()
    
    let ratingLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title3)
        label.textColor = .black
        return label
    }()
    
    lazy var vStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .equalSpacing
        stack.spacing = 8
        return stack
    }()
    
    lazy var hStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [subtitleLabel, ratingLabel])
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fillProportionally
        stack.spacing = 8
        return stack
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        super .init(coder: coder)
        setupCell()
    }
    
    
    func setupCell() {
        gameImageView.translatesAutoresizingMaskIntoConstraints = false
        vStack.translatesAutoresizingMaskIntoConstraints = false
        
//        gameImageView.heightAnchor.constraint(equalTo: gameImageView.widthAnchor, multiplier: 9.0 / 16.0).isActive = true
        
        vStack.addArrangedSubview(gameImageView)
        vStack.addArrangedSubview(titleLabel)
        vStack.addArrangedSubview(hStack)
        self.contentView.addSubview(vStack)
        
        NSLayoutConstraint.activate([
            
            gameImageView.heightAnchor.constraint(equalTo: gameImageView.widthAnchor, multiplier: 9.0 / 16.0),
            vStack.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 8),
            vStack.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -8),
            vStack.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 8),
            vStack.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -8)
        ])
    }
    
    func configureCell(with game: Game, queryService: QueryService, indexPath: IndexPath) {
        
        titleLabel.text = game.name
        subtitleLabel.text = game.releaseDate?.formatted(Date.FormatStyle().year(.defaultDigits)) ?? "No release date"
        self.gameImageView.image = self.placeholderImage
        setupRatingLabel(with: game.rating)
        
        queryService.fetchImage(for: game, at: indexPath) { game, image in
            self.gameImageView.image = image ?? self.placeholderImage
            
        }
    }
    
    func setupRatingLabel( with rating: Double?) {
        var backgroundColor = UIColor()
        let _rating = rating ?? 0.0
        switch _rating {
            case 1...49:
                backgroundColor = .red
            case 50...74:
                backgroundColor = .yellow
            case 75...100:
                backgroundColor = .green
            default:
                backgroundColor = .gray
        }
        ratingLabel.backgroundColor = backgroundColor
        ratingLabel.text = "\(Int(_rating))"
    }
    
}

