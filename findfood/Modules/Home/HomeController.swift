//
//  ViewController.swift
//  findfood
//
//  Created by Bertay Yönel on 12.12.2022.
//

import UIKit

final class HomeController: UIViewController, HomeCollectionViewCellViewDelegate {
    func collectionView(_ cell: HomeCollectionViewCell, viewModel: HomeCollectionViewCellViewModel) {
        //TODO: Implement
    }
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, HomeCollectionViewCellViewModel>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, HomeCollectionViewCellViewModel>
    
    private var sections: [Section] = []
    private var viewModel: HomeViewModelInput
    private lazy var dataSource = generateDatasource()
    private var snapshot = NSDiffableDataSourceSnapshot<Section, HomeCollectionViewCellViewModel>()
    
    private lazy var textField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.layoutMargins.right = 20.0
        textField.backgroundColor = UIColor.init(red: 213.0/255.0, green: 207.0/255.0, blue: 207.0/255.0, alpha: 1)
        textField.layer.masksToBounds = false
        textField.placeholder = "Search"
        textField.textAlignment = .right
        textField.setRightPaddingPoints(5.0)
        textField.borderStyle = .roundedRect
        textField.textContentType = .location
        textField.autocapitalizationType = .words
        return textField
    }()
    
    private lazy var button: UIButton = {
        let button = UIButton(frame: .zero)
        button.setBackgroundImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        button.addTarget(self, action: Selector(("searchClicked")), for: .touchUpInside)
        button.tintColor = .black
        return button
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .vertical
        collectionViewLayout.itemSize = CGSize(width: view.frame.size.width, height: view.frame.size.width/3)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.register(HomeCollectionViewCell.self, forCellWithReuseIdentifier: HomeCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.init(red: 213.0/255.0, green: 207.0/255.0, blue: 207.0/255.0, alpha: 1)
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        viewModel.viewDidLoad(for: "Istanbul")
        applySnapshot(animatingDifferences: false)
    }
    
    init(viewModel: HomeViewModelInput){
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: .main)
        
        self.viewModel.output = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

private extension HomeController {
    
    func applySnapshot(animatingDifferences: Bool = true) {
        var snapshot = Snapshot()
        snapshot.appendSections(sections)
        sections.forEach{ section in
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
        view.addSubview(textField)
        view.addSubview(button)
        view.addSubview(collectionView)
        
        textField.setConstraint(
            top: view.safeAreaLayoutGuide.topAnchor,
            leading: view.leadingAnchor,
            bottom: collectionView.topAnchor,
            trailing: button.leadingAnchor,
            topConstraint: .zero,
            leadingConstraint: 5.0,
            trailingConstraint: .zero,
            height: 50.0
        )
        
        button.setConstraint(
            top: view.safeAreaLayoutGuide.topAnchor,
            leading: textField.trailingAnchor,
            bottom: collectionView.topAnchor,
            trailing: view.trailingAnchor,
            topConstraint: 8.0,
            trailingConstraint: 5.0,
            width: 30.0,
            height: 30.0
        )
        
        collectionView.setConstraint(
            top: textField.bottomAnchor,
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
    func searchClicked(){
        viewModel.viewDidLoad(for: textField.text ?? " ")
    }
}

extension HomeController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let section = sections[indexPath.section]
        let cellViewModel = section.location
        
        let detailVC = DetailController(cellViewModel: cellViewModel)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

extension HomeController: HomeViewModelOutput {
    func home(_ viewModel: HomeViewModelInput, businessListDidLoad list: [LocationData]) {
        //TODO: Implement
    }
    
    func home(_ viewModel: HomeViewModelInput, sectionDidLoad list: [Section]) {
        DispatchQueue.main.async {
            self.sections = list
            self.applySnapshot(animatingDifferences: false)
        }
    }
}
