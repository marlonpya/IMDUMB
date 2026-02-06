//
//  RecommendationModalViewController.swift
//  IMDUMB
//
//  Created on 4/02/26.
//

import UIKit

// MARK: - RecommendationModalViewController
class RecommendationModalViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var characterCountLabel: UILabel!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    // MARK: - Properties
    var movie: Movie?
    private let maxCharacters = 280
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureWithMovie()
        
        // Configurar como sheet con altura dinámica
        if let presentationController = presentationController as? UISheetPresentationController {
            presentationController.detents = [.medium(), .large()]
            presentationController.prefersGrabberVisible = true
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        commentTextView.becomeFirstResponder()
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        // Container
        containerView.backgroundColor = .systemBackground
        containerView.layer.cornerRadius = 20
        containerView.layer.masksToBounds = true
        
        // Title
        titleLabel.text = "Recomendar Película"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.textColor = .label
        
        // Movie Title
        movieTitleLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        movieTitleLabel.textColor = .systemIndigo
        movieTitleLabel.numberOfLines = 2
        
        // Overview
        overviewLabel.font = UIFont.systemFont(ofSize: 14)
        overviewLabel.textColor = .secondaryLabel
        overviewLabel.numberOfLines = 0
        
        // Comment TextView
        commentTextView.delegate = self
        commentTextView.font = UIFont.systemFont(ofSize: 16)
        commentTextView.layer.borderWidth = 1
        commentTextView.layer.borderColor = UIColor.systemGray4.cgColor
        commentTextView.layer.cornerRadius = 8
        commentTextView.textContainerInset = UIEdgeInsets(top: 12, left: 8, bottom: 12, right: 8)
        
        // Placeholder
        if commentTextView.text.isEmpty {
            commentTextView.text = "¿Por qué recomiendas esta película?"
            commentTextView.textColor = .placeholderText
        }
        
        // Character Count
        characterCountLabel.font = UIFont.systemFont(ofSize: 12)
        characterCountLabel.textColor = .secondaryLabel
        updateCharacterCount(0)
        
        // Send Button
        sendButton.setTitle("Enviar Recomendación", for: .normal)
        sendButton.backgroundColor = .systemIndigo
        sendButton.setTitleColor(.white, for: .normal)
        sendButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        sendButton.layer.cornerRadius = 12
        sendButton.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
        
        // Cancel Button
        cancelButton.setTitle("Cancelar", for: .normal)
        cancelButton.setTitleColor(.systemGray, for: .normal)
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
    }
    
    private func configureWithMovie() {
        guard let movie = movie else { return }
        
        movieTitleLabel.text = movie.title
        overviewLabel.text = movie.overview.stripHTML
    }
    
    private func updateCharacterCount(_ count: Int) {
        characterCountLabel.text = "\(count) / \(maxCharacters)"
        characterCountLabel.textColor = count > maxCharacters ? .systemRed : .secondaryLabel
        sendButton.isEnabled = count > 0 && count <= maxCharacters
        sendButton.alpha = sendButton.isEnabled ? 1.0 : 0.5
    }
    
    // MARK: - Actions
    @objc private func sendButtonTapped() {
        guard let movie = movie else { return }
        
        let comment = commentTextView.text ?? ""
        
        // Validar que no sea el placeholder
        guard comment != "¿Por qué recomiendas esta película?" else {
            showAlert(title: "Error", message: "Por favor escribe un comentario")
            return
        }
        
        // Capturar el título del movie antes del dismiss
        let movieTitle = movie.title
        
        // Capturar el presentingViewController antes del dismiss
        guard let presentingVC = self.presentingViewController else {
            dismiss(animated: true)
            return
        }
        
        print("[RecommendationModal] Sending recommendation for: \(movieTitle)")
        
        // Simular envío
        dismiss(animated: true) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                let alert = UIAlertController(
                    title: "¡Éxito!",
                    message: "Has recomendado \"\(movieTitle)\" exitosamente.",
                    preferredStyle: .alert
                )
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                presentingVC.present(alert, animated: true)
            }
        }
    }
    
    @objc private func cancelButtonTapped() {
        dismiss(animated: true)
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UITextViewDelegate
extension RecommendationModalViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .placeholderText {
            textView.text = nil
            textView.textColor = .label
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "¿Por qué recomiendas esta película?"
            textView.textColor = .placeholderText
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let count = textView.text.count
        updateCharacterCount(count)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = textView.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: text)
        
        return updatedText.count <= maxCharacters
    }
}
