//
//  HomeCollectionViewCell.swift
//  findfood
//
//  Created by Bertay Yönel on 12.12.2022.
//

import UIKit
import SDWebImage
// MARK: - HomeCollectionViewCellViewDelegate
protocol HomeCollectionViewCellViewDelegate: AnyObject {
    func collectionView(_ cell: HomeCollectionViewCell, likeButtonDidPressedWith viewModel: HomeCollectionViewCellViewModel)
}
// MARK: - HomeCollectionViewCell
final class HomeCollectionViewCell: UICollectionViewCell {
    // MARK: Properties
    static let identifier = "HomeCollectionViewCell"
    private var viewModel: HomeCollectionViewCellViewModel?
    private let transformer = SDImageResizingTransformer(size: CGSize(width: 120, height: 120), scaleMode: .aspectFill)
    weak var delegate: HomeCollectionViewCellViewDelegate?
    // MARK: Views
    private lazy var likeButton: UIButton = {
        let button = UIButton()
        button.tintColor = .red
        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.addTarget(self, action: #selector(likeButtonPressed), for: .touchUpInside)
        return button
    }()
    
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
        name.textColor = UIColor(named: "CustomLabel")
        return name
    }()
    
    private let rating: UILabel = {
        let rating = UILabel(frame: .zero)
        rating.textColor = UIColor(named: "CustomLabel")
        return rating
    }()
    
    private let price: UILabel = {
        let price = UILabel(frame: .zero)
        price.font = price.font.withSize(16)
        price.textColor = UIColor(named: "CustomLabel")
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
    
    // MARK: init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: Helpers
    override func prepareForReuse() {
        name.text = nil
        rating.text = nil
        price.text = nil
        lastVisited.text = nil
        imageView.sd_cancelCurrentImageLoad()
        imageView.image = nil
        likeButton.setImage(UIImage(systemName:"heart"), for: .normal)
    }
    
    func configure(with viewModel: HomeCollectionViewCellViewModel) {
        self.viewModel = viewModel
        setupLikeButton(with: viewModel.isLiked)
        imageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        imageView.sd_setImage(with: URL(string: viewModel.image_url), placeholderImage: nil, context: [.imageTransformer: transformer])
        name.text = viewModel.name
        rating.text = viewModel.rating
        price.text = viewModel.price
        
        if !viewModel.lastVisited.isEmpty {
            lastVisited.text = Constant.MessageString.lastVisitedOn + viewModel.lastVisited
            lastVisited.isEnabled = true
        }
        
    }
}

//MARK: - Helpers
private extension HomeCollectionViewCell {
    @objc
    func likeButtonPressed() {
        guard var viewModel = viewModel else { return }
        if FirebaseManager.shared.userExists() {
            setupLikeButton(with: !viewModel.isLiked)
        }
        delegate?.collectionView(self, likeButtonDidPressedWith: viewModel)
    }
    
    func setupLikeButton(with isFavorited: Bool) {
        likeButton.setImage(UIImage(systemName: isFavorited ? "heart.fill" : "heart"), for: .normal)
    }
    
    func setupView() {
        self.backgroundColor = UIColor(named: "CustomSecondaryBackground")
        self.layer.cornerRadius = 8.0
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.3
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowRadius = 4
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.contentView.layer.cornerRadius).cgPath

        
        addSubview(imageView)
        addSubview(name)
        addSubview(likeButton)
        addSubview(rating)
        addSubview(price)
        addSubview(lastVisited)
        
        imageView.setConstraint(
            top: topAnchor,
            leading: leadingAnchor,
            topConstraint: .zero,
            leadingConstraint: .zero,
            width: 120,
            height: self.bounds.height
        )
        
        name.setConstraint(
            top: topAnchor,
            leading: imageView.trailingAnchor,
            trailing: trailingAnchor,
            topConstraint: 15,
            leadingConstraint: 5,
            width: frame.size.width - imageView.frame.size.width - 150
        )
        
        likeButton.setConstraint(
            top: topAnchor,
            trailing: trailingAnchor,
            trailingConstraint: 15,
            centerY: centerYAnchor,
            width: 50,
            height: 50
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
