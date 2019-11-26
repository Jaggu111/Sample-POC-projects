//
//  OnboardingCell.swift
//  Bluprint
//
//  Created by Emily Priddy on 10/24/18.
//  Copyright © 2018 Bluprint. All rights reserved.
//

import UIKit

protocol OnboardingCellDelegate: class {
    func didPressOnboardingCell(_ sender: OnboardingCell)
}

class OnboardingCell: UICollectionViewCell {
    
    weak var delegate: OnboardingCellDelegate?
    
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var circleImage: UIImageView!
    @IBOutlet weak var imageCoverView: UIView!
    @IBOutlet weak var selectionButton: UIButton!

    var originalCellSize: CGRect!
    var canSelect: Bool = true
    var isCellSelected: Bool = false {
        didSet {
            if self.isCellSelected {
                self.imageCoverView.alpha = 0.5
                self.circleImage.image = UIImage(named: "saves-solid")
                self.circleImage.tintColor = UIColor.white
                self.categoryLabel.textColor = UIColor.white
                self.canSelect = true
                self.isUserInteractionEnabled = true
            } else if self.canSelect {
                self.imageCoverView.alpha = 0
                self.circleImage.image = UIImage(named: "outline-circle")
                self.categoryLabel.textColor = UIColor.black
                self.isUserInteractionEnabled = true
            } else {
                self.imageCoverView.alpha = 0.15
                self.imageCoverView.tintColor = UIColor.lightGray
                self.circleImage.image = UIImage(named: "outline-circle")
                self.categoryLabel.textColor = UIColor.black
                self.isUserInteractionEnabled = false
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        originalCellSize = cellView.frame
        
        setupCellView()
        setupFonts()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleCellTap(_:)))
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleCellPress(_:)))
        longGesture.minimumPressDuration = 0.1
        tapGesture.numberOfTapsRequired = 1
        selectionButton.addGestureRecognizer(tapGesture)
        selectionButton.addGestureRecognizer(longGesture)
        tapGesture.require(toFail: longGesture)
    }
    
    func setupCellView() {
        cellView.layer.cornerRadius = 0
        cellView.layer.masksToBounds = true
    }
    
    func setupFonts() {
//        self.categoryLabel?.font = FontUtil().getBodyFont()
//        self.categoryLabel?.adjustsFontForContentSizeCategory = true
    }
    
    @objc func handleCellTap(_ sender: UIGestureRecognizer) {
        if canSelect {
            if sender.state == .ended {
                animateCellTap()
                delegate?.didPressOnboardingCell(self)
            }
        }
    }
    
    @objc func handleCellPress(_ sender: UIGestureRecognizer) {
        if canSelect {
            if sender.state == .ended {
                UIView.animate(withDuration: 0.2,
                               delay: 0,
                               usingSpringWithDamping: 0.9,
                               initialSpringVelocity: 5,
                               options: .curveLinear,
                               animations: {
                                self.cellView.transform = CGAffineTransform(scaleX: 1, y: 1)
                }, completion: nil)
            } else if sender.state == .began {
                delegate?.didPressOnboardingCell(self)
                UIView.animate(withDuration: 0.2,
                               delay: 0,
                               usingSpringWithDamping: 0.9,
                               initialSpringVelocity: 5,
                               options: .curveLinear,
                               animations: {
                                self.cellView.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
                }, completion: nil)
            }
        }
    }
    
    func selectCategory(_ selected: Bool, animated: Bool) {
        if canSelect {
            highlightCategory(selected, animated: animated)
        }
    }
    
    func highlightCategory(_ highlighted: Bool, animated: Bool) {
        let duration: TimeInterval
        if animated {
            duration = 0.5
        } else {
            duration = 0.0
        }
        UIView.animate(withDuration: duration) {
            if highlighted {
                self.highlightCategoryCell()
            } else {
                self.unhighlightCategoryCell()
            }
        }
    }
    
    func highlightCategoryCell() {
        self.imageCoverView.alpha = 0.5
        self.circleImage.image = UIImage(named: "saves-solid")
        self.circleImage.tintColor = UIColor.white
        self.categoryLabel.textColor = UIColor.white
    }
    
    func unhighlightCategoryCell() {
        self.imageCoverView.alpha = 0
        self.circleImage.image = UIImage(named: "outline-circle")
        self.categoryLabel.textColor = UIColor.black
    }
    
    func animateCellTap() {
        UIView.animate(withDuration: 0.2,
                       delay: 0,
                       usingSpringWithDamping: 0.9,
                       initialSpringVelocity: 5,
                       options: .curveLinear,
                       animations: {
                        self.cellView.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
        }, completion: { _ in
            self.animateToOriginateSize()
        })
    }
    
    func animateToOriginateSize() {
        UIView.animate(withDuration: 0.2,
                       delay: 0,
                       usingSpringWithDamping: 0.9,
                       initialSpringVelocity: 5,
                       options: .curveLinear,
                       animations: {
                        self.cellView.transform = CGAffineTransform(scaleX: 1, y: 1)
        }, completion: nil)
    }
}
