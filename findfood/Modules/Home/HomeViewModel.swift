//
//  HomeViewModel.swift
//  findfood
//
//  Created by Bertay Yönel on 6.01.2023.
//

import Foundation

protocol HomeViewModelInput {
    var output: HomeViewModelOutput? { get set }
    
    func viewDidLoad(for location: String)
    func getBusinessList(for location: String)
    func getSections() -> [Section]
    func updateSections(_ sections: [Section])
}

protocol HomeViewModelOutput: AnyObject {
    func home(_ viewModel: HomeViewModelInput, businessListDidLoad list: [LocationData])
    func home(_ viewModel: HomeViewModelInput, sectionDidLoad list: [Section])
}

final class HomeViewModel: HomeViewModelInput {
    
    private var sections: [Section] = []
    private var businessList: [LocationModel] = []
    private var cells: [HomeCollectionViewCellViewModel] = []
    private let networkManager: NetworkManager
    
    weak var output: HomeViewModelOutput?
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
        networkManager.delegate = self
    }
    
    func viewDidLoad(for location: String) {
        getBusinessList(for: location)
    }
    
    func getBusinessList(for location: String) {
        networkManager.requestBusiness(city: location)
    }
    
    func getSections() -> [Section] {
        sections
    }
    
    func updateSections(_ sections: [Section]) {
        self.sections = sections
    }
}

private extension HomeViewModel {
    func generateCellData() {
        var sections: [Section] = []
        cells.removeAll()
        
        businessList.forEach { business in
            let cellViewModel = generateViewModel(with: business)
            cells.append(cellViewModel)
        }
        
        cells.forEach { item in
            sections.append(.init(title: "Test Title", location: item))
        }
        
        output?.home(self, sectionDidLoad: sections)
    }
    
    func generateViewModel(with business: LocationModel) -> HomeCollectionViewCellViewModel {
        HomeCollectionViewCellViewModel(
            uuid: .init(),
            id: business.locationID,
            name: business.locationName,
            image_url: business.locatinImageLink,
            rating: business.locationRating + "/5.0",
            price: business.locationPrice,
            phone: business.display_phone,
            address: business.display_address
        )
    }
}

extension HomeViewModel: NetworkManagerDelegate {
    func didGetLocation(_ networkManager: NetworkManager, _ location: [LocationModel]) {
        businessList = location
        self.generateCellData()
    }
}
