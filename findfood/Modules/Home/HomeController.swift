//
//  ViewController.swift
//  findfood
//
//  Created by Bertay Yönel on 12.12.2022.
//

import UIKit
import SDWebImage
// MARK: - HomeController
final class HomeController: UIViewController {
    // MARK: Typealias
    typealias DataSource = UICollectionViewDiffableDataSource<Section, HomeCollectionViewCellViewModel>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, HomeCollectionViewCellViewModel>
    // MARK: Properties
    private var viewModel: HomeViewModelInput
    lazy var slideInTransitioningDelegate = SlideInPresentationManager()
    private lazy var dataSource = generateDatasource()
    private var snapshot = NSDiffableDataSourceSnapshot<Section, HomeCollectionViewCellViewModel>()
    private var page = 0
    private var isSlideMenuPresented = false
    private enum LastRequest {
        case byLocation
        case bySearch
        case byFavourite
    }
    private var likedLocations: [String] = []
    private var lastRequest: LastRequest = LastRequest.byLocation
    private lazy var slideInMenuPadding: CGFloat = self.view.frame.width * 0.30
    // MARK: Views
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.searchTextField.placeholder = "Enter a location"
        searchBar.showsBookmarkButton = true
        searchBar.setImage(UIImage(systemName: "location.fill"), for: .bookmark, state: .normal)
        searchBar.delegate = self
        return searchBar
    }()
    
    private lazy var byLocationButton: UIButton = {
        let byLocationButton = UIButton(frame: .zero)
        byLocationButton.setTitle("by location", for: .normal)
        byLocationButton.addTarget(self, action: #selector(byLocationClicked), for: .touchUpInside)
        return byLocationButton
    }()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .vertical
        collectionViewLayout.minimumLineSpacing = 20
        collectionViewLayout.itemSize = CGSize(width: view.frame.size.width, height: view.frame.size.width/3)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.register(HomeCollectionViewCell.self, forCellWithReuseIdentifier: HomeCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.keyboardDismissMode = .onDrag
        collectionView.backgroundColor = UIColor.init(red: 213.0/255.0, green: 207.0/255.0, blue: 207.0/255.0, alpha: 1)
        return collectionView
    }()
    // MARK: viewDidLoad
    override func viewDidLoad() {
        super.loadView()
        setupView()
    }
    // MARK: viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }
    // MARK: init
    init(viewModel: HomeViewModelInput) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: .main)
        self.viewModel.output = self
        ObserverManager.shared.favouriteStatusChanged.observe(on: self) { [self] _ in
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
        ObserverManager.shared.favouritesClicked.observe(on: self) { [self] _ in
            self.favouritesClicked()
        }
    }
    // MARK: deinit
    deinit {
        ObserverManager.shared.removeObservers(for: ObserverManager.shared.favouriteStatusChanged)
        ObserverManager.shared.removeObservers(for: ObserverManager.shared.favouritesClicked)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Helpers
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
        view.backgroundColor = .customBackgroundColor
        containerView.backgroundColor = .customBackgroundColor
        containerView.addSubview(searchBar)
        containerView.addSubview(collectionView)
        view.addSubview(containerView)
        
        containerView.setConstraint(
            top: view.safeAreaLayoutGuide.topAnchor,
            leading: view.leadingAnchor,
            bottom: view.safeAreaLayoutGuide.bottomAnchor,
            trailing: view.trailingAnchor,
            topConstraint: .zero,
            leadingConstraint: .zero,
            bottomConstraint: .zero,
            trailingConstraint: .zero
        )
        
        collectionView.setConstraint(
            top: searchBar.bottomAnchor,
            leading: containerView.leadingAnchor,
            bottom: containerView.safeAreaLayoutGuide.bottomAnchor,
            trailing: containerView.trailingAnchor,
            topConstraint: .zero,
            leadingConstraint: .zero,
            bottomConstraint: .zero,
            trailingConstraint: .zero
        )
        
        searchBar.setConstraint(
            top: containerView.topAnchor,
            leading: containerView.leadingAnchor,
            bottom: collectionView.topAnchor,
            trailing: containerView.trailingAnchor,
            topConstraint: .zero,
            leadingConstraint: .zero,
            trailingConstraint: .zero,
            height: 50.0
        )
        
        let sideMenuButton = UIBarButtonItem(image: UIImage(systemName: "line.3.horizontal" ), style: .plain, target: self, action: #selector(self.popUpMenu))
        self.navigationItem.leftBarButtonItem = sideMenuButton
    }
    
    @objc
    func searchClicked() {
        page = 0
        lastRequest = LastRequest.bySearch
        SDImageCache.shared.clearMemory()
        SDImageCache.shared.clearDisk()
        viewModel.getBusinessList(for: searchBar.text ?? " ", at: page)
        collectionView.setContentOffset(CGPoint.zero, animated: true)
    }
    
    @objc
    func popUpMenu() {
        var sideMenuVC: UIViewController
        if FirebaseManager.shared.userExists() {
            sideMenuVC = UserMenuViewController()
        } else {
            sideMenuVC = SideMenuController()
        }
        slideInTransitioningDelegate.direction = .left
        sideMenuVC.transitioningDelegate = slideInTransitioningDelegate
        sideMenuVC.modalPresentationStyle = .custom
        self.present(sideMenuVC, animated: true, completion: nil)
    }
    
    @objc
    func byLocationClicked() {
        print("by location clicked")
    }
    
    func favouritesClicked() {
        lastRequest = .byFavourite
        viewModel.getBusinessListWithFavourites(favouriteLocations: FirebaseManager.shared.returnLikedLocations())
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
        collectionView.setContentOffset(CGPoint.zero, animated: true)
    }
}

// MARK: - UICollectionViewDelegate
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
        if indexPath[0] + 5 == viewModel.getDataSize() {
            page += 1
            switch lastRequest {
            case .bySearch:
                viewModel.getBusinessList(for: searchBar.text ?? " ", at: page)
            case .byLocation:
                viewModel.getBusinessListWithLocation(at: page)
            case .byFavourite:
                return
            }
                
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension HomeController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        20
    }
}

// MARK: - HomeViewModelOutput
extension HomeController: HomeViewModelOutput {
    func home(_ viewModel: HomeViewModelInput, businessListDidLoad list: [LocationModel]) {
        // TODO: Implement
    }
    
    func home(_ viewModel: HomeViewModelInput, sectionDidLoad list: [Section]) {
        DispatchQueue.main.async {
            viewModel.updateSections(list)
            self.applySnapshot(animatingDifferences: false)
        }
    }
}

// MARK: - UISearchBarDelegate
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
        lastRequest = LastRequest.byLocation
        page = 0
        viewModel.getLocationData()
        collectionView.setContentOffset(CGPoint.zero, animated: true)
    }
}

// MARK: - HomeCollectionViewCellViewDelegate
extension HomeController: HomeCollectionViewCellViewDelegate {
    func collectionView(_ cell: HomeCollectionViewCell, likeButtonDidPressedWith viewModel: HomeCollectionViewCellViewModel) {
        if FirebaseManager.shared.userExists() {
            viewModel.isLiked ?
            self.viewModel.dislikeLocation(with: viewModel) :
            self.viewModel.likeLocation(with: viewModel)
        } else {
            ErrorMessageManager.shared.showErrorMessage(
                in: self,
                title: "Log In",
                errorMessage: "You need to be logged in to favourite",
                actions: [
                    UIAlertAction(title: "Log In", style: .default) { _ in
                        let loginViewModel = LoginViewModel()
                        let loginVC = LogInController(viewModel: loginViewModel)
                        self.slideInTransitioningDelegate.direction = .bottom
                        loginVC.transitioningDelegate = self.slideInTransitioningDelegate
                        loginVC.modalPresentationStyle = .custom
                        self.present(loginVC, animated: true, completion: nil)
                    }
                ])
        }
    }
}
