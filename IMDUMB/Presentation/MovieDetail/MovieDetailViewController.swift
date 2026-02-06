//
//  MovieDetailViewController.swift
//  IMDUMB
//
//  Created on 4/02/26.
//

import UIKit

// MARK: - MovieDetailViewProtocol
protocol MovieDetailViewProtocol: AnyObject {
    func displayMovie(_ movie: Movie)
    func displayLoading()
    func dismissLoading()
    func displayError(_ error: Error)
}

// MARK: - MovieDetailViewController
class MovieDetailViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var carouselScrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var overviewTextView: UITextView!
    @IBOutlet weak var actorsCollectionView: UICollectionView!
    @IBOutlet weak var recommendButton: UIButton!
    @IBOutlet weak var carouselHeightConstraint: NSLayoutConstraint!
    
    // MARK: - Properties
    var presenter: MovieDetailPresenterProtocol?
    private var currentMovie: Movie?
    private var imageViews: [UIImageView] = []
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupCollectionView()
        setupCarousel()
        presenter?.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateCarouselLayout()
    }
    
    // MARK: - Setup
    private func setupUI() {
        title = "Detalle"
        view.backgroundColor = .systemBackground
        
        // Title
        titleLabel.font = UIFont.boldSystemFont(ofSize: 28)
        titleLabel.textColor = .label
        titleLabel.numberOfLines = 0
        
        // Rating
        ratingLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        ratingLabel.textColor = .systemYellow
        
        // Release Date
        releaseDateLabel.font = UIFont.systemFont(ofSize: 14)
        releaseDateLabel.textColor = .secondaryLabel
        
        // Overview
        overviewTextView.font = UIFont.systemFont(ofSize: 16)
        overviewTextView.textColor = .label
        overviewTextView.isEditable = false
        overviewTextView.isScrollEnabled = false
        overviewTextView.backgroundColor = .clear
        
        // Recommend Button
        recommendButton.setTitle("Recomendar", for: .normal)
        recommendButton.backgroundColor = .systemIndigo
        recommendButton.setTitleColor(.white, for: .normal)
        recommendButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        recommendButton.layer.cornerRadius = 12
        recommendButton.addTarget(self, action: #selector(recommendButtonTapped), for: .touchUpInside)
        
        if !AppConfigurationManager.shared.recommendationsEnabled {
            recommendButton.isHidden = true
            print("[MovieDetail] Recommend button hidden - feature disabled")
        }
    }
    
    private func setupCollectionView() {
        actorsCollectionView.delegate = self
        actorsCollectionView.dataSource = self
        actorsCollectionView.backgroundColor = .clear
        
        // Layout horizontal
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        actorsCollectionView.collectionViewLayout = layout
        
        // Registrar celda
        let nib = UINib(nibName: "ActorCollectionViewCell", bundle: nil)
        actorsCollectionView.register(nib, forCellWithReuseIdentifier: ActorCollectionViewCell.reuseIdentifier)
    }
    
    private func setupCarousel() {
        carouselScrollView.delegate = self
        carouselScrollView.isPagingEnabled = true
        carouselScrollView.showsHorizontalScrollIndicator = false
        
        pageControl.currentPageIndicatorTintColor = .systemIndigo
        pageControl.pageIndicatorTintColor = .systemGray4
        pageControl.addTarget(self, action: #selector(pageControlValueChanged), for: .valueChanged)
    }
    
    // MARK: - Actions
    @objc private func recommendButtonTapped() {
        guard AppConfigurationManager.shared.recommendationsEnabled else {
            print("[MovieDetail] Recommendations feature is disabled")
            showAlert(
                title: "Función no disponible",
                message: "La función de recomendaciones no está disponible en este momento.",
                actions: [UIAlertAction(title: "OK", style: .default)]
            )
            return
        }
        
        presenter?.recommendButtonTapped()

        guard let movie = currentMovie else { return }
        
        let modalVC = RecommendationModalViewController.loadFromNib()
        modalVC.movie = movie
        modalVC.modalPresentationStyle = .pageSheet
        
        present(modalVC, animated: true)
    }
    
    @objc private func pageControlValueChanged() {
        let page = pageControl.currentPage
        let offsetX = CGFloat(page) * carouselScrollView.bounds.width
        carouselScrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
    }
    
    // MARK: - Private Methods
    private func updateCarouselLayout() {
        guard !imageViews.isEmpty else { return }
        
        let width = carouselScrollView.bounds.width
        let height = carouselScrollView.bounds.height
        
        for (index, imageView) in imageViews.enumerated() {
            imageView.frame = CGRect(
                x: CGFloat(index) * width,
                y: 0,
                width: width,
                height: height
            )
        }
        
        carouselScrollView.contentSize = CGSize(
            width: width * CGFloat(imageViews.count),
            height: height
        )
    }
    
    private func setupCarouselImages(urls: [String]) {
        // Limpiar imágenes previas
        imageViews.forEach { $0.removeFromSuperview() }
        imageViews.removeAll()
        
        // Crear image views
        for urlString in urls {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.backgroundColor = .systemGray6
            imageView.loadImage(from: urlString)
            
            carouselScrollView.addSubview(imageView)
            imageViews.append(imageView)
        }
        
        // Configurar page control
        pageControl.numberOfPages = urls.count
        pageControl.currentPage = 0
        pageControl.isHidden = urls.count <= 1
        
        updateCarouselLayout()
    }
}

// MARK: - MovieDetailViewProtocol Implementation
extension MovieDetailViewController: MovieDetailViewProtocol {
    
    func displayMovie(_ movie: Movie) {
        currentMovie = movie
        
        titleLabel.text = movie.title
        ratingLabel.text = "⭐️ \(String(format: "%.1f", movie.rating)) / 10"
        releaseDateLabel.text = "Estreno: \(movie.releaseDate)"
        
        // Renderizar HTML
        if let attributedText = movie.overview.htmlAttributedString(fontSize: 16) {
            overviewTextView.attributedText = attributedText
        } else {
            overviewTextView.text = movie.overview
        }
        
        // Configurar carrusel
        setupCarouselImages(urls: movie.backdropURLs)
        
        // Recargar actores
        actorsCollectionView.reloadData()
    }
    
    func displayLoading() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let loadingView = UIView(frame: self.view.bounds)
            loadingView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            loadingView.tag = 999999
            
            let activityIndicator = UIActivityIndicatorView(style: .large)
            activityIndicator.color = .white
            activityIndicator.center = loadingView.center
            activityIndicator.startAnimating()
            
            loadingView.addSubview(activityIndicator)
            self.view.addSubview(loadingView)
        }
    }
    
    func dismissLoading() {
        DispatchQueue.main.async { [weak self] in
            self?.view.viewWithTag(999999)?.removeFromSuperview()
        }
    }
    
    func displayError(_ error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UICollectionView DataSource
extension MovieDetailViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentMovie?.actors.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ActorCollectionViewCell.reuseIdentifier,
            for: indexPath
        ) as? ActorCollectionViewCell,
              let actor = currentMovie?.actors[indexPath.item] else {
            return UICollectionViewCell()
        }
        
        cell.configure(with: actor)
        return cell
    }
}

// MARK: - UICollectionView Delegate
extension MovieDetailViewController: UICollectionViewDelegate {
    // Implementación opcional
}

// MARK: - UICollectionView DelegateFlowLayout
extension MovieDetailViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 120)
    }
}

// MARK: - UIScrollView Delegate
extension MovieDetailViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView == carouselScrollView else { return }
        
        let pageIndex = round(scrollView.contentOffset.x / scrollView.bounds.width)
        pageControl.currentPage = Int(pageIndex)
    }
}
