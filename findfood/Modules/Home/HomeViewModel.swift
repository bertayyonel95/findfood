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
    func shouldRequestData(at indexPath: Int, page: Int)
    func popUpMenuPressed()
    func needsToLogin()
    func increasePage()
    func fetchNextPage(with searchText: String)
    func favouritesPressed()
    func bookmarkPressed()
    func searchPreseed(with searchText: String)
    var isLoadingData: Bool { get set }
}
// MARK: - HomeViewModelOutput
protocol HomeViewModelOutput: AnyObject {
    func home(_ viewModel: HomeViewModelInput, businessListDidLoad list: [Location])
    func home(_ viewModel: HomeViewModelInput, sectionDidLoad list: [Section])
}
// MARK: - HomeViewModel
final class HomeViewModel: HomeViewModelInput  {
    //MARK: Properties
    private let cityNameAPI: CityNameFetchable
    private let coordinateAPI: CoordinateFetchable
    private let locationIDAPI: LocationIDFetchable
    private let homeRouter: HomeRouting
    private var sections: [Section] = []
    private var businessList: [Location] = []
    private var cells: [HomeCollectionViewCellViewModel] = []
    private let geoLocationManager: GeoLocationManager
    private var lat: Double = .zero
    private var lon: Double = .zero
    private var lastVisitedDateList: [String:String] = [:]
    private var coordinateRequest: CoordinateRequest = CoordinateRequest(lat: 0, lon: 0)
    private var page = 0
    private enum LastRequest {
        case byLocation
        case bySearch
        case byFavourite
    }
    private var lastRequest: LastRequest = LastRequest.byLocation
    
    var isLoadingData: Bool = false
    weak var output: HomeViewModelOutput?
    // MARK: init
    init(cityNameAPI: CityNameFetchable, coordinateAPI: CoordinateFetchable, geoLocationManager: GeoLocationManager, locationIDAPI: LocationIDFetchable, homeRouter: HomeRouting) {
        self.cityNameAPI = cityNameAPI
        self.coordinateAPI = coordinateAPI
        self.geoLocationManager = geoLocationManager
        self.locationIDAPI = locationIDAPI
        self.homeRouter = homeRouter
        geoLocationManager.delegate = self
        geoLocationManager.requestAuthorization()
    }
    // MARK: Helpers
    /// Clears the data from the cells.
    func clearData() {
        cells.removeAll()
        sections = []
        businessList = []
    }
    
    /// Populates the business list with the name of a location.
    ///
    /// - Parameters:
    ///    - locations: name of the location.
    ///    - page: which page of the data is to be retrieved.
    func getBusinessList(for location: String, at page: Int) {
        isLoadingData = true
        let requestWithName = CityNameRequest(cityName: location)
        requestWithName.offset = page * requestWithName.limit
        cityNameAPI.retrieveByCityName(request: requestWithName) { [weak self] result in
            guard let self else { return }
            self.isLoadingData = false
            if page == 0 { self.clearData() }
            switch result {
            case .success(let locationData):
                guard locationData.total > requestWithName.offset else { return }
                locationData.businesses.forEach { business in
                    let locationModel = Location(with: business)
                    self.businessList.append(locationModel)
                }
                self.generateCellData()
                self.output?.home(self, businessListDidLoad: self.businessList)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func shouldRequestData(at indexPath: Int, page: Int) {
        if indexPath + 5 == self.getDataSize() && !isLoadingData {
            getBusinessListWithLocation(at: page)
        }
    }
    /// Populates the business list with the current location
    ///
    /// - Parameters:
    ///    - page: which page of the data is to be retrieved.
    func getBusinessListWithLocation(at page: Int) {
        isLoadingData = true
        coordinateRequest.offset = page * coordinateRequest.limit
        coordinateAPI.retrieveByCoordinate(request: coordinateRequest) { [weak self] result in
            guard let self else { return }
            self.isLoadingData = false
            if page == 0 { self.clearData() }
            switch result {
            case .success(let locationData):
                guard locationData.total > coordinateRequest.offset else { return }
                businessList = []
                locationData.businesses.forEach { business in
                    let locationModel = Location(with: business)
                    self.businessList.append(locationModel)
                }
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
            return
        }
        
        let group = DispatchGroup()
        LoadingManager.shared.show()
        favouriteLocations.forEach { location in
            group.enter()
            self.locationIDAPI.retrieveByLocationID(request: .init(locationID: location)) { [weak self] result in
                LoadingManager.shared.hide()
                guard let self = self else { return }
                switch result {
                case .success(let locationData):
                    let locationModel = Location(with: locationData)
                    self.businessList.insert(locationModel, at: self.businessList.count)
                    group.leave()
                    self.output?.home(self, businessListDidLoad: self.businessList)
                case .failure(let error):
                    print(error.localizedDescription)
                    group.leave()
                }
            }
        }
        
        group.notify(queue: .main) {
            self.generateCellData()
        }
    }
    
    func increasePage() {
        page += 1
    }
    
    func resetPage() {
        page = 0
    }
    
    func fetchNextPage(with searchText: String) {
        switch lastRequest {
        case .bySearch:
            getBusinessList(for: searchText, at: page)
        case .byLocation:
            getBusinessListWithLocation(at: page)
        case .byFavourite:
            return
        }
    }
    
    func bookmarkPressed() {
        lastRequest = LastRequest.byLocation
        resetPage()
        getLocationData()
    }
    
    func favouritesPressed() {
        lastRequest = .byFavourite
        getBusinessListWithFavourites(favouriteLocations: FirebaseManager.shared.returnLikedLocations())
    }
    
    func searchPreseed(with searchText: String) {
        resetPage()
        lastRequest = .bySearch
        getBusinessList(for: searchText, at: page)
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
    
    func popUpMenuPressed() {
        if FirebaseManager.shared.userExists() {
            homeRouter.navigateToUserMenu()
        } else {
            homeRouter.navigateToSideMenu()
        }
    }
    
    func needsToLogin() {
        homeRouter.navigateToLogin()
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

// MARK: - Helpers
private extension HomeViewModel {
    func generateCellData() {
        //var sections: [Section] = []

        businessList.forEach { business in
            let cellViewModel = generateViewModel(with: business)
            cells.append(cellViewModel)
        }
        cells.forEach { item in
            let section = Section(location: item)
            if !sections.contains(section) { sections.append(section) }
        }
        output?.home(self, sectionDidLoad: sections)
    }
    
    func generateViewModel(with business: Location) -> HomeCollectionViewCellViewModel {
        HomeCollectionViewCellViewModel(
            uuid: .init(),
            id: business.locationID,
            name: business.locationName,
            image_url: business.locatinImageLink,
            rating: business.locationRating + Constant.ViewText.ratingLimit,
            price: business.locationPrice,
            phone: business.display_phone,
            address: business.display_address
        )
    }
}
// MARK: - GeoLocationManagerDelegate
extension HomeViewModel: GeoLocationManagerDelegate {
    func didUpdateLocation(_ geoLocationManager: GeoLocationManager, _ geoLocation: GeoLocation) {
        coordinateRequest = .init(lat: geoLocation.lat, lon: geoLocation.lon)
        getBusinessListWithLocation(at: 0)
    }
}
