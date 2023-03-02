//
//  ViewController.swift
//  findfood
//
//  Created by Bertay Yönel on 12.12.2022.
//

import UIKit
import Kingfisher

final class HomeController: UIViewController, HomeCollectionViewCellViewDelegate {
    func collectionView(_ cell: HomeCollectionViewCell, viewModel: HomeCollectionViewCellViewModel) {
        //TODO: Implement
    }
    
    //MARK: Typealias
    typealias DataSource = UICollectionViewDiffableDataSource<Section, HomeCollectionViewCellViewModel>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, HomeCollectionViewCellViewModel>
    
    //MARK: Properties
    private var viewModel: HomeViewModelInput
    private lazy var dataSource = generateDatasource()
    private var snapshot = NSDiffableDataSourceSnapshot<Section, HomeCollectionViewCellViewModel>()
    private var page = 0
    private let cache = ImageCache.default
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.searchTextField.placeholder = "Enter a location"
        searchBar.showsBookmarkButton = true
        searchBar.setImage(UIImage(systemName: "location.fill"), for: .bookmark, state: .normal)
        searchBar.delegate = self
        return searchBar
    }()

    private lazy var collectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .vertical
        collectionViewLayout.minimumLineSpacing = 20
        collectionViewLayout.itemSize = CGSize(width: view.frame.size.width, height: view.frame.size.width/3)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.register(HomeCollectionViewCell.self, forCellWithReuseIdentifier: HomeCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.init(red: 213.0/255.0, green: 207.0/255.0, blue: 207.0/255.0, alpha: 1)
        return collectionView
    }()

    override func viewDidLoad() {
        super.loadView()
        setupView()
        cache.memoryStorage.config.totalCostLimit = 500 * 1024 * 1024
        //viewModel.getBusinessList(for: "Istanbul", mode: true)
       // applySnapshot(animatingDifferences: false)
    }
    
    init(viewModel: HomeViewModelInput) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: .main)
        self.viewModel.output = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Helpers
private extension HomeController {
    func applySnapshot(animatingDifferences: Bool = true) {
        var snapshot = Snapshot()
        snapshot.appendSections(viewModel.getSections())
        viewModel.getSections().forEach { section in
            snapshot.appendItems([section.location], toSection: section)
        }
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
    
    func generateDatasource() -> DataSource {
        let dataSource = DataSource(
            collectionView: collectionView,
            cellProvider: { (collectionView, indexPath, cellViewModel) -> UICollectionViewCell? in
                
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCollectionViewCell.identifier, for: indexPath) as? HomeCollectionViewCell else {
                    return .init(frame: .zero)
                }
                
                cell.delegate = self
                cell.configure(with: cellViewModel)
                
                return cell
            })
        return dataSource
    }
    
    func setupView() {
        view.backgroundColor = .white
        view.addSubview(searchBar)
        view.addSubview(collectionView)
        
        searchBar.setConstraint(
            top: view.safeAreaLayoutGuide.topAnchor,
            leading: view.leadingAnchor,
            bottom: collectionView.topAnchor,
            trailing: view.trailingAnchor,
            topConstraint: .zero,
            leadingConstraint: 5.0,
            trailingConstraint: 5.0,
            height: 50.0
        )
        
        collectionView.setConstraint(
            top: searchBar.bottomAnchor,
            leading: view.leadingAnchor,
            bottom: view.safeAreaLayoutGuide.bottomAnchor,
            trailing: view.trailingAnchor,
            topConstraint: 20.0,
            leadingConstraint: .zero,
            bottomConstraint: .zero,
            trailingConstraint: .zero
        )
    }
    
    @objc
    func searchClicked() {
        page = 0
        cache.clearMemoryCache()
        viewModel.getBusinessList(for: searchBar.text ?? " ", at: page)
    }
}

//MARK: - UICollectionViewDelegate
extension HomeController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let section = viewModel.getSections()[indexPath.section]
        let cellViewModel = section.location
        
        DispatchQueue.main.async {
            self.viewModel.updateLastVisited(with: cellViewModel)
            self.collectionView.reloadData()
        }
        let detailVC = DetailController(cellViewModel: cellViewModel)
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if searchBar.text != "" {
            if indexPath[0] + 5 == viewModel.getDataSize() {
                page += 1
                viewModel.getBusinessList(for: searchBar.text ?? " ", at: page)
            }
        }
    }
}

extension HomeController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        20
    }
}

extension HomeController: HomeViewModelOutput {
    func home(_ viewModel: HomeViewModelInput, businessListDidLoad list: [LocationModel]) {
        //TODO: Implement
    }
    
    func home(_ viewModel: HomeViewModelInput, sectionDidLoad list: [Section]) {
        DispatchQueue.main.async {
            viewModel.updateSections(list)
            self.applySnapshot(animatingDifferences: false)
        }
    }
}

//MARK: - UISearchBarDelegate
extension HomeController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchClicked()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count > 3 {
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
                self.searchClicked()
            }
        }
    }
    
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        viewModel.getLocationData()
    }
}
