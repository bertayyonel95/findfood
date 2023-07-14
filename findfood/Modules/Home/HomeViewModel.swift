//
//  HomeViewModel.swift
//  findfood
//
//  Created by Bertay Yönel on 6.01.2023.
//

import Foundation

// MARK: - HomeViewModelInput
protocol HomeViewModelInput {
    // MARK: Properties
    var output: HomeViewModelOutput? { get set }
    func getBusinessList(for location: String, at page: Int)
    func getSections() -> [Section]
    func updateSections(_ sections: [Section])
    func getLocationData()
    func getDataSize() -> Int
    func clearData()
    func likeLocation(with viewModel: HomeCollectionViewCellViewModel)
    func dislikeLocation(with viewModel: HomeCollectionViewCellViewModel)
    func updateLastVisited(with viewModel: HomeCollectionViewCellViewModel)
    func getBusinessListWithLocation(at page: Int)
    func getBusinessListWithFavourites(favouriteLocations: [String])
}
// MARK: - HomeViewModelOutput
protocol HomeViewModelOutput: AnyObject {
    func home(_ viewModel: HomeViewModelInput, businessListDidLoad list: [LocationModel])
    func home(_ viewModel: HomeViewModelInput, sectionDidLoad list: [Section])
}
// MARK: - HomeViewModel
final class HomeViewModel: HomeViewModelInput  {
    //MARK: Properties
    private var cityNameAPI: CityNameFetchable
    private var coordinateAPI: CoordinateFetchable
    private var locationIDAPI: LocationIDFetchable
    private var sections: [Section] = []
    private var businessList: [LocationModel] = []
    private var cells: [HomeCollectionViewCellViewModel] = []
    private let geoLocationManager: GeoLocationManager
    private var lat: Double = .zero
    private var lon: Double = .zero
    private var lastVisitedDateList: [String:String] = [:]
    private var coordinateRequest: CoordinateRequestModel = CoordinateRequestModel(lat: 0, lon: 0)
    weak var output: HomeViewModelOutput?
    // MARK: init
    init(cityNameAPI: CityNameFetchable, coordinateAPI: CoordinateFetchable, geoLocationManager: GeoLocationManager, locationIDAPI: LocationIDAPI) {
        self.cityNameAPI = cityNameAPI
        self.coordinateAPI = coordinateAPI
        self.geoLocationManager = geoLocationManager
        self.locationIDAPI = locationIDAPI
        geoLocationManager.delegate = self
        geoLocationManager.requestAuthorization()
    }
    // MARK: Functions
    /// Clears the data from the cells.
    func clearData() {
        cells.removeAll()
    }
    /// Populates the business list with the name of a location.
    ///
    /// - Parameters:
    ///    - locations: name of the location.
    ///    - page: which page of the data is to be retrieved.
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
    /// Populates the business list with the current location
    ///
    /// - Parameters:
    ///    - page: which page of the data is to be retrieved.
    func getBusinessListWithLocation(at page: Int) {
        coordinateAPI.retrieveByCoordinate(request: coordinateRequest, at: page) { [weak self] result in
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
    
    func getBusinessListWithFavourites(favouriteLocations: [String]) {
        self.clearData()
        if favouriteLocations.isEmpty {
            businessList = []
            generateCellData()
        } else {
            
            favouriteLocations.forEach { location in
                self.locationIDAPI.retrieveByLocationID(request: .init(locationID: location)) { [weak self] result in
                    self?.businessList = []
                    guard let self = self else { return }
                    switch result {
                    case .success(let locationModel):
                        self.businessList.insert(locationModel, at: self.businessList.count)
                        self.generateCellData()
                        self.output?.home(self, businessListDidLoad: self.businessList)
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
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
    
    func likeLocation(with viewModel: HomeCollectionViewCellViewModel) {
        FirebaseManager.shared.likeLocation(locationID: viewModel.id)
    }
    
    func dislikeLocation(with viewModel: HomeCollectionViewCellViewModel) {
        FirebaseManager.shared.dislikeLocation(locationID: viewModel.id)
    }
    /// Updates the user defaults with the exact date that the location is visited.
    ///
    /// - Parameters:
    ///    - viewModel: view model to be updated with the date.
    func updateLastVisited(with viewModel: HomeCollectionViewCellViewModel) {
        do {
            lastVisitedDateList = getLastVisited()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            let dateString = dateFormatter.string(from: Date())
            lastVisitedDateList[viewModel.id] = dateString
            
            try UserDefaultsManager.shared.setObject(lastVisitedDateList, forKey: Constant.UserDefaults.lastVisitDate)
        } catch {
        }
    }
    
    func getLastVisited() -> [String: String] {
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
// MARK: - GeoLocationManagerDelegate
extension HomeViewModel: GeoLocationManagerDelegate {
    func didUpdateLocation(_ geoLocationManager: GeoLocationManager, _ geoLocation: GeoLocationModel) {
        coordinateRequest = .init(lat: geoLocation.lat, lon: geoLocation.lon)
        getBusinessListWithLocation(at: 0)
    }
}
