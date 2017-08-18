//
//  ProgressHUDView.swift
//  ProgressHUD
//
//  Created by igor on 8/17/17.
//  Copyright © 2017 igor. All rights reserved.
//

import UIKit

protocol ProgressHUDViewDelegate: class {
    func progressViewButtonTapped(_ view: ProgressHUDView)
    func progressViewTimerFired(_ view: ProgressHUDView)
}

final class ProgressHUDView: UIView {

    typealias Style = ProgressHUDViewStyleConstants
    
    // MARK: - Outlets
    
    @IBOutlet private weak var arcView: UIView!
    @IBOutlet private weak var timerLabel: UILabel!
    @IBOutlet private weak var actionButton: UIButton!
    
    // MARK: - Private properties
    
    private var view: UIView!
    private var backgroundArcLayer: CALayer?
    private var progressArcLayer: CALayer?
    private var progressTimeInterval: TimeInterval?
    private var counterTimeInterval: TimeInterval = 0.0
    private weak var timer: Timer?
    
    // MARK: - Public properties
    
    internal weak var delegate: ProgressHUDViewDelegate?
    internal var buttonImage: UIImage? {
        didSet {
            actionButton.setImage(buttonImage, for: .normal)
        }
    }
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    
    private func xibSetup() {
        guard subviews.count == 0 else { return }
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
        setupStyle()
    }
    
    private func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: ProgressHUDView.self), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
    
    private func setupStyle() {
        actionButton.backgroundColor = Style.buttonColor
        actionButton.layer.shadowColor = Style.buttonShadowColor.cgColor
        actionButton.layer.shadowRadius = Style.buttonShadowRadius
        actionButton.layer.shadowOpacity = Style.buttonShadowOpacity
        actionButton.layer.shadowOffset = Style.buttonShadowOffset
        timerLabel.font = Style.timerFont
        timerLabel.textColor = Style.timerTextColor
    }
    
    // MARK: - UIView
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        actionButton.layer.cornerRadius = actionButton.bounds.height / 2.0
        
        if backgroundArcLayer == nil {
            drawBackgroundLayer()
        }
        if progressArcLayer == nil,
            let duration = progressTimeInterval {
            drawProgressLayer(duration: duration)
        }
    }
    
    
    private func drawBackgroundLayer() {
        let layer = GradientArcLayer.backgroundArcLayer(in: arcView,
                                                        lineWidth: Style.progressArcWidth,
                                                        color: Style.progressArcBackgroundColor)
        backgroundArcLayer = layer
        arcView.layer.addSublayer(layer)
    }
    
    private func drawProgressLayer(duration: TimeInterval) {
        let layer = GradientArcLayer(in: arcView,
                                     fromColor: Style.progressArcFromColor,
                                     toColor: Style.progressArcToColor,
                                     lineWidth: Style.progressArcWidth)
        progressArcLayer = layer
        arcView.layer.addSublayer(layer)
        layer.animateCircle(duration: duration)
    }
    
    private func stringFromTimeInterval(interval: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.zeroFormattingBehavior = [.pad]
        formatter.allowedUnits = [.minute, .second]
        formatter.unitsStyle = .positional
        return formatter.string(from: interval) ?? ""
    }
    
    private func fireTimer() {
        timer?.invalidate()
        timer = nil
        delegate?.progressViewTimerFired(self)
    }
    
    // MARK: - Public methods
    
    internal func start(timeInterval: TimeInterval) {
        if let progressArcLayer = self.progressArcLayer {
            progressArcLayer.removeFromSuperlayer()
            self.progressArcLayer = nil
        }
        if let timer = self.timer {
            timer.invalidate()
            self.timer = nil
        }
        progressTimeInterval = timeInterval
        timerLabel.text = stringFromTimeInterval(interval: timeInterval)
        setNeedsDisplay()
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer(_:)), userInfo: nil, repeats: true)
    }

    /// Should be called before parent view controller will be dismissed
    internal func prepareForDeinit() {
        timer?.invalidate()
        timer = nil
    }
    
    // MARK: - Actions
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        delegate?.progressViewButtonTapped(self)
    }
    
    @objc private func updateTimer(_ timer: Timer) {
        counterTimeInterval += 1.0
        guard let progressTimeInterval = progressTimeInterval else {
            fireTimer()
            return
        }
        let dif = progressTimeInterval - counterTimeInterval
        guard dif > 0.0 else {
            timerLabel.text = stringFromTimeInterval(interval: 0.0)
            fireTimer()
            return
        }
        timerLabel.text = stringFromTimeInterval(interval: dif)

        print("counting:  \(dif)")
    }
}
