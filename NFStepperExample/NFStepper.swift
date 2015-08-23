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
    case Vertical
}

enum StepperStyle {
    case Flat
    case Rounded
}

class NFStepper : UIControl {
    
    // MARK: -
    // MARK: Public Properties
    
    private(set) var value : Double = 1.0 {
        didSet {
            
            sendActionsForControlEvents(UIControlEvents.ValueChanged)
            
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
    var stepValue : Double = 1.0
    var animation : ValueChangeAnimationStyle = ValueChangeAnimationStyle.Vertical
    
    var style : StepperStyle = StepperStyle.Flat {
        didSet {
            self.changeStyle()
        }
    }
    
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
    
    override var backgroundColor : UIColor? {
        didSet {
            valueLabel.backgroundColor = self.backgroundColor
        }
    }
    
    var increaseButtonBackgroundColor : UIColor = UIColor() {
        didSet {
            increaseButton.backgroundColor = increaseButtonBackgroundColor
        }
    }
    
    var decreaseButtonBackgroundColor : UIColor = UIColor() {
        didSet {
            decreaseButton.backgroundColor = decreaseButtonBackgroundColor
        }
    }
    
    var borderColor : UIColor = UIColor() {
        didSet {
            self.layer.borderColor = borderColor.CGColor
            buttonContainer.layer.borderColor = borderColor.CGColor
            buttonSeparator.backgroundColor = borderColor
        }
    }
    
    var increaseButtonTitleColor : UIColor = UIColor() {
        didSet {
            increaseButton.setTitleColor(increaseButtonTitleColor, forState: UIControlState.Normal)
        }
    }
    
    var decreaseButtonTitleColor : UIColor = UIColor() {
        didSet {
            decreaseButton.setTitleColor(decreaseButtonTitleColor, forState: UIControlState.Normal)
        }
    }
    
    // MARK: -
    // MARK: Private Properties
    
    private var labelContainerView : UIView = UIView(frame: CGRectZero)
    private var valueLabel : UILabel = UILabel(frame: CGRectZero)
    private var buttonContainer : UIView = UIView(frame: CGRectZero)
    private var increaseButton : UIButton = UIButton(frame: CGRectZero)
    private var decreaseButton : UIButton = UIButton(frame: CGRectZero)
    private var buttonSeparator : UIView = UIView(frame: CGRectZero)
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
        self.layer.cornerRadius = 1.0
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
        self.setupButtonContainer()
        self.setupIncreaseButton()
        self.setupButtonSeparator()
        self.setupDecreaseButton()
        self.setupButtonConstraints()
    }
    
    private func setupButtonContainer() {
        buttonContainer.setTranslatesAutoresizingMaskIntoConstraints(false)
        buttonContainer.clipsToBounds = true
        buttonContainer.layer.cornerRadius = 1.0
        buttonContainer.layer.borderWidth = 1.0
        buttonContainer.layer.borderColor = blueHighlight.CGColor
        self.addSubview(buttonContainer)
        self.setupButtonContainerConstraints()
    }
    
    private func setupButtonContainerConstraints() {
        var horizontal = NSLayoutConstraint.constraintsWithVisualFormat("H:[labelContainerView]-[buttonContainer(<=90)]-5-|", options: NSLayoutFormatOptions(0), metrics: nil, views: ["labelContainerView" : labelContainerView, "buttonContainer" : buttonContainer])
        
        var vertical = NSLayoutConstraint.constraintsWithVisualFormat("V:|-5-[buttonContainer]-5-|", options: NSLayoutFormatOptions(0), metrics: nil, views: ["buttonContainer" : buttonContainer])
        
        self.addConstraints(horizontal)
        self.addConstraints(vertical)
    }
    
    private func setupButtonSeparator() {
        buttonSeparator.setTranslatesAutoresizingMaskIntoConstraints(false)
        buttonSeparator.backgroundColor = blueHighlight
        buttonContainer.addSubview(buttonSeparator)
    }
    
    private func setupIncreaseButton() {
        increaseButton.setTitle("+", forState: UIControlState.Normal)
        increaseButton.backgroundColor = UIColor.whiteColor()
        increaseButton.titleLabel!.font = UIFont.boldSystemFontOfSize(17.0)
        increaseButton.setTitleColor(blueHighlight, forState: UIControlState.Normal)
        increaseButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        increaseButton.addTarget(self, action: "increaseValue:", forControlEvents: UIControlEvents.TouchUpInside)
        buttonContainer.addSubview(increaseButton)
    }
    
    private func setupDecreaseButton() {
        decreaseButton.setTitle("-", forState: UIControlState.Normal)
        decreaseButton.backgroundColor = UIColor.whiteColor()
        decreaseButton.titleLabel!.font = UIFont.boldSystemFontOfSize(17.0)
        decreaseButton.setTitleColor(blueHighlight, forState: UIControlState.Normal)
        decreaseButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        decreaseButton.addTarget(self, action: "decreaseValue:", forControlEvents: UIControlEvents.TouchUpInside)
        buttonContainer.addSubview(decreaseButton)
    }
    
    private func setupButtonConstraints() {
        var horizontal = NSLayoutConstraint.constraintsWithVisualFormat("H:|[decreaseButton][buttonSeparator(1)][increaseButton]|", options: NSLayoutFormatOptions(0), metrics: nil, views: ["increaseButton" : increaseButton, "buttonSeparator" : buttonSeparator, "decreaseButton" : decreaseButton])
        
        var verticalIncrease = NSLayoutConstraint.constraintsWithVisualFormat("V:|[increaseButton]|", options: NSLayoutFormatOptions(0), metrics: nil, views: ["increaseButton" : increaseButton])
        
        var verticalSeparator = NSLayoutConstraint.constraintsWithVisualFormat("V:|[buttonSeparator]|", options: NSLayoutFormatOptions(0), metrics: nil, views: ["buttonSeparator" : buttonSeparator])
        
        var verticalDecrease = NSLayoutConstraint.constraintsWithVisualFormat("V:|[decreaseButton]|", options: NSLayoutFormatOptions(0), metrics: nil, views: ["decreaseButton" : decreaseButton])
        
        self.addConstraints(horizontal)
        self.addConstraints(verticalIncrease)
        self.addConstraints(verticalSeparator)
        self.addConstraints(verticalDecrease)
    }
    
    @objc private func increaseValue(sender : UIButton) {
        value += stepValue
    }
    
    @objc private func decreaseValue(sender : UIButton) {
        value -= stepValue
    }
    
    // MARK: -
    // MARK: Animation
    
    private func animateValueChange(oldValue : Double, newValue : Double) {
        switch animation {
        case .FadeInOut:
            self.fadeInOutAnimation()
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
    
    private func verticalAnimation(oldValue : Double, newValue : Double) {
        var isIncreased : Bool = self.isValueIncreased(oldValue, newValue: newValue)
        
        var tempLabel : UILabel = self.tempLabelFromLabel(valueLabel)
        self.labelContainerView.addSubview(tempLabel)
        
        isIncreased ? (self.valueLabel.frame.origin.y -= CGRectGetHeight(self.labelContainerView.frame)) : (self.valueLabel.frame.origin.y += CGRectGetHeight(self.labelContainerView.frame))
        
        UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            isIncreased ? (self.valueLabel.frame.origin.y += CGRectGetHeight(self.labelContainerView.frame)) : (self.valueLabel.frame.origin.y -= CGRectGetHeight(self.labelContainerView.frame))
            isIncreased ? (tempLabel.frame.origin.y += CGRectGetHeight(self.labelContainerView.frame)) : (tempLabel.frame.origin.y -= CGRectGetHeight(self.labelContainerView.frame))
            }, completion: {(Bool) in
                tempLabel.removeFromSuperview()
        })
    }
    
    private func tempLabelFromLabel(label : UILabel) -> UILabel {
        var retVal : UILabel = UILabel(frame: label.frame)
        retVal.center = valueLabel.center
        retVal.textColor = valueLabel.textColor
        retVal.text = valueLabel.text
        retVal.font = valueLabel.font
        
        return retVal
    }
    
    // MARK: -
    // MARK: Helper methods
    
    private func isValueIncreased(oldValue : Double, newValue : Double) -> Bool {
        return (newValue > oldValue) ? true : false
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
        buttonContainer.layer.cornerRadius = 1.0
        self.layer.cornerRadius = 1.0
    }
    
    private func changeToRoundedStyle() {
        buttonContainer.layer.cornerRadius = 10.0
        self.layer.cornerRadius = 10.0
    }
}
