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
    var styleSegment : UISegmentedControl = UISegmentedControl(items: ["Flat", "Round"])
    var animationSegment : UISegmentedControl = UISegmentedControl(items: ["None", "Vertical", "FadeInOut"])
    
    // MARK: -
    // MARK: View Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        
        self.setupAndAddTitleLabel()
        self.setupAndAddNFStepper()
        self.setupSegmentedControls()
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
        stepper.animation = ValueChangeAnimationStyle.None
        self.view.addSubview(stepper)
        self.setupStepperConstraints()
    }
    
    func setupStepperConstraints() {
        var horizontalStepperConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-[stepper]-|", options: NSLayoutFormatOptions(0), metrics: nil, views: ["stepper" : stepper])
        
        var verticalStepperConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:[titleLabel]-[stepper(60)]", options: NSLayoutFormatOptions(0), metrics: nil, views: ["titleLabel" : titleLabel, "stepper" : stepper])
        
        self.view.addConstraints(horizontalStepperConstraints)
        self.view.addConstraints(verticalStepperConstraints)
    }
    
    // MARK: -
    // MARK: Segmented Control Methods
    
    func setupSegmentedControls() {
        
        var animationLabel : UILabel = UILabel(frame: CGRectZero)
        animationLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        animationLabel.textAlignment = NSTextAlignment.Center
        animationLabel.text = "Animation"
        self.view.addSubview(animationLabel)
        
        animationSegment.setTranslatesAutoresizingMaskIntoConstraints(false)
        animationSegment.selectedSegmentIndex = 0
        animationSegment.addTarget(self, action: "selectionIndexChanged:", forControlEvents: UIControlEvents.ValueChanged)
        self.view.addSubview(animationSegment)
        
        var styleLabel : UILabel = UILabel(frame: CGRectZero)
        styleLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        styleLabel.textAlignment = NSTextAlignment.Center
        styleLabel.text = "Style"
        self.view.addSubview(styleLabel)
        
        styleSegment.setTranslatesAutoresizingMaskIntoConstraints(false)
        styleSegment.selectedSegmentIndex = 0
        styleSegment.addTarget(self, action: "selectionIndexChanged:", forControlEvents: UIControlEvents.ValueChanged)
        self.view.addSubview(styleSegment)
        
        var horizontalAL = NSLayoutConstraint.constraintsWithVisualFormat("H:|-[animationLabel]-|", options: NSLayoutFormatOptions(0), metrics: nil, views: ["animationLabel" : animationLabel])
        
        var horizontalAS = NSLayoutConstraint.constraintsWithVisualFormat("H:|-[animationSegment]-|", options: NSLayoutFormatOptions(0), metrics: nil, views: ["animationSegment" : animationSegment])
        
        var horizontalSL = NSLayoutConstraint.constraintsWithVisualFormat("H:|-[styleSegment]-|", options: NSLayoutFormatOptions(0), metrics: nil, views: ["styleSegment" : styleSegment])
        
        var horizontalSS = NSLayoutConstraint.constraintsWithVisualFormat("H:|-[styleLabel]-|", options: NSLayoutFormatOptions(0), metrics: nil, views: ["styleLabel" : styleLabel])
        
        var vertical = NSLayoutConstraint.constraintsWithVisualFormat("V:[stepper]-50-[animationLabel]-[animationSegment]-[styleLabel]-[styleSegment]", options: NSLayoutFormatOptions(0), metrics: nil, views: ["animationLabel" : animationLabel, "stepper" : stepper, "animationSegment" : animationSegment, "styleLabel" : styleLabel, "styleSegment" : styleSegment])
        
        self.view.addConstraints(horizontalAL)
        self.view.addConstraints(horizontalAS)
        self.view.addConstraints(horizontalSL)
        self.view.addConstraints(horizontalSS)

        self.view.addConstraints(vertical)
    }
    
    func selectionIndexChanged(sender : UISegmentedControl) {
        if(sender.isEqual(animationSegment)) {
            switch sender.selectedSegmentIndex {
            case 0:
                stepper.animation = ValueChangeAnimationStyle.None
            case 1:
                stepper.animation = ValueChangeAnimationStyle.Vertical
            case 2:
                stepper.animation = ValueChangeAnimationStyle.FadeInOut
            default:
                break
            }
        }
        else if(sender.isEqual(styleSegment)) {
            switch sender.selectedSegmentIndex {
            case 0:
                stepper.style = StepperStyle.Flat
            case 1:
                stepper.style = StepperStyle.Rounded
            default:
                break
            }
        }
    }
    
    // MARK: -
    // MARK: Memory Management Methods
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}