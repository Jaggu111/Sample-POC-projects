//
//  ViewController.swift
//  TNHelperSwift
//
//  Created by Nallamothu Tharun Kumar on 6/24/19.
//  Copyright © 2019 ATT CDO. All rights reserved.
//

import UIKit

class ViewController: UIViewController, Storyboarded {
    weak var coordinator: AppCoordinator?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func byuapped(_ sender: Any) {
        coordinator?.buySub()
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        coordinator?.loginSub()
    }
}

