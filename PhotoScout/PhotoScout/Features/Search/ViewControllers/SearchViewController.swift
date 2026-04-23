//
//  SearchViewController.swift
//  PhotoScout
//
//  Created by Naleen Dissanayake on 2026/04/23.
//

import UIKit
import RxSwift
import RxCocoa

final class SearchViewController: UIViewController {
    static let storyboardIdentifier = "SearchVC"

    private let collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: SearchLayoutFactory.makeLayout()
    )
    private let messageLabel = UILabel()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private let searchController = UISearchController(searchResultsController: nil)
    private let disposeBag = DisposeBag()

    private var viewModel: SearchViewModel!
    private var imageLoader: ImageLoading!
    private var dependencyContainer: AppDependencyContainer?

    func inject(
        viewModel: SearchViewModel,
        imageLoader: ImageLoading,
        dependencyContainer: AppDependencyContainer? = nil
    ) {
        self.viewModel = viewModel
        self.imageLoader = imageLoader
        self.dependencyContainer = dependencyContainer
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        precondition(viewModel != nil, "SearchViewController dependencies were not injected")
        precondition(imageLoader != nil, "SearchViewController imageLoader was not injected")

        configureAppearance()
        setupViews()
        setupConstraints()
        bindViewModel()
    }
}

// MARK: - UI Setup
private extension SearchViewController {
    func configureAppearance() {
        title = SearchStrings.screenTitle
        view.backgroundColor = .systemBackground
    }

    func setupViews() {
        setupSearchController()
        setupCollectionView()
        setupMessageLabel()
        setupActivityIndicator()
    }

    func setupSearchController() {
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = SearchStrings.searchPlaceholder
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
    }

    func setupCollectionView() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemBackground
        collectionView.keyboardDismissMode = .onDrag
        collectionView.register(
            SearchPhotoCell.self,
            forCellWithReuseIdentifier: SearchPhotoCell.reuseIdentifier
        )
        view.addSubview(collectionView)
    }

    func setupMessageLabel() {
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.textAlignment = .center
        messageLabel.textColor = .secondaryLabel
        messageLabel.font = .preferredFont(forTextStyle: .body)
        messageLabel.numberOfLines = 0
        messageLabel.isHidden = true
        view.addSubview(messageLabel)
    }

    func setupActivityIndicator() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            messageLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            messageLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            messageLabel.leadingAnchor.constraint(
                greaterThanOrEqualTo: view.leadingAnchor,
                constant: SearchUIConstants.horizontalInset
            ),
            messageLabel.trailingAnchor.constraint(
                lessThanOrEqualTo: view.trailingAnchor,
                constant: -SearchUIConstants.horizontalInset
            ),

            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

// MARK: - Binding
private extension SearchViewController {
    func bindViewModel() {
        let input = makeInput()
        let output = viewModel.transform(input: input)

        bindPhotos(output)
        bindLoading(output)
        bindMessage(output)
        bindSelection(output)
        bindDeselection()
    }

    func makeInput() -> SearchViewModel.Input {
        SearchViewModel.Input(
            searchText: searchController.searchBar.rx.text.orEmpty.asObservable(),
            itemSelected: collectionView.rx.modelSelected(Photo.self).asObservable()
        )
    }

    func bindPhotos(_ output: SearchViewModel.Output) {
        output.photos
            .drive(
                collectionView.rx.items(
                    cellIdentifier: SearchPhotoCell.reuseIdentifier,
                    cellType: SearchPhotoCell.self
                )
            ) { [weak self] _, photo, cell in
                guard let self else { return }
                cell.configure(with: photo, imageLoader: self.imageLoader)
            }
            .disposed(by: disposeBag)
    }

    func bindLoading(_ output: SearchViewModel.Output) {
        output.isLoading
            .drive(activityIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
    }

    func bindMessage(_ output: SearchViewModel.Output) {
        output.message
            .drive(onNext: { [weak self] message in
                self?.messageLabel.text = message
                self?.messageLabel.isHidden = (message == nil)
            })
            .disposed(by: disposeBag)
    }
    
    func bindSelection(_ output: SearchViewModel.Output) {
        output.selectedPhoto
            .emit(onNext: { [weak self] photo in
                self?.showDetail(for: photo)
            })
            .disposed(by: disposeBag)
    }

    func bindDeselection() {
        collectionView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                self?.collectionView.deselectItem(at: indexPath, animated: true)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Navigation
private extension SearchViewController {
    func showDetail(for photo: Photo) {
        if let dependencyContainer {
            let viewController = dependencyContainer.makePhotoDetailViewController(
                photo: photo
            )
            navigationController?.pushViewController(viewController, animated: true)
            return
        }

        let detailViewController: PhotoDetailViewController
        if let storyboard = storyboard,
           let viewController = storyboard.instantiateViewController(
                withIdentifier: PhotoDetailViewController.storyboardIdentifier
           ) as? PhotoDetailViewController {
            detailViewController = viewController
        } else {
            detailViewController = PhotoDetailViewController()
        }

        detailViewController.inject(
            viewModel: PhotoDetailViewModel(photo: photo),
            imageLoader: imageLoader
        )
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}
