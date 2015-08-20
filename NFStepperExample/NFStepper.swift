//
//  NFStepper.swift
//  NFStepperExample
//
//  Created by Gabor Nagy Farkas on 19/08/15.
//  Copyright (c) 2015 Gabor Nagy Farkas. All rights reserved.
//

import Foundation
import UIKit

enum ValueChangeAnimationStyle {
    case None
    case FadeInOut
    case Horizontal
    case Vertical
}

enum StepperStyle {
    case Flat
    case Rounded
}

enum StepperTheme {
    case Light
    case Dark
}

class NFStepper : UIControl {
    
    // MARK: -
    // MARK: Properties
    
    private(set) var value : Double = 1.0 {
        didSet {
            if(value > maxValue) {
                value = maxValue
            }
            else if(value < minValue) {
                value = minValue
            }
            else
            {
                self.animateValueChange(oldValue, newValue: value)
            }
            
            valueLabel.text = String(format: "%g", value)
        }
    }
    
    var maxValue : Double = 10.0
    var minValue : Double = 0.0
    var stepSize : Double = 1.0
    var animationStyle : ValueChangeAnimationStyle = ValueChangeAnimationStyle.Vertical
    
    var valueTextColor : UIColor = UIColor.darkTextColor() {
        didSet {
            valueLabel.textColor = valueTextColor
        }
    }
    
    var valueFont : UIFont = UIFont.systemFontOfSize(12.0) {
        didSet {
            valueLabel.font = valueFont
        }
    }
    
    var theme : StepperTheme = StepperTheme.Light {
        didSet {
            self.changeTheme()
        }
    }
    
    var style : StepperStyle = StepperStyle.Flat {
        didSet {
            self.changeStyle()
        }
    }
    
    private var labelContainerView : UIView = UIView(frame: CGRectZero)
    private var valueLabel : UILabel = UILabel(frame: CGRectZero)
    private var increaseButton : UIButton = UIButton(frame: CGRectZero)
    private var decreaseButton : UIButton = UIButton(frame: CGRectZero)
    
    private let blueHighlight : UIColor = UIColor(red: 0.0, green: 0.478, blue: 1.0, alpha: 1.0)
    
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
        self.layer.borderColor = blueHighlight.CGColor
        self.layer.borderWidth = 1.0
        self.setupAndAddValueLabel()
        self.setupAndAddButtons()
    }
    
    // MARK: -
    // MARK: Value Label Methods
    
    private func setupAndAddValueLabel() {
        self.setupLabelContainerView()
        self.setupValueLabel()
    }
    
    private func setupLabelContainerView() {
        labelContainerView.setTranslatesAutoresizingMaskIntoConstraints(false)
        labelContainerView.clipsToBounds = true
        self.addSubview(labelContainerView)
        self.setupLabelContainerViewConstraints()
    }
    
    private func setupLabelContainerViewConstraints() {
        var horizontal = NSLayoutConstraint.constraintsWithVisualFormat("H:|-[labelContainerView]", options: NSLayoutFormatOptions(0), metrics: nil, views: ["labelContainerView" : labelContainerView])
        
        var vertical = NSLayoutConstraint.constraintsWithVisualFormat("V:|-[labelContainerView]-|", options: NSLayoutFormatOptions(0), metrics: nil, views: ["labelContainerView" : labelContainerView])
        
        self.addConstraints(horizontal)
        self.addConstraints(vertical)
    }
    
    private func setupValueLabel() {
        valueLabel.backgroundColor = UIColor.whiteColor()
        valueLabel.lineBreakMode = NSLineBreakMode.ByTruncatingTail
        valueLabel.text = String(format: "%g", value)
        valueLabel.textColor = UIColor.darkTextColor()
        valueLabel.font = UIFont.boldSystemFontOfSize(20.0)
        valueLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        self.labelContainerView.addSubview(valueLabel)
        
        self.setupValueLabelConstraints()
    }
    
    private func setupValueLabelConstraints() {
        var horizontal = NSLayoutConstraint.constraintsWithVisualFormat("H:|[valueLabel]|", options: NSLayoutFormatOptions(0), metrics: nil, views: ["valueLabel" : valueLabel])
        
        var vertical = NSLayoutConstraint.constraintsWithVisualFormat("V:|[valueLabel]|", options: NSLayoutFormatOptions(0), metrics: nil, views: ["valueLabel" : valueLabel])
        
        self.addConstraints(horizontal)
        self.addConstraints(vertical)
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
        increaseButton.backgroundColor = UIColor.whiteColor()
        increaseButton.setTitleColor(blueHighlight, forState: UIControlState.Normal)
        increaseButton.layer.borderWidth = 1.0
        increaseButton.layer.borderColor = blueHighlight.CGColor
        increaseButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        increaseButton.addTarget(self, action: "increaseValue:", forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    private func setupDecreaseButton() {
        decreaseButton.setTitle("-", forState: UIControlState.Normal)
        decreaseButton.backgroundColor = UIColor.whiteColor()
        decreaseButton.setTitleColor(blueHighlight, forState: UIControlState.Normal)
        decreaseButton.layer.borderWidth = 1.0
        decreaseButton.layer.borderColor = blueHighlight.CGColor
        decreaseButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        decreaseButton.addTarget(self, action: "decreaseValue:", forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    private func setupButtonConstraints() {
        var horizontal = NSLayoutConstraint.constraintsWithVisualFormat("H:[labelContainerView]-[decreaseButton][increaseButton]-|", options: NSLayoutFormatOptions(0), metrics: nil, views: ["labelContainerView" : labelContainerView, "increaseButton" : increaseButton, "decreaseButton" : decreaseButton])
        
        var verticalIncrease = NSLayoutConstraint.constraintsWithVisualFormat("V:|-[increaseButton]-|", options: NSLayoutFormatOptions(0), metrics: nil, views: ["increaseButton" : increaseButton])
        
        var verticalDecrease = NSLayoutConstraint.constraintsWithVisualFormat("V:|-[decreaseButton]-|", options: NSLayoutFormatOptions(0), metrics: nil, views: ["decreaseButton" : decreaseButton])
        
        self.addConstraints(horizontal)
        self.addConstraints(verticalIncrease)
        self.addConstraints(verticalDecrease)
    }
    
    @objc private func increaseValue(sender : UIButton) {
        value += stepSize
    }
    
    @objc private func decreaseValue(sender : UIButton) {
        value -= stepSize
    }
    
    // MARK: -
    // MARK: Animation
    
    private func animateValueChange(oldValue : Double, newValue : Double) {
        switch animationStyle {
        case .FadeInOut:
            self.fadeInOutAnimation()
        case .Horizontal:
            self.horizontalAnimation(oldValue, newValue: newValue)
        case  .Vertical:
            self.verticalAnimation(oldValue, newValue: newValue)
        default:
            break
        }
    }
    
    private func fadeInOutAnimation() {
        self.valueLabel.alpha = 0.0
        UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            self.valueLabel.alpha = 1.0
            }, completion: nil)
    }
    
    private func horizontalAnimation(oldValue : Double, newValue : Double) {
        var isIncreased : Bool = self.isValueIncreased(oldValue, newValue: newValue)
        
        isIncreased ? (self.valueLabel.frame.origin.x += CGRectGetWidth(self.labelContainerView.frame)) : (self.valueLabel.frame.origin.x -= CGRectGetWidth(self.labelContainerView.frame))
        
        UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            isIncreased ? (self.valueLabel.frame.origin.x -= CGRectGetWidth(self.labelContainerView.frame)) : (self.valueLabel.frame.origin.x += CGRectGetWidth(self.labelContainerView.frame))
            }, completion: nil)
    }
    
    private func verticalAnimation(oldValue : Double, newValue : Double) {
        var isIncreased : Bool = self.isValueIncreased(oldValue, newValue: newValue)
        
        isIncreased ? (self.valueLabel.frame.origin.y -= CGRectGetHeight(self.labelContainerView.frame)) : (self.valueLabel.frame.origin.y += CGRectGetHeight(self.labelContainerView.frame))
        
        
        UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            isIncreased ? (self.valueLabel.frame.origin.y += CGRectGetHeight(self.labelContainerView.frame)) : (self.valueLabel.frame.origin.y -= CGRectGetHeight(self.labelContainerView.frame))
            }, completion: nil)
    }
    
    // MARK: -
    // MARK: Helper methods
    
    private func isValueIncreased(oldValue : Double, newValue : Double) -> Bool {
        return (newValue > oldValue) ? true : false
    }
    
    // MARK: -
    // MARK: Themes
    
    private func changeTheme() {
        switch theme {
        case .Dark:
            self.changeToDarkTheme()
        case .Light:
            self.changeToLightTheme()
        }
    }
    
    private func changeToDarkTheme() {
        
    }
    
    private func changeToLightTheme() {
        
    }
    
    // MARK: -
    // MARK: Styles
    
    private func changeStyle() {
        switch style {
        case .Flat:
            self.changeToFlatStyle()
        case .Rounded:
            self.changeToRoundedStyle()
        }
    }
    
    private func changeToFlatStyle() {
        
    }
    
    private func changeToRoundedStyle() {
        
    }
}
