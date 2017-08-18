//
//  ViewController.swift
//  ProgressHUD
//
//  Created by igor on 8/17/17.
//  Copyright © 2017 igor. All rights reserved.
//

import UIKit

final class ViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet private weak var progressView: ProgressHUDView!
    
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        progressView.start(timeInterval: 5.0)
        progressView.delegate = self
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let willDeinit = self.isBeingDismissed || self.isMovingFromParentViewController
        if willDeinit {
            progressView.prepareForDeinit()
        }
    }
}

extension ViewController: ProgressHUDViewDelegate {
    internal func progressViewTimerFired(_ view: ProgressHUDView) {
        print("FIRED")
    }
    
    internal func progressViewButtonTapped(_ view: ProgressHUDView) {
        print("BTN TAPPED")
    }
}
