//
//  HomeViewModel.swift
//  findfood
//
//  Created by Bertay Yönel on 6.01.2023.
//

import Foundation

protocol HomeViewModelInput {
    var output: HomeViewModelOutput? { get set }
    
    func viewDidLoad()
    func getBusinessList(for location: String)
    func getBusinessList()
    func getSections() -> [Section]
    func updateSections(_ sections: [Section])
    func getLocationData()    
}

protocol HomeViewModelOutput: AnyObject {
    func home(_ viewModel: HomeViewModelInput, businessListDidLoad list: [LocationData])
    func home(_ viewModel: HomeViewModelInput, sectionDidLoad list: [Section])
}

final class HomeViewModel: HomeViewModelInput  {
    
    //MARK: Properties
    private var sections: [Section] = []
    private var businessList: [LocationModel] = []
    private var cells: [HomeCollectionViewCellViewModel] = []
    private let networkManager: NetworkManager
    private let geoLocationManager: GeoLocationManager
    private var lat: Double = .zero
    private var lon: Double = .zero
    
    weak var output: HomeViewModelOutput?

    
    init(networkManager: NetworkManager, geoLocationManager: GeoLocationManager) {
        self.networkManager = networkManager
        self.geoLocationManager = geoLocationManager
        networkManager.delegate = self
        geoLocationManager.delegate = self
    }
    
    func viewDidLoad() {
        geoLocationManager.requestAuthorization()
    }
    
    func getBusinessList(for location: String) {
        networkManager.requestBusiness(city: location)
    }
    
    func getBusinessList() {
        geoLocationManager.requestCurrentLocation()
    }
    
    func getLocationData() {
        geoLocationManager.requestCurrentLocation()
    }
    
    func getSections() -> [Section] {
        sections
    }
    
    func updateSections(_ sections: [Section]) {
        self.sections = sections
    }
}

//MARK: - Helpers
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

//MARK: - NetworkManagerDelegate
extension HomeViewModel: NetworkManagerDelegate {
    func didGetLocation(_ networkManager: NetworkManager, _ location: [LocationModel]) {
        businessList = location
        self.generateCellData()
    }
}

extension HomeViewModel: GeoLocationManagerDelegate {
    func didUpdateLocation(_ geoLocationManager: GeoLocationManager, _ geoLocation: GeoLocationModel) {
        lat = geoLocation.lat
        lon = geoLocation.lon
        networkManager.requestBusiness(lat: lat, lon: lon)
    }
}

