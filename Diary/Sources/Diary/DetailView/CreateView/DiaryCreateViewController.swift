//
//  DiaryDetailViewController.swift
//  Diary
//
//  Created by 민쏜, 보리사랑 on 2022/08/16.
//

import UIKit
import CoreLocation

final class DiaryCreateViewController: DiaryEditableViewController {
    
    // MARK: - Properties
    
    private let locationManager = CLLocationManager()
    private var location: Location?
    private var wasLocationUpdated = false
    
    private var newDiaryItem = DiaryItem(
        title: "",
        body: "",
        createdDate: Date().timeIntervalSince1970,
        uuid: UUID(),
        weather: "",
        weatherIconId: ""
    )
    
    // MARK: - Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureRootViewUI()
        addUIComponents()
        configureLayout()
        DiaryCoreDataManager.shared.saveDiary(diaryItem: newDiaryItem)
        setupKeyboard()
        
        setupLocationManager()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        removeKeyboardWillShowNoification()
        //TODO: icon id를 바탕으로 이미지에 대한 네트워킹하기
        //TODO: 받은 이미지를 CoreData에 넣기
        updateNewDiaryEntity()
    }
}

private extension DiaryCreateViewController {
    
    // MARK: - Private Methods
    
    // MARK: - Configuring DiaryItem for Core Data
    
    func convertTextToDiaryItem() {
        let data = splitTitleAndBody(from: contentTextView.text)
        
        newDiaryItem.title = data.title
        newDiaryItem.body = data.body
    }
    
    func updateNewDiaryEntity() {
        convertTextToDiaryItem()
        DiaryCoreDataManager.shared.update(diaryItem: newDiaryItem)
    }
    
    func createNetworkRequest(using httpMethod: HTTPMethod, on url: URL?) {
        let urlRequest = APIRequest(
            url: url!,
            httpMethod: httpMethod,
            body: nil
        ).createURLRequest()
        
        NetworkingManager.execute(
            urlRequest
        ) { (result: Result<Data, NetworkingError>) in
            switch result {
            case .success(let data):
                let diaryDataManager = DiaryDataManager()
                guard let parsedData = diaryDataManager.parse(data, into: WeatherModel.self) else {
                    return
                }
                
                self.newDiaryItem.weather = parsedData.weather.first?.main ?? ""
                self.newDiaryItem.weatherIconId = parsedData.weather.first?.icon ?? ""
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // MARK: Configuring UI
    
    func configureRootViewUI() {
        self.view.backgroundColor = .systemBackground
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didEnterBackground(_:)),
            name: UIApplication.didEnterBackgroundNotification,
            object: nil
        )
        
        navigationItem.title = newDiaryItem.createdDate.localizedFormat()
    }
    
    @objc func didEnterBackground(_ sender: Notification) {
        updateNewDiaryEntity()
    }
    
    // MARK: Setting Keyboard
    
    func setupKeyboard() {
        contentTextView.becomeFirstResponder()
        setupKeyboardWillShowNoification()
    }
    
    @objc func keyboardWillHide(_ sender: Notification) {
        updateNewDiaryEntity()
    }
    
    // MARK: Setting Location
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }
    
    private func updateWeather(at location: Location) {
        APIURLComponents.configureWeatherQueryItem(
            location: location
        )
        
        createNetworkRequest(
            using: HTTPMethod.get,
            on: APIURLComponents.openWeatherURLComponents?.url
        )
    }
}

extension DiaryCreateViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        
        let locationData = Location(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        
        self.location = locationData
        
        if wasLocationUpdated == false {
            updateWeather(at: locationData)
            wasLocationUpdated = true
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
