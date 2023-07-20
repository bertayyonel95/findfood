//
//  HamburgerMenuController.swift
//  findfood
//
//  Created by Bertay Yönel on 18.03.2023.
//

import UIKit
// MARK: - SideMenuController
class SideMenuController: UIViewController {
    // MARK: Properties
    lazy var slideInPresentationManager = SlideInPresentationManager()
    // MARK: Views
    private lazy var containerView: UIView = {
        let containerView = UIView(frame: .zero)
        return containerView
    }()
    
    private lazy var shouldLoginTextField: UILabel = {
        let shouldLoginTextField = UILabel(frame: .zero)
        shouldLoginTextField.textColor = .label
        shouldLoginTextField.numberOfLines = 0
        shouldLoginTextField.lineBreakMode = .byWordWrapping
        shouldLoginTextField.textAlignment = .center
        shouldLoginTextField.layer.cornerRadius = 8.0
        shouldLoginTextField.textColor = UIColor(named: "CustomLabel")
        shouldLoginTextField.text = Constant.MessageString.notLoggedIn
        return shouldLoginTextField
    }()
    
    private lazy var loginButton: UIButton = {
        let loginButton = UIButton(frame: .zero)
        loginButton.addTarget(self, action: #selector(loginClicked), for: .touchUpInside)
        loginButton.backgroundColor = UIColor(named: "CustomSecondaryBackground")
        loginButton.setTitle(Constant.ViewText.logInTitle, for: .normal)
        loginButton.setTitleColor(UIColor(named: "CustomLabel"), for: .normal)
        loginButton.layer.cornerRadius = 8.0
        return loginButton
    }()
    // MARK: viewDidLoad
    override func viewDidLoad() {
        super.loadView()
        setupView()
    }
    // MARK: init
    init() {
        super.init(nibName: nil, bundle: .main)
        navigationItem.title = Constant.ViewText.logInTitle
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension SideMenuController {
    // MARK: Helpers
    func setupView() {
        view.backgroundColor = UIColor(named: "CustomBackground")
        view.addSubview(loginButton)
        view.addSubview(shouldLoginTextField)
        
        loginButton.setConstraint(
            top: shouldLoginTextField.bottomAnchor,
            topConstraint: 25,
            leadingConstraint: .zero,
            bottomConstraint: .zero,
            trailingConstraint: .zero,
            centerX: view.centerXAnchor,
            width: 140.0,
            height: 44.0
        )
        
        shouldLoginTextField.setConstraint(
            leading: view.leadingAnchor,
            trailing: view.trailingAnchor,
            topConstraint: .zero,
            leadingConstraint: 25,
            bottomConstraint: .zero,
            trailingConstraint: 25,
            centerX: view.centerXAnchor,
            centerY: view.centerYAnchor
        )
    }
    
    @objc func loginClicked() {
        let loginViewModel = LoginViewModel()
        let loginVC = LogInController(viewModel: loginViewModel)
        slideInPresentationManager.direction = .bottom
        loginVC.transitioningDelegate = slideInPresentationManager
        loginVC.modalPresentationStyle = .custom
        self.present(loginVC, animated: true, completion: nil)
    }
    
    @objc func logoutClicked() {
        FirebaseManager.shared.userSignOut()
        self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
    }
}
