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
    case none
    case fadeInOut
    case vertical
}

enum StepperStyle {
    case flat
    case rounded
}

class NFStepper : UIControl {
    
    // MARK: -
    // MARK: Public Properties
    
    fileprivate(set) var value : Double = 1.0 {
        didSet {
            
            sendActions(for: UIControlEvents.valueChanged)
            
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
    var animation : ValueChangeAnimationStyle = ValueChangeAnimationStyle.vertical
    
    var style : StepperStyle = StepperStyle.flat {
        didSet {
            self.changeStyle()
        }
    }
    
    var valueTextColor : UIColor = UIColor.darkText {
        didSet {
            valueLabel.textColor = valueTextColor
        }
    }
    
    var valueFont : UIFont = UIFont.systemFont(ofSize: 12.0) {
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
            self.layer.borderColor = borderColor.cgColor
            buttonContainer.layer.borderColor = borderColor.cgColor
            buttonSeparator.backgroundColor = borderColor
        }
    }
    
    var increaseButtonTitleColor : UIColor = UIColor() {
        didSet {
            increaseButton.setTitleColor(increaseButtonTitleColor, for: UIControlState())
        }
    }
    
    var decreaseButtonTitleColor : UIColor = UIColor() {
        didSet {
            decreaseButton.setTitleColor(decreaseButtonTitleColor, for: UIControlState())
        }
    }
    
    // MARK: -
    // MARK: Private Properties
    
    fileprivate var labelContainerView : UIView = UIView(frame: CGRect.zero)
    fileprivate var valueLabel : UILabel = UILabel(frame: CGRect.zero)
    fileprivate var buttonContainer : UIView = UIView(frame: CGRect.zero)
    fileprivate var increaseButton : UIButton = UIButton(frame: CGRect.zero)
    fileprivate var decreaseButton : UIButton = UIButton(frame: CGRect.zero)
    fileprivate var buttonSeparator : UIView = UIView(frame: CGRect.zero)
    fileprivate let blueHighlight : UIColor = UIColor(red: 0.0, green: 0.478, blue: 1.0, alpha: 1.0)
    
    // MARK: -
    // MARK: Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupStepper()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupStepper()
    }
    
    // MARK: -
    // MARK: Setup Methods
    
    fileprivate func setupStepper() {
        self.layer.borderColor = blueHighlight.cgColor
        self.layer.borderWidth = 1.0
        self.layer.cornerRadius = 1.0
        self.setupAndAddValueLabel()
        self.setupAndAddButtons()
    }
    
    
    // MARK: -
    // MARK: Value Label Methods
    
    fileprivate func setupAndAddValueLabel() {
        self.setupLabelContainerView()
        self.setupValueLabel()
    }
    
    fileprivate func setupLabelContainerView() {
        labelContainerView.translatesAutoresizingMaskIntoConstraints = false
        labelContainerView.clipsToBounds = true
        self.addSubview(labelContainerView)
        self.setupLabelContainerViewConstraints()
    }
    
    fileprivate func setupLabelContainerViewConstraints() {
        let horizontal = NSLayoutConstraint.constraints(withVisualFormat: "H:|-[labelContainerView]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["labelContainerView" : labelContainerView])
        
        let vertical = NSLayoutConstraint.constraints(withVisualFormat: "V:|-[labelContainerView]-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["labelContainerView" : labelContainerView])
        
        self.addConstraints(horizontal)
        self.addConstraints(vertical)
    }
    
    fileprivate func setupValueLabel() {
        valueLabel.backgroundColor = UIColor.white
        valueLabel.lineBreakMode = NSLineBreakMode.byTruncatingTail
        valueLabel.text = String(format: "%g", value)
        valueLabel.textColor = UIColor.darkText
        valueLabel.font = UIFont.boldSystemFont(ofSize: 20.0)
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.labelContainerView.addSubview(valueLabel)
        
        self.setupValueLabelConstraints()
    }
    
    fileprivate func setupValueLabelConstraints() {
        let horizontal = NSLayoutConstraint.constraints(withVisualFormat: "H:|[valueLabel]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["valueLabel" : valueLabel])
        
        let vertical = NSLayoutConstraint.constraints(withVisualFormat: "V:|[valueLabel]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["valueLabel" : valueLabel])
        
        self.addConstraints(horizontal)
        self.addConstraints(vertical)
    }
    
    // MARK: -
    // MARK: Button Methods
    
    fileprivate func setupAndAddButtons() {
        self.setupButtonContainer()
        self.setupIncreaseButton()
        self.setupButtonSeparator()
        self.setupDecreaseButton()
        self.setupButtonConstraints()
    }
    
    fileprivate func setupButtonContainer() {
        buttonContainer.translatesAutoresizingMaskIntoConstraints = false
        buttonContainer.clipsToBounds = true
        buttonContainer.layer.cornerRadius = 1.0
        buttonContainer.layer.borderWidth = 1.0
        buttonContainer.layer.borderColor = blueHighlight.cgColor
        self.addSubview(buttonContainer)
        self.setupButtonContainerConstraints()
    }
    
    fileprivate func setupButtonContainerConstraints() {
        let horizontal = NSLayoutConstraint.constraints(withVisualFormat: "H:[labelContainerView]-[buttonContainer(<=90)]-5-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["labelContainerView" : labelContainerView, "buttonContainer" : buttonContainer])
        
        let vertical = NSLayoutConstraint.constraints(withVisualFormat: "V:|-5-[buttonContainer]-5-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["buttonContainer" : buttonContainer])
        
        self.addConstraints(horizontal)
        self.addConstraints(vertical)
    }
    
    fileprivate func setupButtonSeparator() {
        buttonSeparator.translatesAutoresizingMaskIntoConstraints = false
        buttonSeparator.backgroundColor = blueHighlight
        buttonContainer.addSubview(buttonSeparator)
    }
    
    fileprivate func setupIncreaseButton() {
        increaseButton.setTitle("+", for: UIControlState())
        increaseButton.backgroundColor = UIColor.white
        increaseButton.titleLabel!.font = UIFont.boldSystemFont(ofSize: 17.0)
        increaseButton.setTitleColor(blueHighlight, for: UIControlState())
        increaseButton.translatesAutoresizingMaskIntoConstraints = false
        increaseButton.addTarget(self, action: #selector(NFStepper.increaseValue(_:)), for: UIControlEvents.touchUpInside)
        buttonContainer.addSubview(increaseButton)
    }
    
    fileprivate func setupDecreaseButton() {
        decreaseButton.setTitle("-", for: UIControlState())
        decreaseButton.backgroundColor = UIColor.white
        decreaseButton.titleLabel!.font = UIFont.boldSystemFont(ofSize: 17.0)
        decreaseButton.setTitleColor(blueHighlight, for: UIControlState())
        decreaseButton.translatesAutoresizingMaskIntoConstraints = false
        decreaseButton.addTarget(self, action: #selector(NFStepper.decreaseValue(_:)), for: UIControlEvents.touchUpInside)
        buttonContainer.addSubview(decreaseButton)
    }
    
    fileprivate func setupButtonConstraints() {
        let horizontal = NSLayoutConstraint.constraints(withVisualFormat: "H:|[decreaseButton][buttonSeparator(1)][increaseButton]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["increaseButton" : increaseButton, "buttonSeparator" : buttonSeparator, "decreaseButton" : decreaseButton])
        
        let verticalIncrease = NSLayoutConstraint.constraints(withVisualFormat: "V:|[increaseButton]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["increaseButton" : increaseButton])
        
        let verticalSeparator = NSLayoutConstraint.constraints(withVisualFormat: "V:|[buttonSeparator]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["buttonSeparator" : buttonSeparator])
        
        let verticalDecrease = NSLayoutConstraint.constraints(withVisualFormat: "V:|[decreaseButton]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["decreaseButton" : decreaseButton])
        
        self.addConstraints(horizontal)
        self.addConstraints(verticalIncrease)
        self.addConstraints(verticalSeparator)
        self.addConstraints(verticalDecrease)
    }
    
    @objc fileprivate func increaseValue(_ sender : UIButton) {
        value += stepValue
    }
    
    @objc fileprivate func decreaseValue(_ sender : UIButton) {
        value -= stepValue
    }
    
    // MARK: -
    // MARK: Animation
    
    fileprivate func animateValueChange(_ oldValue : Double, newValue : Double) {
        switch animation {
        case .fadeInOut:
            self.fadeInOutAnimation()
        case  .vertical:
            self.verticalAnimation(oldValue, newValue: newValue)
        default:
            break
        }
    }
    
    fileprivate func fadeInOutAnimation() {
        self.valueLabel.alpha = 0.0
        UIView.animate(withDuration: 0.3, delay: 0.0, options: UIViewAnimationOptions(), animations: {
            self.valueLabel.alpha = 1.0
            }, completion: nil)
    }
    
    fileprivate func verticalAnimation(_ oldValue : Double, newValue : Double) {
        let isIncreased : Bool = self.isValueIncreased(oldValue, newValue: newValue)
        
        let tempLabel : UILabel = self.tempLabelFromLabel(valueLabel)
        self.labelContainerView.addSubview(tempLabel)
        
        isIncreased ? (self.valueLabel.frame.origin.y -= self.labelContainerView.frame.height) : (self.valueLabel.frame.origin.y += self.labelContainerView.frame.height)
        
        UIView.animate(withDuration: 0.3, delay: 0.0, options: UIViewAnimationOptions(), animations: {
            isIncreased ? (self.valueLabel.frame.origin.y += self.labelContainerView.frame.height) : (self.valueLabel.frame.origin.y -= self.labelContainerView.frame.height)
            isIncreased ? (tempLabel.frame.origin.y += self.labelContainerView.frame.height) : (tempLabel.frame.origin.y -= self.labelContainerView.frame.height)
            }, completion: {(Bool) in
                tempLabel.removeFromSuperview()
        })
    }
    
    fileprivate func tempLabelFromLabel(_ label : UILabel) -> UILabel {
        let retVal : UILabel = UILabel(frame: label.frame)
        retVal.center = valueLabel.center
        retVal.textColor = valueLabel.textColor
        retVal.text = valueLabel.text
        retVal.font = valueLabel.font
        
        return retVal
    }
    
    // MARK: -
    // MARK: Helper methods
    
    fileprivate func isValueIncreased(_ oldValue : Double, newValue : Double) -> Bool {
        return (newValue > oldValue) ? true : false
    }
    
    // MARK: -
    // MARK: Styles
    
    fileprivate func changeStyle() {
        switch style {
        case .flat:
            self.changeToFlatStyle()
        case .rounded:
            self.changeToRoundedStyle()
        }
    }
    
    fileprivate func changeToFlatStyle() {
        buttonContainer.layer.cornerRadius = 1.0
        self.layer.cornerRadius = 1.0
    }
    
    fileprivate func changeToRoundedStyle() {
        buttonContainer.layer.cornerRadius = 10.0
        self.layer.cornerRadius = 10.0
    }
}
