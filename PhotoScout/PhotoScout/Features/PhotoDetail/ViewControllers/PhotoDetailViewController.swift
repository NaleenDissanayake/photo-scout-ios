//
//  PhotoDetailVC.swift
//  PhotoScout
//
//  Created by Naleen Dissanayake on 2026/04/23.
//

import UIKit
import RxSwift

final class PhotoDetailViewController: UIViewController {
    static let storyboardIdentifier = "PhotoDetailVC"
    
    private let imageView = UIImageView()
    private let captionLabel = UILabel()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private let disposeBag = DisposeBag()
    
    private var viewModel: PhotoDetailViewModel!
    private var imageLoader: ImageLoading!
    
    func inject(viewModel: PhotoDetailViewModel, imageLoader: ImageLoading) {
        self.viewModel = viewModel
        self.imageLoader = imageLoader
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        precondition(viewModel != nil, "PhotoDetailViewController dependencies were not injected")
        precondition(imageLoader != nil, "SearchViewController imageLoader was not injected")
        
        configureAppearance()
        setupViews()
        setupConstraints()
        render()
        bindImage()
    }
}

// MARK: - UI Setup
private extension PhotoDetailViewController {
    func configureAppearance() {
        title = PhotoDetailStrings.screenTitle
        view.backgroundColor = .black
    }
    
    func setupViews() {
        setupImageView()
        setupCaptionLabel()
        setupActivityIndicator()
    }
    
    func setupImageView() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .black
        view.addSubview(imageView)
    }
    
    func setupCaptionLabel() {
        captionLabel.translatesAutoresizingMaskIntoConstraints = false
        captionLabel.font = .preferredFont(forTextStyle: .body)
        captionLabel.textColor = .white
        captionLabel.numberOfLines = 0
        captionLabel.textAlignment = .center
        view.addSubview(captionLabel)
    }
    
    func setupActivityIndicator() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.bottomAnchor.constraint(
                equalTo: captionLabel.topAnchor,
                constant: -PhotoDetailUIConstants.imageToCaptionSpacing
            ),
            
            captionLabel.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: PhotoDetailUIConstants.horizontalInset
            ),
            captionLabel.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -PhotoDetailUIConstants.horizontalInset
            ),
            captionLabel.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                constant: -PhotoDetailUIConstants.bottomInset
            ),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

// MARK: - Render
private extension PhotoDetailViewController {
    func render() {
        captionLabel.text = viewModel.titleText
    }
    
    func bindImage() {
        activityIndicator.startAnimating()
        
        imageLoader.loadImage(from: viewModel.imageURL)
            .observe(on: MainScheduler.instance)
            .subscribe(
                onSuccess: { [weak self] image in
                    self?.activityIndicator.stopAnimating()
                    self?.imageView.image = image
                },
                onFailure: { [weak self] _ in
                    self?.activityIndicator.stopAnimating()
                }
            )
            .disposed(by: disposeBag)
    }
}
