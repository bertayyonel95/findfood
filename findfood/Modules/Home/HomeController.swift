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
    private lazy var slideInTransitioningDelegate = SlideInPresentationManager()
    private lazy var dataSource = generateDatasource()
    private var snapshot = NSDiffableDataSourceSnapshot<Section, HomeCollectionViewCellViewModel>()
    private var loginRouter: LoginRouting = LoginRouter()
    private var page: Int
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
        searchBar.searchTextField.placeholder = Constant.ViewText.searchBarPlaceHolder
        searchBar.showsBookmarkButton = true
        searchBar.backgroundImage = UIImage()
        searchBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        searchBar.setImage(UIImage(systemName: "location.fill"), for: .bookmark, state: .normal)
        searchBar.delegate = self
        return searchBar
    }()
    
    private lazy var byLocationButton: UIButton = {
        let byLocationButton = UIButton(frame: .zero)
        byLocationButton.setTitle(Constant.ViewText.byLocationTitle, for: .normal)
        byLocationButton.addTarget(self, action: #selector(byLocationPressed), for: .touchUpInside)
        return byLocationButton
    }()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .customBackgroundColor
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
        collectionView.backgroundColor = .customBackgroundColor
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
        self.page = 0
        super.init(nibName: nil, bundle: .main)
        self.viewModel.output = self
        setupObservables()
    }
    
    // MARK: deinit
    deinit {
        ObserverManager.shared.removeObservers(for: ObserverManager.shared.favouriteStatusChanged)
        ObserverManager.shared.removeObservers(for: ObserverManager.shared.favouritesPressed)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Helpers
private extension HomeController {
    func setupObservables() {
        ObserverManager.shared.favouriteStatusChanged.observe(on: self) { [self] _ in
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
        ObserverManager.shared.favouritesPressed.observe(on: self) { [self] _ in
            self.favouritesPressed()
        }
    }
    
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
        self.title = "Home"
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
            height: 44.0
        )
        
        let sideMenuButton = UIBarButtonItem(image: UIImage(systemName: "line.3.horizontal" ), style: .plain, target: self, action: #selector(self.popUpMenu))
        self.navigationItem.leftBarButtonItem = sideMenuButton
    }
    
    @objc
    func searchPressed() {
        page = .zero
        lastRequest = LastRequest.bySearch
        SDImageCache.shared.clearMemory()
        SDImageCache.shared.clearDisk()
        viewModel.getBusinessList(for: searchBar.text ?? .empty, at: page)
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
    func byLocationPressed() {
        print("by location clicked")
    }
    
    func favouritesPressed() {
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
        
        if viewModel.isLoadingData { return }

        if indexPath[0] + 6 == viewModel.getDataSize() {
            page += 1
            switch lastRequest {
            case .bySearch:
                viewModel.getBusinessList(for: searchBar.text ?? .empty, at: page)
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
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 10, left: .zero, bottom: 10, right: .zero) // Adjust the top and bottom values to specify the desired spacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        10 // Adjust the value to specify the desired spacing between items within a row
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let totalWidth = collectionView.bounds.width
        let totalHeight = collectionView.bounds.height
        let itemHeight = totalHeight / 5
        let itemWidth = totalWidth * 0.9
        return CGSize(width: itemWidth, height: itemHeight)
    }
}

// MARK: - HomeViewModelOutput
extension HomeController: HomeViewModelOutput {
    func home(_ viewModel: HomeViewModelInput, businessListDidLoad list: [Location]) {
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
    func searchBarSearchButtonPressed(_ searchBar: UISearchBar) {
        searchPressed()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count > 3 {
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
                self.searchPressed()
            }
        }
    }
    
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        lastRequest = LastRequest.byLocation
        page = .zero
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
            AlertHandler.shared.show(
                errorMessage: Constant.MessageString.logInNeeded,
                in: self,
                with: Constant.ViewText.logInTitle,
                actionType: [
                    .login,
                    .cancel
                ])
            AlertHandler.shared.confirmButtonHandler = {
//                let loginViewModel = LoginViewModel()
//                let loginVC = LogInController(viewModel: loginViewModel)
//                self.slideInTransitioningDelegate.direction = .bottom
//                loginVC.transitioningDelegate = self.slideInTransitioningDelegate
//                loginVC.modalPresentationStyle = .custom
//                self.present(loginVC, animated: true, completion: nil)
                self.loginRouter.navigateToLogin(self)
            }
        }
    }
}
