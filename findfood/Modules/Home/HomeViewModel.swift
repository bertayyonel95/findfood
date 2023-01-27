//
//  HomeViewModel.swift
//  findfood
//
//  Created by Bertay Yönel on 6.01.2023.
//

import Foundation

protocol HomeViewModelInput {
    var output: HomeViewModelOutput? { get set }
    
    func getBusinessList(for location: String)
    func getBusinessList()
    func getSections() -> [Section]
    func updateSections(_ sections: [Section])
    func getLocationData()    
}

protocol HomeViewModelOutput: AnyObject {
    func home(_ viewModel: HomeViewModelInput, businessListDidLoad list: [LocationModel])
    func home(_ viewModel: HomeViewModelInput, sectionDidLoad list: [Section])
}

final class HomeViewModel: HomeViewModelInput  {
    
    //MARK: Properties
    private var cityNameAPI: CityNameFetchable
    private var coordinateAPI: CoordinateFetchable
    
    
    private var sections: [Section] = []
    private var businessList: [LocationModel] = []
    private var cells: [HomeCollectionViewCellViewModel] = []
    private let geoLocationManager: GeoLocationManager
    private var lat: Double = .zero
    private var lon: Double = .zero
    
    weak var output: HomeViewModelOutput?

    
    init(cityNameAPI: CityNameFetchable, coordinateAPI: CoordinateFetchable, geoLocationManager: GeoLocationManager) {
        self.cityNameAPI = cityNameAPI
        self.coordinateAPI = coordinateAPI
        self.geoLocationManager = geoLocationManager
        geoLocationManager.delegate = self
        geoLocationManager.requestAuthorization()
    }
    
    func getBusinessList(for location: String) {
        cityNameAPI.retrieveByCityName(request: .init(cityName: location)) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let locationModel):
                self.businessList.append(contentsOf: locationModel)
                self.businessList = locationModel
                self.generateCellData()
                self.output?.home(self, businessListDidLoad: self.businessList)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
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
            sections.append(.init(location: item))
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

extension HomeViewModel: GeoLocationManagerDelegate {
    func didUpdateLocation(_ geoLocationManager: GeoLocationManager, _ geoLocation: GeoLocationModel) {
        coordinateAPI.retrieveByCoordinate(request: .init(lat: geoLocation.lat, lon: geoLocation.lon)) { [weak self] result in
            
            guard let self = self else { return }
            
            switch result {
            case .success(let locationModel):
                self.businessList.append(contentsOf: locationModel)
                self.businessList = locationModel
                self.generateCellData()
                self.output?.home(self, businessListDidLoad: self.businessList)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
