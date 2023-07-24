//
//  DetailViewController.swift
//  findfood
//
//  Created by Bertay Yönel on 5.01.2023.
//

import UIKit
import SDWebImage
// MARK: - DetailController
final class DetailController: UIViewController {
    // MARK: Properties
    private let cellViewModel: HomeCollectionViewCellViewModel
    // MARK: Views
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
        nameLabel.textColor = .customLabelColor
        return nameLabel
    }()
    
    private var phoneLabel: UILabel = {
        let phoneLabel = UILabel()
        phoneLabel.textColor = .customLabelColor
        return phoneLabel
    }()
    
    private var addressLabel: UILabel = {
        let addressLabel = UILabel()
        addressLabel.numberOfLines = 0
        addressLabel.lineBreakMode = .byWordWrapping
        addressLabel.textColor = .customLabelColor
        return addressLabel
    }()
    
    private var addressTitle: UILabel = {
        let addressTitle = UILabel()
        addressTitle.text = Constant.ViewText.addressLabel
        addressTitle.textColor = .customLabelColor
        return addressTitle
    }()
    // MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    // MARK: init
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
    // MARK: Helpers
    func configure(with viewModel: HomeCollectionViewCellViewModel) {
        nameLabel.text = Constant.ViewText.nameLabel + viewModel.name
        phoneLabel.text = Constant.ViewText.phoneLabel + viewModel.phone
        addressLabel.text = "\(viewModel.address.joined(separator: ", "))"
        imageView.sd_setImage(with: URL(string: viewModel.image_url))
        
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
