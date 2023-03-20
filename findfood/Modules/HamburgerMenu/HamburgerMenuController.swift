//
//  HamburgerMenuController.swift
//  findfood
//
//  Created by Bertay Yönel on 18.03.2023.
//

import UIKit

class HamburgerMenuController: UIViewController {
    
    private lazy var loginButton: UIButton = {
        let loginButton = UIButton(frame: .zero)
        loginButton.addTarget(self, action: #selector(loginClicked), for: .touchUpInside)
        return loginButton
    }()
    
    override func viewDidLoad() {
        super.loadView()
        setupView()
    }
    
    init() {
        super.init(nibName: nil, bundle: .main)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension HamburgerMenuController {
    func setupView() {
        view.addSubview(loginButton)
        
        loginButton.setConstraint(
            top: view.safeAreaLayoutGuide.topAnchor,
            leading: view.safeAreaLayoutGuide.leadingAnchor,
            bottom: view.safeAreaLayoutGuide.bottomAnchor,
            trailing: view.safeAreaLayoutGuide.trailingAnchor,
            topConstraint: .zero,
            leadingConstraint: .zero,
            bottomConstraint: .zero,
            trailingConstraint: .zero
        )
    }
    
    @objc func loginClicked() {
        let loginVC = LogInController()
        navigationController?.pushViewController(loginVC, animated: true)
    }
}
