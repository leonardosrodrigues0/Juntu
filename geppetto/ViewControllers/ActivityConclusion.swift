//
//  ActivityConclusion.swift
//  geppetto
//
//  Created by Renato Noronha Máximo on 01/11/21.
//

import Foundation
import UIKit

class ActivityConclusion: UIViewController {
    @IBOutlet weak var rating: UIStackView!
    @IBOutlet weak var ratingLabel: UILabel!
    
    var activity: Activity?
    var stars: [UIButton] = []
    var currentRating = -1
    var ratingLabels: [String] = ["Não gostei", "Poderia ser melhor", "Legal", "Divertida", "Divertidíssima!"]
    var defaultRatingLabel: String = "Não avaliada"
    
    override func viewDidLoad() {
        for subview in rating.subviews {
            if let safeSubview = subview as? UIButton {
                stars.append(safeSubview)
            }
        }
        
        updateStarImages(clicked: -1)
        updateRatingLabel(clicked: -1)
    }
    
    @IBAction private func concludeButtonTapped() {
        UserTracker.shared.logSeenActivity(self.activity!)
    }
    
    @IBAction func starTapped(_ sender: Any) {
        let index: Int = Int((sender as AnyObject).tag)
        currentRating = index
        updateStarImages(clicked: index)
        updateRatingLabel(clicked: index)
    }
    
    /// Updates all starts until 'clicked' to be filled and the stars after 'clicked' to be empty
    /// index: -1 set all stars to empty
    private func updateStarImages(clicked index: Int) {
        guard index <= stars.count && index >= -1 else {
            return
        }
        
        let filledStar = UIImage(systemName: "star.fill")
        let tintedFilledStar = filledStar?.withRenderingMode(.alwaysTemplate)
        let star = UIImage(systemName: "star")
        let tintedStar = star?.withRenderingMode(.alwaysTemplate)
        
        if index >= 0 {
            for i in 0...index {
                stars[i].setImage(tintedFilledStar, for: .normal)
                stars[i].tintColor = .systemYellow
                stars[i].imageView?.contentMode = .scaleAspectFill
            }
        }
        
        for i in (index+1)..<stars.count {
            stars[i].setImage(tintedStar, for: .normal)
            stars[i].tintColor = .secondaryLabel
            stars[i].imageView?.contentMode = .scaleAspectFill
        }
    }
    
    private func updateRatingLabel(clicked index: Int) {
        guard index <= stars.count else {
            return
        }
        var newLabel = defaultRatingLabel
        if index >= 0 {
            newLabel = ratingLabels[index]
        }
        ratingLabel.text = newLabel
    }
}

// MARK: - Camera Usage Methods
extension ActivityConclusion: CameraManager {
    @IBAction private func cameraButtonTapped() {
        takePicture()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true)
        
        guard let name = activity?.name else {
            return
        }
        
        let shareText = "Estou usando Juntu e fazendo a atividade \(name) com minha criança!"
        shareImageAndText(didFinishPickingMediaWithInfo: info, text: shareText)
    }
}
