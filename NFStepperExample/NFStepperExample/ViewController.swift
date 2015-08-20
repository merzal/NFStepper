//
//  ViewController.swift
//  NFStepperExample
//
//  Created by Gabor Nagy Farkas on 19/08/15.
//  Copyright (c) 2015 Gabor Nagy Farkas. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var titleLabel : UILabel = UILabel(frame: CGRectZero)
    var stepper : NFStepper = NFStepper(frame: CGRectZero)
    
    // MARK: -
    // MARK: View Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        
        self.setupAndAddTitleLabel()
        self.setupAndAddNFStepper()
    }
    
    // MARK: -
    // MARK: titleLabel Methods
    
    func setupAndAddTitleLabel() {
        self.setupTitleLabel()
        self.view.addSubview(titleLabel)
        self.setupTitleLabelConstraints()
    }
    
    func setupTitleLabel() {
        titleLabel.text = "NFStepper example"
        titleLabel.textAlignment = NSTextAlignment.Center
        titleLabel.textColor = UIColor.darkGrayColor()
        titleLabel.font = UIFont.boldSystemFontOfSize(20.0)
        titleLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
    }
    
    func setupTitleLabelConstraints() {
        var horizontalTitleLabelConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-[titleLabel]-|", options: NSLayoutFormatOptions(0), metrics: nil, views: ["titleLabel" : titleLabel])
        
        var verticalTitleLabelConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|-20-[titleLabel(40)]", options: NSLayoutFormatOptions(0), metrics: nil, views: ["titleLabel" : titleLabel])
        
        self.view.addConstraints(horizontalTitleLabelConstraints)
        self.view.addConstraints(verticalTitleLabelConstraints)
    }
    
    // MARK: -
    // MARK: NFStepper Methods
    
    func setupAndAddNFStepper() {
        stepper.setTranslatesAutoresizingMaskIntoConstraints(false)
        stepper.animationStyle = ValueChangeAnimationStyle.None
        self.view.addSubview(stepper)
        self.setupStepperConstraints()
    }
    
    func setupStepperConstraints() {
        var horizontalStepperConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-[stepper]-|", options: NSLayoutFormatOptions(0), metrics: nil, views: ["stepper" : stepper])
        
        var verticalStepperConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:[titleLabel]-[stepper(40)]", options: NSLayoutFormatOptions(0), metrics: nil, views: ["titleLabel" : titleLabel, "stepper" : stepper])
        
        self.view.addConstraints(horizontalStepperConstraints)
        self.view.addConstraints(verticalStepperConstraints)
    }
    
    // MARK: -
    // MARK: Memory Management Methods
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

