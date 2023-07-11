//
//  UIViewController+Extension.swift
//  findfood
//
//  Created by Bertay Yönel on 28.03.2023.
//

import UIKit

extension UIViewController {
    func presentDetail(_ viewControllerToPresent: UIViewController) {
        let transition = CATransition()
        viewControllerToPresent.modalPresentationStyle = .overCurrentContext
        transition.duration = 0.25
        transition.type = .push
        transition.subtype = .fromLeft
        self.view.window!.layer.add(transition, forKey: kCATransition)
        present(viewControllerToPresent, animated: false)
      }
    
    func dismissDetail() {
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = .push
        transition.subtype = .fromRight
        self.view.window!.layer.add(transition, forKey: kCATransition)
        dismiss(animated: false)
      }
}
