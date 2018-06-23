//
//  ActivityLoaderView.swift
//  GitHubAssignmentUzair
//
//  Created by Uzair on 6/23/18.
//  Copyright © 2018 uzi. All rights reserved.
//

import UIKit

class ActivityLoaderView: UIView
{
    
    @IBOutlet var activityIndicator: UIActivityIndicatorView?
    var view: UIView!
    @IBOutlet weak var parentView: UIView!
    
    func xibSetup() {
        view = loadViewFromNib()
        addSubview(view)
        parentView.layer.cornerRadius = 10
    }
    
    func loadViewFromNib() -> UIView
    {
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "ActivityLoaderView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
    
    func show(duration: TimeInterval = 0.5)
    {
        view.frame = (UIApplication.shared.keyWindow?.bounds)!
        UIView.animate(withDuration: duration, animations: {
            self.view.alpha = 1.0
            let pulseAnimation:CABasicAnimation = CABasicAnimation(keyPath: "transform.scale");
            pulseAnimation.duration = 0.7;
            pulseAnimation.fromValue = NSNumber(value: 1.0 as Float)
            pulseAnimation.toValue = NSNumber(value: 1.1 as Float);
            pulseAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut);
            pulseAnimation.autoreverses = true;
            pulseAnimation.repeatCount = 2000;
            //self.heartView!.layer.addAnimation(pulseAnimation, forKey: "layerAnimation")
            
        }, completion: nil
        )
    }
    
    func hide(duration: TimeInterval = 0.5) {
        
        UIView.animate(withDuration: duration, animations: {
            self.view.alpha = 0.0;
        },completion: {
            (finished: Bool) -> Void in
            if(finished)
            {
                self.removeFromSuperview()
            }
        })
    }
    
}

