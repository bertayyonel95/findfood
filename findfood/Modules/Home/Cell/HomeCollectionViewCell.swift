//
//  HomeCollectionViewCell.swift
//  findfood
//
//  Created by Bertay Yönel on 12.12.2022.
//

import UIKit
import Kingfisher

protocol HomeCollectionViewCellViewDelegate: AnyObject {
    func collectionView(_ cell: HomeCollectionViewCell, viewModel: HomeCollectionViewCellViewModel)
}

final class HomeCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "HomeCollectionViewCell"
    private var viewModel: HomeCollectionViewCellViewModel?
    weak var delegate: HomeCollectionViewCellViewDelegate?
    
    override func prepareForReuse() {
        name.text = nil
        rating.text = nil
        price.text = nil
        lastVisited.text = nil
        imageView.kf.cancelDownloadTask()
        imageView.image = nil
    }
    
    private let imageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let name: UILabel = {
        let name = UILabel()
        name.font = name.font.withSize(19)
        name.numberOfLines = 0
        name.lineBreakMode = .byWordWrapping
        name.textColor = .black
        return name
    }()
    
    private let rating: UILabel = {
        let rating = UILabel(frame: .zero)
        rating.textColor = .black
        return rating
    }()
    
    private let price: UILabel = {
        let price = UILabel(frame: .zero)
        price.font = price.font.withSize(16)
        price.textColor = .black
        return price
    }()
    
    private let lastVisited: UILabel = {
        let lastVisited = UILabel()
        lastVisited.numberOfLines = 1
        lastVisited.font = lastVisited.font.withSize(12)
        lastVisited.textColor = .gray
        lastVisited.isEnabled = false
        lastVisited.text = .empty
        return lastVisited
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with viewModel: HomeCollectionViewCellViewModel) {
        self.viewModel = viewModel
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(with: URL(string: viewModel.image_url))
        name.text = viewModel.name
        rating.text = viewModel.rating
        price.text = viewModel.price
        if !viewModel.lastVisited.isEmpty {
            lastVisited.text = "Last visited on: " + viewModel.lastVisited
            lastVisited.isEnabled = true
        }
    }
}

//MARK: - Helpers
private extension HomeCollectionViewCell {
    func setupView() {
        self.backgroundColor = .customBackgroundColor
        name.textColor = .customTextColor
        rating.textColor = .customTextColor
        price.textColor = .customTextColor
        self.clipsToBounds = true
        // Snapkit
        addSubview(imageView)
        addSubview(name)
        addSubview(rating)
        addSubview(price)
        addSubview(lastVisited)
        
        imageView.setConstraint(
            top: topAnchor,
            leading: leadingAnchor,
            topConstraint: 5,
            leadingConstraint: 5,
            width: 120,
            height: 120
        )
        
        name.setConstraint(
            top: topAnchor,
            leading: imageView.trailingAnchor,
            bottom: rating.topAnchor,
            trailing: trailingAnchor,
            leadingConstraint: 5,
            width: frame.size.width - imageView.frame.size.width - 150
        )
        
        rating.setConstraint(
            top: name.bottomAnchor,
            leading: imageView.trailingAnchor,
            topConstraint: 5,
            leadingConstraint: 5
        )
        
        price.setConstraint(
            top: rating.bottomAnchor,
            leading: imageView.trailingAnchor,
            topConstraint: 5,
            leadingConstraint: 5
        )
        
        lastVisited.setConstraint(
            bottom: bottomAnchor,
            trailing: trailingAnchor,
            bottomConstraint: 5,
            trailingConstraint: 5
        )
    }
}
