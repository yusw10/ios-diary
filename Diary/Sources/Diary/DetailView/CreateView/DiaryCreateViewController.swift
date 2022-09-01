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
    
    private var newDiaryItem = DiaryItem(
        title: "",
        body: "",
        createdDate: Date().timeIntervalSince1970,
        uuid: UUID()
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
        locationManager.delegate = self // 델리게이트 설정
        locationManager.desiredAccuracy = kCLLocationAccuracyBest // 우리가 원하는 위치 정확도
        locationManager.requestWhenInUseAuthorization() // 위치정보 요청
        // Privacy - Location When In Use Usage Description (메시지는 plist에서 설정해준 받아옴)
        // 허용하면 유저가 설정의 프라이버시에서 해당 앱의 location services를 허용하는 것과 같아짐

        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
            print("위치 가져오기 시작함")
        } else {
            print("위치 서비스 허용 off")
        }
    }
}

extension DiaryCreateViewController: CLLocationManagerDelegate {
    
    // 위치를 가져오면 실행됨
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(locations) // 위도 경도, 풍속, 날짜, 시간 등 정보가 들어있는 Array
        
        if let location = locations.first {
            print("위치 업데이트!")
            print("위도 : \(location.coordinate.latitude)")
            print("경도 : \(location.coordinate.longitude)")
            
            let location = Location(longitude: location.coordinate.longitude, latitude: location.coordinate.latitude)
            WeatherNetworkManager.shared.requestWeatherData(location: location)
        }
    }
        
    // 위치 가져오는 과정에서 오류가 있었으면 실행됨
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error")
    }
}
