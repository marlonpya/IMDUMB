//
//  CategoryCollectionViewCell.swift
//  IMDUMB
//
//  Created on 4/02/26.
//

import UIKit

// MARK: - CategoryCellDelegate
protocol CategoryCellDelegate: AnyObject {
    func didSelectMovie(_ movie: Movie)
}

// MARK: - CategoryCollectionViewCell
class CategoryCollectionViewCell: UICollectionViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet weak var categoryNameLabel: UILabel!
    @IBOutlet weak var moviesTableView: UITableView!
    
    // MARK: - Properties
    private var movies: [Movie] = []
    weak var delegate: CategoryCellDelegate?
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupTableView()
    }
    
    // MARK: - Setup
    private func setupTableView() {
        moviesTableView.delegate = self
        moviesTableView.dataSource = self
        moviesTableView.backgroundColor = .clear
        moviesTableView.separatorStyle = .none
        moviesTableView.showsVerticalScrollIndicator = false
        
        // Importante: Configurar scroll horizontal simulado
        // Rotar el TableView 90 grados para lograr scroll horizontal
        moviesTableView.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
        
        // Registrar celda
        let nib = UINib(nibName: "MovieTableViewCell", bundle: nil)
        moviesTableView.register(nib, forCellReuseIdentifier: MovieTableViewCell.reuseIdentifier)
        
        // Configurar altura de fila
        moviesTableView.rowHeight = 150
    }
    
    // MARK: - Configure
    func configure(with category: Category, delegate: CategoryCellDelegate?) {
        categoryNameLabel.text = category.name
        categoryNameLabel.font = UIFont.boldSystemFont(ofSize: 20)
        self.movies = category.movies
        self.delegate = delegate
        moviesTableView.reloadData()
    }
}

// MARK: - UITableView DataSource
extension CategoryCollectionViewCell: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: MovieTableViewCell.reuseIdentifier,
            for: indexPath
        ) as? MovieTableViewCell else {
            return UITableViewCell()
        }
        
        let movie = movies[indexPath.row]
        cell.configure(with: movie)
        
        // Rotar la celda de vuelta para compensar la rotación del TableView
        cell.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
        
        return cell
    }
}

// MARK: - UITableView Delegate
extension CategoryCollectionViewCell: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let movie = movies[indexPath.row]
        delegate?.didSelectMovie(movie)
    }
}
