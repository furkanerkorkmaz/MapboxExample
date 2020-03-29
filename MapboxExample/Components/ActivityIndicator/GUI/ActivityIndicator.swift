//
//  ActivityIndicator.swift
//  MapboxExample
//
//  Created by Michael Liptuga on 28.03.2020.
//  Copyright © 2020 Michael Liptuga. All rights reserved.
//

import UIKit

class ActivityIndicator: UIView {
    
    //MARK: - IBOutlets
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var activityIndicatorContainerView: UIView!

    //MARK: - Properties
    var isAnimating: Bool {
        return self.activityIndicator.isAnimating
    }
    
    class func create() -> ActivityIndicator {
        let view = ActivityIndicator.loadFromNib()
        view.frame = UIScreen.main.bounds
        view.setupView()
        UIApplication.shared.windows.first(where: {$0.isKeyWindow})?.addSubview(view)
        return view
    }
    
    func show() {
        startAnimating()
    }
    
    func close(completion: @escaping EmptyClosure) {
        stopAnimating(completion: completion)
    }

}

// MARK: - Setup functions
fileprivate extension ActivityIndicator {
    
    func setupView () {
        self.activityIndicatorContainerView.layer.cornerRadius = 8.0
        
    }
    
}

// MARK: - Actions
fileprivate extension ActivityIndicator {
    
    func startAnimating() {
        self.activityIndicatorContainerView.alpha = 1.0
        self.activityIndicator.startAnimating()
        let pulse = CABasicAnimation(keyPath: "transform.scale")
        pulse.fromValue = 1.25
        pulse.toValue = 1.0
        pulse.duration = 0.25
        self.activityIndicatorContainerView?.layer.add(pulse, forKey: nil)
    }
    
    func stopAnimating(completion: @escaping EmptyClosure) {
        self.activityIndicator.stopAnimating()
        UIView.animate(withDuration: 0.245, animations: {
            self.activityIndicatorContainerView.alpha = 0.0
        }) { (_) in
            self.removeFromSuperview()
            completion()
        }
    }
    
}
