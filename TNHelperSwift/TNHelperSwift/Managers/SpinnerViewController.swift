//
//  PMSpinnerViewController.swift
//  TNHelperSwift
//
//  Created by Nallamothu Tharun Kumar on 6/24/19.
//  Copyright © 2019 ATT CDO. All rights reserved.
//

import UIKit

class SpinnerViewController: UIViewController {

    private var spinnerImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white.withAlphaComponent(0.6)
        spinnerImageView = UIImageView(frame: CGRect(x: view.center.x - 25, y: view.center.y - 25, width: 50, height: 50))
        spinnerImageView.image = #imageLiteral(resourceName: "spinner_01")
        spinnerImageView.contentMode = .scaleAspectFit
        spinnerImageView.animationImages = [#imageLiteral(resourceName: "spinner_01"), #imageLiteral(resourceName: "spinner_02"), #imageLiteral(resourceName: "spinner_03"), #imageLiteral(resourceName: "spinner_04"), #imageLiteral(resourceName: "spinner_05"), #imageLiteral(resourceName: "spinner_06"), #imageLiteral(resourceName: "spinner_07"), #imageLiteral(resourceName: "spinner_08"), #imageLiteral(resourceName: "spinner_09"), #imageLiteral(resourceName: "spinner_10"),
                                   #imageLiteral(resourceName: "spinner_11"), #imageLiteral(resourceName: "spinner_12"), #imageLiteral(resourceName: "spinner_13"), #imageLiteral(resourceName: "spinner_14"), #imageLiteral(resourceName: "spinner_15"), #imageLiteral(resourceName: "spinner_16"), #imageLiteral(resourceName: "spinner_17"),#imageLiteral(resourceName: "spinner_18"), #imageLiteral(resourceName: "spinner_19"), #imageLiteral(resourceName: "spinner_20"),
                                   #imageLiteral(resourceName: "spinner_21"), #imageLiteral(resourceName: "spinner_22"), #imageLiteral(resourceName: "spinner_23"), #imageLiteral(resourceName: "spinner_24"), #imageLiteral(resourceName: "spinner_25"), #imageLiteral(resourceName: "spinner_26"), #imageLiteral(resourceName: "spinner_27"), #imageLiteral(resourceName: "spinner_28"), #imageLiteral(resourceName: "spinner_29"), #imageLiteral(resourceName: "spinner_30")]
        spinnerImageView.animationDuration = 1.3
        view.addSubview(spinnerImageView)
    }
    
    func startAnimation() {
        spinnerImageView.startAnimating()
    }
    
    func stopAnimation() {
        spinnerImageView.stopAnimating()
    }
}
