//
//  HomeViewModel.swift
//  findfood
//
//  Created by Bertay Yönel on 6.01.2023.
//

import Foundation

protocol HomeViewModelInput {
    var output: HomeViewModelOutput? { get set }
    
    func getBusinessList(for location: String, at page: Int)
    func getSections() -> [Section]
    func updateSections(_ sections: [Section])
    func getLocationData()
    func getDataSize() -> Int
    func clearData()
    func updateLastVisited(with viewModel: HomeCollectionViewCellViewModel)
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
    private var lastVisitedDateList: [String:String] = [:]
    
    weak var output: HomeViewModelOutput?

    
    init(cityNameAPI: CityNameFetchable, coordinateAPI: CoordinateFetchable, geoLocationManager: GeoLocationManager) {
        self.cityNameAPI = cityNameAPI
        self.coordinateAPI = coordinateAPI
        self.geoLocationManager = geoLocationManager
        geoLocationManager.delegate = self
        geoLocationManager.requestAuthorization()
    }
    
    func clearData() {
        cells.removeAll()
    }
    
    func getBusinessList(for location: String, at page: Int) {

        cityNameAPI.retrieveByCityName(request: .init(cityName: location), at: page) { [weak self] result in
            guard let self = self else { return }
            
            if page == 0 { self.clearData() }
            
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
    
    func getLocationData() {
        geoLocationManager.requestCurrentLocation()
    }
    
    func getSections() -> [Section] {
        sections
    }
    
    func updateSections(_ sections: [Section]) {
        self.sections = sections
    }
    
    func getDataSize() -> Int {
        return sections.count
    }
    
    func updateLastVisited(with viewModel: HomeCollectionViewCellViewModel) {
        do {
            lastVisitedDateList = getLastVisited()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            let dateString = dateFormatter.string(from: Date())
            print(dateString)
            lastVisitedDateList[viewModel.id] = dateString
            
            try UserDefaultsManager.shared.setObject(lastVisitedDateList, forKey: Constant.UserDefaults.lastVisitDate)
        } catch {
            
        }
    }
    
    func getLastVisited() -> [String:String] {
        do {
            let lastVisitedDateList = try UserDefaultsManager.shared.getObject(forKey: Constant.UserDefaults.lastVisitDate, castTo: [String:String].self)
            return lastVisitedDateList
        } catch {
            return [:]
        }
    }
}

//MARK: - Helpers
private extension HomeViewModel {
    func generateCellData() {
        var sections: [Section] = []

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
        coordinateAPI.retrieveByCoordinate(request: .init(lat: geoLocation.lat, lon: geoLocation.lon), at: 0) { [weak self] result in
            
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
