//
//  SystemAlert.swift
//  MapboxExample
//
//  Created by Michael Liptuga on 29.03.2020.
//  Copyright © 2020 Michael Liptuga. All rights reserved.
//

import UIKit

protocol SystemAlert {
   
    func showAlert(with title: String?, message: String?, doneButtonTitle: String?)

}

extension SystemAlert where Self: UIViewController {

    func showAlert(with title: String?, message: String?, doneButtonTitle: String?) {
        let alertController = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        let continueAction = UIAlertAction(title: doneButtonTitle, style: .default)
        alertController.addAction(continueAction)
        present(alertController, animated: true, completion: nil)
    }

}
