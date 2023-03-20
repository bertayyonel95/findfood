//
//  DetailViewController.swift
//  findfood
//
//  Created by Bertay Yönel on 5.01.2023.
//

import UIKit
import Kingfisher

final class DetailController: UIViewController {
    
    private let cellViewModel: HomeCollectionViewCellViewModel
    
    private var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.textColor = .customTextColor
        return nameLabel
    }()
    
    private var phoneLabel: UILabel = {
        let phoneLabel = UILabel()
        phoneLabel.textColor = .customTextColor
        return phoneLabel
    }()
    
    private var addressLabel: UILabel = {
        let addressLabel = UILabel()
        addressLabel.numberOfLines = 0
        addressLabel.lineBreakMode = .byWordWrapping
        addressLabel.textColor = .customTextColor
        return addressLabel
    }()
    
    private var addressTitle: UILabel = {
        let addressTitle = UILabel()
        addressTitle.text = "Address: "
        addressTitle.textColor = .customTextColor
        return addressTitle
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    init(cellViewModel: HomeCollectionViewCellViewModel) {
        self.cellViewModel = cellViewModel
        super.init(nibName: nil, bundle: .main)
        
        navigationItem.title = cellViewModel.name
        configure(with: cellViewModel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension DetailController {
    func configure(with viewModel: HomeCollectionViewCellViewModel) {
        nameLabel.text = "Name: \(viewModel.name)"
        phoneLabel.text = "Phone: \(viewModel.phone)"
        addressLabel.text = "\(viewModel.address.joined(separator: ", "))"
        imageView.kf.setImage(with: URL(string: viewModel.image_url))
        //imageView.downloaded(from: viewModel.image_url)
        
    }
    
    func setupViews() {
        view.addSubview(scrollView)
        scrollView.contentSize = CGSize(width: view.frame.size.width, height: view.frame.size.height*2)
        scrollView.backgroundColor = .customBackgroundColor
        scrollView.addSubview(imageView)
        scrollView.addSubview(nameLabel)
        scrollView.addSubview(phoneLabel)
        scrollView.addSubview(addressTitle)
        scrollView.addSubview(addressLabel)
        
        scrollView.setConstraint(
            top: view.safeAreaLayoutGuide.topAnchor,
            leading: view.leadingAnchor,
            bottom: view.safeAreaLayoutGuide.bottomAnchor,
            trailing: view.trailingAnchor,
            width: view.frame.size.width,
            height: view.frame.size.height*2
        )
        
        imageView.setConstraint(
            top: scrollView.topAnchor,
            leading: scrollView.leadingAnchor,
            trailing: scrollView.trailingAnchor,
            width: view.frame.size.width,
            height: view.frame.size.height/2
        )
        
        nameLabel.setConstraint(
            top: imageView.bottomAnchor,
            leading: scrollView.leadingAnchor,
            topConstraint: 10,
            leadingConstraint: 5
        )
        
        phoneLabel.setConstraint(
            top: nameLabel.bottomAnchor,
            leading: scrollView.leadingAnchor,
            topConstraint: 10,
            leadingConstraint: 5
        )
        
        addressTitle.setConstraint(
            top: phoneLabel.bottomAnchor,
            leading: scrollView.leadingAnchor,
            topConstraint: 10,
            leadingConstraint: 5
        )
        
        addressLabel.setConstraint(
            top: phoneLabel.bottomAnchor,
            leading: addressTitle.trailingAnchor,
            topConstraint: 10,
            leadingConstraint: 0,
            width: view.frame.size.width - 100
        )
    }
}
