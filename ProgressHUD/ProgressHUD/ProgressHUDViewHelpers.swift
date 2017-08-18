//
//  ProgressHUDViewHelpers.swift
//  ProgressHUD
//
//  Created by igor on 8/18/17.
//  Copyright © 2017 igor. All rights reserved.
//

import Foundation
import UIKit

final internal class ProgressHUDViewStyleConstants {
    static let progressArcBackgroundColor = UIColor(red: 0.101, green: 0.1245, blue: 0.1744, alpha: 1)
    static let progressArcFromColor = UIColor(red: 0.2729, green: 0.5896, blue: 0.9011, alpha: 1)
    static let progressArcToColor = UIColor(red: 0.2921, green: 0.7446, blue: 0.5975, alpha: 1)
    static let buttonColor = UIColor(red: 0.2287, green: 0.3004, blue: 0.3877, alpha: 1)
    static let buttonShadowColor = UIColor.black
    static let buttonShadowOpacity: Float = 0.8
    static let buttonShadowRadius: CGFloat = 6.0
    static let buttonShadowOffset = CGSize.zero

    static let progressArcWidth: CGFloat = 10.0
    static let timerFont = UIFont(name: "Courier", size: 20.0)
    static let timerTextColor = UIColor.white
}
