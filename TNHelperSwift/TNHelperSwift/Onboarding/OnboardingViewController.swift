//
//  OnboardingVC.swift
//  Bluprint
//
//  Created by Emily Priddy on 10/24/18.
//  Copyright © 2018 Bluprint. All rights reserved.
//

import UIKit

public protocol OnboardingViewModelType: class {
//    var mainString: String { get }
//    var promptString: String { get }
//    var backgroundColor: UIColor { get }
//    var categories: [String] { get }
//    var selectedCategories: [String] { get }
//    var selectedIndexes: Set<IndexPath> { get set }
//
//    func saveSelectedCategoriesInUserDefaults()
}

protocol OnboardingViewControllerDelegate: class {
//    func onboardingDidComplete(for viewController: OnboardingViewController)
}

class OnboardingViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, OnboardingCellDelegate, Storyboarded {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var promptLabel: UILabel!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var footerView: UIView!
    
    // MARK: - Properties
    fileprivate let reuseIdentifier = "animationCell"
    fileprivate let sectionInsets = UIEdgeInsets(top: 16.0, left: 16.0, bottom: 16.0, right: 16.0)
    fileprivate var itemsPerRow: CGFloat!
    var continueButton: HighlightedButton!
    weak var delegate: OnboardingViewControllerDelegate?
    var viewModel: OnboardingViewModelType?
    var secondColumnXPosition: CGFloat!
    var isLimitReached: Bool = false
   // let trackingController = TrackingController()
    
    func setup(delegate: OnboardingViewControllerDelegate, viewModel: OnboardingViewModelType) {
        self.delegate = delegate
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // trackingController.trackEvent(eventName: "Onboarding - Start")
        view.accessibilityIdentifier = "onboardingView"
        if traitCollection.horizontalSizeClass == .regular {
            itemsPerRow = 2
        } else {
            itemsPerRow = 1
        }
        initViewModel()
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupViewUI()
        setupFonts()
        animateTopView()
        setupContinueButton()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func initViewModel() {
//        mainLabel.text = viewModel?.mainString
//        promptLabel.text = viewModel?.promptString
    }
    
    func setupViewUI() {
//        guard let cells = collectionView.visibleCells as? [OnboardingCell] else {
//            return
//        }
//
//        let screenWidth: CGFloat = UIScreen.main.bounds.width
//
//        if itemsPerRow == 1 {
//            for cell in cells {
//                guard let cellView = cell.cellView else { return }
//                cellView.transform = CGAffineTransform(translationX: screenWidth, y: 0)
//            }
//        } else {
//            var iLoop = 0
//            var cellAFrame: UIView
//            var cellBFrame: UIView?
//
//            while iLoop < cells.count {
//                let cellA = cells[iLoop]
//                cellAFrame = cellA.cellView
//                var cellB: OnboardingCell?
//                if iLoop + 1 < cells.count {
//                    cellB = cells[iLoop+1]
//                }
//                cellBFrame = cellB?.cellView
//                if secondColumnXPosition == nil {
//                    secondColumnXPosition = cellBFrame?.frame.minX
//                }
//                cellAFrame.transform = CGAffineTransform(translationX: screenWidth, y: 0)
//                cellBFrame?.transform = CGAffineTransform(translationX: screenWidth, y: 0)
//                iLoop += 2
//            }
//        }
//        //view.backgroundColor = viewModel?.backgroundColor
//
//        let topViewHeight: CGFloat = topView.bounds.size.height
//        topView.transform = CGAffineTransform(translationX: 0, y: -topViewHeight)
//
//        let footerViewHeight: CGFloat = footerView.bounds.size.height
//        footerView.transform = CGAffineTransform(translationX: 0, y: footerViewHeight)
    }
    
    func setupFonts() {
//        self.mainLabel?.font = FontUtil().getHeaderFont()
//        self.promptLabel?.font = FontUtil().getBodyFont()
//
//        self.mainLabel?.adjustsFontForContentSizeCategory = true
//        self.promptLabel?.adjustsFontForContentSizeCategory = true
    }
    
    func setupContinueButton() {
//        continueButton = HighlightedButton.init(frame: CGRect.init(x: 0, y: 0, width: 200, height: 50), reverse: false, shadow: false)
//        continueButton.setTitle("CONTINUE", for: .normal)
//        continueButton.isEnabled = false
//        continueButton.addTarget(self, action: #selector(OnboardingViewController.continueButtonTouched(_:)), for: .touchUpInside)
//
//        footerView.addSubview(continueButton)
//
//        NSLayoutConstraint.activate([
//            continueButton.centerXAnchor.constraint(equalTo: footerView.centerXAnchor, constant: 0),
//            continueButton.centerYAnchor.constraint(equalTo: footerView.centerYAnchor, constant: -10)])
    }
    
    @objc func updateView(notification _: NSNotification) {
       // setupViewUI()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        
        guard let onboardingCell = cell as? OnboardingCell, let viewModel = viewModel else {
            return cell
        }
        if let cellView = onboardingCell.cellView {
            cellView.transform = CGAffineTransform(translationX: 0, y: 0)
        }
//        let selected = 0
//
//        if !selected && isLimitReached {
//            onboardingCell.canSelect = false
//        } else if selected && isLimitReached {
//            onboardingCell.canSelect = true
//        } else {
//            onboardingCell.canSelect = true
//        }
//
//        onboardingCell.selectCategory(selected, animated: false)
//        onboardingCell.isCellSelected = selected
//
//        let category = 1
//
//        if let image: UIImage = UIImage(named: category.lowercased()) {
//            onboardingCell.backgroundImage.image = image
//        } else {
//            onboardingCell.backgroundImage.image = UIImage(named: "placeholder")
//        }
//
//        onboardingCell.categoryLabel.text = category
        onboardingCell.delegate = self
        
        return onboardingCell
    }
    
    func didPressOnboardingCell(_ sender: OnboardingCell) {
//        guard let tappedIndexPath = collectionView.indexPath(for: sender) else { return }
//        let selectedCell = collectionView.cellForItem(at: tappedIndexPath) as? OnboardingCell
//
//        guard let viewModel = viewModel else {
//            return
//        }
//
//        if viewModel.selectedIndexes.contains(tappedIndexPath) {
//            viewModel.selectedIndexes.remove(tappedIndexPath)
//            selectedCell?.selectCategory(false, animated: true)
//            if isLimitReached && viewModel.selectedIndexes.count == 2 {
//                isLimitReached = false
//                reloadCollectionView(disableCells: false, lastSelectedIndexPath: tappedIndexPath)
//            }
//        } else {
//            if !isLimitReached {
//                viewModel.selectedIndexes.insert(tappedIndexPath)
//                selectedCell?.selectCategory(true, animated: true)
//            }
//            if viewModel.selectedIndexes.count == 3 {
//                isLimitReached = true
//                reloadCollectionView(disableCells: true, lastSelectedIndexPath: tappedIndexPath)
//            }
//        }
//        changeContinueButtonText()
    }
    
    func reloadCollectionView(disableCells: Bool, lastSelectedIndexPath: IndexPath) {
//        let indexPaths = Array(viewModel?.selectedIndexes ?? [])
//
//        let visibleCells = collectionView.indexPathsForVisibleItems
//        var unselectedCells = Set<IndexPath>()
//
//        for indexPath in visibleCells {
//            if !indexPaths.contains(indexPath) {
//                unselectedCells.insert(indexPath)
//            }
//        }
//
//        if !disableCells {
//            unselectedCells.remove(lastSelectedIndexPath)
//        }
//
//        collectionView.reloadItems(at: Array(unselectedCells))

    }
    
    @objc func continueButtonTouched(_ sender: HighlightedButton!) {
//        viewModel?.saveSelectedCategoriesInUserDefaults()
//        delegate?.onboardingDidComplete(for: self)
    }
    
    func changeContinueButtonText() {
//        if let count = viewModel?.selectedIndexes.count, count > 0 {
//            continueButton.isEnabled = true
//            trackingController.trackEvent(eventName: "Onboarding - Continue")
//        } else {
//            continueButton.isEnabled = false
//            trackingController.trackEvent(eventName: "Onboarding - Skip")
//        }
    }
    
    func animateTopView() {
        UIView.animate(withDuration: 0.8,
                       delay: 0.1,
                       usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 0,
                       options: .curveLinear,
                       animations: {
                        self.topView.transform = CGAffineTransform(translationX: 0, y: 0)
        }, completion: { _ in
            self.animateTable()
        })
    }
    
    func animateTable() {
        let visibleCells = collectionView.indexPathsForVisibleItems
            .sorted { left, right -> Bool in
                return left.section < right.section || left.row < right.row
            }.compactMap { indexPath -> UICollectionViewCell? in
                return collectionView.cellForItem(at: indexPath)
        }
        guard let cells = visibleCells as? [OnboardingCell] else {
            return
        }
        var index = 0
        
        var cellAView: UIView
        while index < cells.count {
            let delayTime: Double = 0.26 * Double(index) / Double(itemsPerRow)
            let cellA = cells[index]
            cellAView = cellA.cellView
            animateCellView(cellAView, delayTime, 0)
            
            if itemsPerRow == 2 {
                var cellB: OnboardingCell?
                if index + 1 < cells.count {
                    cellB = cells[index+1]
                }
                
                if let cellBView = cellB?.cellView {
                    animateCellView(cellBView, delayTime, self.secondColumnXPosition)
                }
            }
            index += Int(itemsPerRow)
        }
        let rows = ceil(Double(cells.count) / Double(itemsPerRow))
        animateBottomView((rows - 1.0) * 0.26 + 0.5)
    }
    
    func animateCellView(_ cellView: UIView, _ delay: Double, _ xPosition: CGFloat) {
        UIView.animate(withDuration: 1.5,
                       delay: delay,
                       usingSpringWithDamping: 0.9,
                       initialSpringVelocity: 0,
                       options: .curveLinear,
                       animations: {
                        cellView.transform = CGAffineTransform(translationX: xPosition, y: 0)
                       },
                       completion: nil)
    }
    
    func animateBottomView(_ delay: Double) {
        UIView.animate(withDuration: 0.8,
                       delay: delay,
                       usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 0,
                       options: .curveLinear,
                       animations: {
                        self.footerView.transform = CGAffineTransform(translationX: 0, y: 0)
        }, completion: nil)
    }
}

extension OnboardingViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow - 16
        return CGSize(width: widthPerItem, height: 108)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
}
