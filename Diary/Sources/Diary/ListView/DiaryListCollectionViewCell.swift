//
//  DiaryListCollectionViewCell.swift
//  Diary
//
//  Created by 민쏜, 보리사랑 on 2022/08/17.
//

import UIKit

final class DiaryListCollectionViewCell: UICollectionViewCell {

    // MARK: - Properties
    
    var imageRequest: URLSessionTask?
    
    // MARK: - UI Components

    private let disclosureIndicatorImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "chevron.right"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .lightGray
        return imageView
    }()
    
    private let labelsVerticalStackView: UIStackView = {
        let stackeView = UIStackView()
        stackeView.translatesAutoresizingMaskIntoConstraints = false
        stackeView.axis = .vertical
        stackeView.alignment = .leading
        stackeView.distribution = .fillEqually
        return stackeView
    }()

    private let mainTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .title3)
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()

    private let secondRowHorizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 8
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        return stackView
    }()

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        label.font = .preferredFont(forTextStyle: .body)
        return label
    }()
    
    private lazy var weatherIcon: UIImageView = {
        let weatherIcon = UIImageView()
        weatherIcon.image = UIImage(systemName: "arrow.clockwise.icloud.fill")
        weatherIcon.tintColor = .lightGray
        weatherIcon.contentMode = .scaleAspectFit
        return weatherIcon
    }()

    private let shortDescriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        label.numberOfLines = 1
        label.font = .preferredFont(forTextStyle: .subheadline)
        return label
    }()

    // MARK: - Cell Initializer

    override init(frame: CGRect) {
        super.init(frame: frame)
    
        addUIComponents()
        configureLayout()
        setupWeatherIconLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        if let imageRequest = imageRequest {
            imageRequest.cancel()
        }
        
        weatherIcon.image = UIImage(systemName: "arrow.clockwise.icloud.fill")
    }
    
    // MARK: - Methods
    
    func setupCellData(diary: DiaryItem) {
        mainTitleLabel.text = diary.title
        dateLabel.text = diary.createdDate.localizedFormat()
        shortDescriptionLabel.text = diary.body
        
        APIURLComponents.configureWeatherIconPath(of: diary.weatherIconId)
        
        createNetworkRequest(
            using: .get,
            on: APIURLComponents.openWeatherIconURLComponents?.url
        )
    }
}

// MARK: - Private Methods

private extension DiaryListCollectionViewCell {

    // MARK: Configuring Model
    
    func createNetworkRequest(using httpMethod: HTTPMethod, on url: URL?) {
            let urlRequest = APIRequest(
                url: url!,
                httpMethod: httpMethod,
                body: nil
            ).createURLRequest()
            
            imageRequest = NetworkingManager.execute(
                urlRequest
            ) { (result: Result<Data, NetworkingError>) in
                switch result {
                case .success(let data):
                    print(data)
                    DispatchQueue.main.async {
                        self.weatherIcon.image = UIImage(data: data)
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }

    
    // MARK: Configuring UI
    
    func setupWeatherIconLayout() {
        weatherIcon.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            weatherIcon.heightAnchor.constraint(equalToConstant: 25),
            weatherIcon.widthAnchor.constraint(equalToConstant: 25)
        ])
    }
    
    func addUIComponents() {
        contentView.addSubview(labelsVerticalStackView)
        contentView.addSubview(disclosureIndicatorImageView)

        labelsVerticalStackView.addArrangedSubview(mainTitleLabel)
        labelsVerticalStackView.addArrangedSubview(secondRowHorizontalStackView)

        secondRowHorizontalStackView.addArrangedSubview(dateLabel)
        secondRowHorizontalStackView.addArrangedSubview(weatherIcon)
        secondRowHorizontalStackView.addArrangedSubview(shortDescriptionLabel)
    }

    func configureLayout() {
        NSLayoutConstraint.activate([
            labelsVerticalStackView.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: 5
            ),
            labelsVerticalStackView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: 14
            ),
            labelsVerticalStackView.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor,
                constant: -5
            )
        ])

        NSLayoutConstraint.activate([
            disclosureIndicatorImageView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -14
            ),
            disclosureIndicatorImageView.centerYAnchor.constraint(
                equalTo: contentView.centerYAnchor
            ),
            disclosureIndicatorImageView.widthAnchor.constraint(
                equalToConstant: disclosureIndicatorImageView.frame.width
            ),
            disclosureIndicatorImageView.leadingAnchor.constraint(
                equalTo: labelsVerticalStackView.trailingAnchor,
                constant: 5
            )
        ])
    }
}
