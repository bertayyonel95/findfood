//
//  LogInController.swift
//  findfood
//
//  Created by Bertay Yönel on 18.03.2023.
//

import UIKit

class LogInController: UIViewController {
    
    private lazy var emailField: UITextField = {
        let emailField = UITextField(frame: .zero)
        return emailField
    }()
    
    private lazy var passwordField: UITextField = {
        let passwordField = UITextField(frame: .zero)
        return passwordField
    }()
    
    private lazy var loginButton: UIButton = {
        let loginButton = UIButton(frame: .zero)
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

private extension LogInController {
    func setupView() {
        view.addSubview(emailField)
        view.addSubview(passwordField)
        view.addSubview(loginButton)
        
        emailField.setConstraint(
            top: view.safeAreaLayoutGuide.topAnchor,
            leading: view.leadingAnchor,
            bottom: passwordField.topAnchor,
            trailing: view.leadingAnchor,
            topConstraint: 15.0,
            leadingConstraint: 5.0,
            bottomConstraint: 10.0,
            trailingConstraint: 5.0
        )
        
        passwordField.setConstraint(
            top: emailField.bottomAnchor,
            leading: view.leadingAnchor,
            bottom: loginButton.topAnchor,
            trailing: view.leadingAnchor,
            topConstraint: 15.0,
            leadingConstraint: 5.0,
            bottomConstraint: 10.0,
            trailingConstraint: 5.0
        )
        
        loginButton.setConstraint(
            top: passwordField.bottomAnchor,
            leading: view.leadingAnchor,
            bottom: view.safeAreaLayoutGuide.bottomAnchor,
            trailing: view.leadingAnchor,
            topConstraint: 15.0,
            leadingConstraint: 5.0,
            bottomConstraint: 10.0,
            trailingConstraint: 5.0
        )
    }
    
    @objc func loginClicked() {
        
    }
}
