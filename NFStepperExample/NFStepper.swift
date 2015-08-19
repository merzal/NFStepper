//
//  NFStepper.swift
//  NFStepperExample
//
//  Created by Gabor Nagy Farkas on 19/08/15.
//  Copyright (c) 2015 Gabor Nagy Farkas. All rights reserved.
//

import Foundation
import UIKit

class NFStepper : UIControl
{
    // MARK: -
    // MARK: Properties
    
    private(set) var value : Double = 1.0 {
        didSet {
            if(value > maxValue) {
                value = maxValue
            }
            else if(value < minValue) {
                self.value = minValue
            }
            valueLabel.text = String(format: "%g", value)
        }
    }
    
    var maxValue : Double = 10.0
    var minValue : Double = 0.0
    var stepSize : Double = 1.0
    
    private var valueLabel : UILabel = UILabel(frame: CGRectZero)
    private var increaseButton : UIButton = UIButton(frame: CGRectZero)
    private var decreaseButton : UIButton = UIButton(frame: CGRectZero)
    
    enum ValueChangeAnimationStyle {
        case ValueChangeAnimationStyleHorizontal
        case ValueChangeAnimationStyleVertical
    }
    
    // MARK: -
    // MARK: Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupStepper()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupStepper()
    }
    
    // MARK: -
    // MARK: Setup Methods
    
    private func setupStepper() {
        self.backgroundColor = UIColor.darkGrayColor()
        self.setupAndAddValueLabel()
        self.setupAndAddButtons()
    }
    
    // MARK: -
    // MARK: Value Label Methods
    
    private func setupAndAddValueLabel() {
        self.setupValueLabel()
        self.addSubview(valueLabel)
        self.setupValueLabelConstraints()
    }
    
    private func setupValueLabel() {
        valueLabel.backgroundColor = UIColor.lightGrayColor()
        valueLabel.text = String(format: "%g", value)
        valueLabel.textColor = UIColor.darkGrayColor()
        valueLabel.font = UIFont.boldSystemFontOfSize(20.0)
        valueLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
    }
    
    private func setupValueLabelConstraints() {
        var horizontalValueLabelConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-[valueLabel]", options: NSLayoutFormatOptions(0), metrics: nil, views: ["valueLabel" : valueLabel])
        
        var verticalValueLabelConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|-[valueLabel]-|", options: NSLayoutFormatOptions(0), metrics: nil, views: ["valueLabel" : valueLabel])
        
        self.addConstraints(horizontalValueLabelConstraints)
        self.addConstraints(verticalValueLabelConstraints)
    }
    
    // MARK: -
    // MARK: Button Methods
    
    private func setupAndAddButtons() {
        self.setupIncreaseButton()
        self.addSubview(increaseButton)
        self.setupDecreaseButton()
        self.addSubview(decreaseButton)
        self.setupButtonConstraints()
    }
    
    private func setupIncreaseButton() {
        increaseButton.setTitle("+", forState: UIControlState.Normal)
        increaseButton.backgroundColor = UIColor.greenColor()
        increaseButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        increaseButton.addTarget(self, action: "increaseValue:", forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    private func setupDecreaseButton() {
        decreaseButton.setTitle("-", forState: UIControlState.Normal)
        decreaseButton.backgroundColor = UIColor.redColor()
        decreaseButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        decreaseButton.addTarget(self, action: "decreaseValue:", forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    private func setupButtonConstraints() {
        var horizontalButtonConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:[valueLabel]-[increaseButton][decreaseButton]-|", options: NSLayoutFormatOptions(0), metrics: nil, views: ["valueLabel" : valueLabel, "increaseButton" : increaseButton, "decreaseButton" : decreaseButton])
        
        var verticalIncreaseButtonConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|-[increaseButton]-|", options: NSLayoutFormatOptions(0), metrics: nil, views: ["increaseButton" : increaseButton])
        
        var verticalDecreaseButtonConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|-[decreaseButton]-|", options: NSLayoutFormatOptions(0), metrics: nil, views: ["decreaseButton" : decreaseButton])
        
        self.addConstraints(horizontalButtonConstraints)
        self.addConstraints(verticalIncreaseButtonConstraints)
        self.addConstraints(verticalDecreaseButtonConstraints)
    }
    
    @objc private func increaseValue(sender : UIButton) {
        value += stepSize
    }
    
    @objc private func decreaseValue(sender : UIButton) {
        value -= stepSize
    }
}
