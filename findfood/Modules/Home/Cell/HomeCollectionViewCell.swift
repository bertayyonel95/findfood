//
//  HomeCollectionViewCell.swift
//  findfood
//
//  Created by Bertay Yönel on 12.12.2022.
//

import UIKit

protocol HomeCollectionViewCellViewDelegate: AnyObject {
    func collectionView(_ cell: HomeCollectionViewCell, viewModel: HomeCollectionViewCellViewModel)
}

final class HomeCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "HomeCollectionViewCell"
    
    private var viewModel: HomeCollectionViewCellViewModel?
    
    weak var delegate: HomeCollectionViewCellViewDelegate?
    
    private let imageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    private let name: UILabel = {
        let name = UILabel()
        name.font = name.font.withSize(19)
        name.numberOfLines = 0
        name.lineBreakMode = .byWordWrapping
        return name
    }()
    
    private let rating: UILabel = {
        let rating = UILabel(frame: .zero)
        return rating
    }()
    
    private let price: UILabel = {
        let price = UILabel(frame: .zero)
        price.font = price.font.withSize(16)
        return price
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
        imageView.downloaded(from: viewModel.image_url)
        name.text = viewModel.name
        rating.text = viewModel.rating
        price.text = viewModel.price
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        /*
        imageView.frame = CGRect(x: 5,
                            y: 5,
                            width: 120,
                            height: 120)
        name.frame = CGRect(x: 130,
                        y: 10,
                        width: contentView.frame.width-120,
                        height: 25)
        
        rating.frame = CGRect(x: 130,
                          y: 40,
                          width: contentView.frame.width-120,
                          height: 25)
        price.frame = CGRect(x: 130,
                         y: 60,
                         width: contentView.frame.width-120,
                         height: 35)
         */
    }
}

//MARK: - Helpers
private extension HomeCollectionViewCell {

    func setupView() {
        
        self.backgroundColor = .white
        addSubview(imageView)
        addSubview(name)
        addSubview(rating)
        addSubview(price)

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
    }
}
