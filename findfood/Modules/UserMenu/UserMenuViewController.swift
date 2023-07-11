//
//  UserMenuViewController.swift
//  findfood
//
//  Created by Bertay Yönel on 8.07.2023.
//

import UIKit
// MARK: - UserMenuViewController
class UserMenuViewController: UIViewController {
    // MARK: Views
    private lazy var userEmailTextField: UITextField = {
        let userEmailTextField = UITextField(frame: .zero)
        userEmailTextField.text = FirebaseManager.shared.user?.email ?? ""
        userEmailTextField.textColor = .customTextColor
        return userEmailTextField
    }()
    
    private lazy var logoutButton: UIButton = {
        let logoutButton = UIButton(frame: .zero)
        logoutButton.addTarget(self, action: #selector(logoutClicked), for: .touchUpInside)
        logoutButton.backgroundColor = .systemGray
        logoutButton.setTitle("Logout", for: .normal)
        return logoutButton
    }()
    // MARK: viewDidLoad
    override func viewDidLoad() {
        super.loadView()
        setupView()
    }
    // MARK: init
    init() {
        super.init(nibName: nil, bundle: .main)
        navigationItem.title = "User"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension UserMenuViewController {
    // MARK: Functions
    func setupView() {
        view.backgroundColor = .customBackgroundColor
        view.addSubview(userEmailTextField)
        view.addSubview(logoutButton)
        
        userEmailTextField.setConstraint(
            top: view.topAnchor,
            leading: view.leadingAnchor,
            topConstraint: 55,
            leadingConstraint: 15
        )
        
        logoutButton.setConstraint(
            bottom: view.bottomAnchor,
            bottomConstraint: 35,
            centerX: view.centerXAnchor,
            width: 100.0,
            height: 50.0
        )
    }
    
    @objc func logoutClicked() {
        FirebaseManager.shared.userSignOut()
        self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
    }
}
