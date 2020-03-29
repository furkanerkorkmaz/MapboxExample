//
//  UIConfigurator.swift
//  MapboxExample
//
//  Created by Michael Liptuga on 29.03.2020.
//  Copyright © 2020 Michael Liptuga. All rights reserved.
//

import UIKit

final class UIConfigurator {

    static func makeSaveBarButton() -> UIBarButtonItem {
        let button: UIButton = UIButton(type: .system)
        button.setTitle(L10n.saveButtonTitle, for: .normal)
        button.contentEdgeInsets.right = 4
        button.setTitleColor(Asset.commonBlack.color, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.sizeToFit()
        return UIBarButtonItem(customView: button)
    }

    static func makeRemoveBarButton() -> UIBarButtonItem {
        let button: UIButton = createButton(with: Asset.trashIcon.image, tintColor: Asset.commonBlack.color)
        button.contentHorizontalAlignment = .left
        button.contentEdgeInsets.left = 4
        return UIBarButtonItem(customView: button)
    }
    
    static func makeUndoBarButton() -> UIBarButtonItem {
        let button: UIButton = createButton(with: Asset.undoIcon.image, tintColor: Asset.commonBlack.color)
        button.contentHorizontalAlignment = .left
        button.contentEdgeInsets.left = 4
        return UIBarButtonItem(customView: button)
    }

    private static func createButton(with image: UIImage?, buttonType: UIButton.ButtonType = .system, tintColor: UIColor? = nil) -> UIButton {

        let button: UIButton = UIButton(type: buttonType)

        button.setImage(image, for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        button.frame = CGRect(x: 0, y: 0, width: 40, height: 40)

        if let tintColor: UIColor = tintColor {
            button.tintColor = tintColor
        }

        return button
    }

}
