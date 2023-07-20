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
        userEmailTextField.text = FirebaseManager.shared.user?.email ?? .empty
        userEmailTextField.textColor = UIColor(named: "CustomLabel")
        return userEmailTextField
    }()
    
    private lazy var favouritesButton: UIButton = {
        let favouritesButton = UIButton(frame: .zero)
        favouritesButton.addTarget(self, action: #selector(favouritesClicked), for: .touchUpInside)
        favouritesButton.backgroundColor = UIColor(named: "CustomSecondaryBackground")
        favouritesButton.setTitle(Constant.ViewText.favouritesTitle, for: .normal)
        favouritesButton.setTitleColor(UIColor(named: "CustomLabel"), for: .normal)
        favouritesButton.layer.cornerRadius = 8.0
        return favouritesButton
    }()
    
    private lazy var logoutButton: UIButton = {
        let logoutButton = UIButton(frame: .zero)
        logoutButton.addTarget(self, action: #selector(logoutClicked), for: .touchUpInside)
        logoutButton.backgroundColor = UIColor(named: "CustomSecondaryBackground")
        logoutButton.setTitle(Constant.ViewText.logoutTitle, for: .normal)
        logoutButton.setTitleColor(UIColor(named: "CustomLabel"), for: .normal)
        logoutButton.layer.cornerRadius = 8.0
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
        navigationItem.title = Constant.ViewText.userTitle
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension UserMenuViewController {
    // MARK: Helpers
    func setupView() {
        view.backgroundColor = UIColor(named: "CustomBackground")
        view.addSubview(userEmailTextField)
        view.addSubview(favouritesButton)
        view.addSubview(logoutButton)
        
        userEmailTextField.setConstraint(
            top: view.topAnchor,
            leading: view.leadingAnchor,
            topConstraint: 55,
            leadingConstraint: 15
        )
        
        favouritesButton.setConstraint(
            centerX: view.centerXAnchor,
            centerY: view.centerYAnchor,
            width: 140.0,
            height: 44.0
        )
        
        logoutButton.setConstraint(
            bottom: view.bottomAnchor,
            bottomConstraint: 35,
            centerX: view.centerXAnchor,
            width: 140.0,
            height: 44.0
        )
    }
    
    @objc func logoutClicked() {
        FirebaseManager.shared.userSignOut()
        self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    @objc func favouritesClicked() {
        ObserverManager.shared.changeStatus(for: ObserverManager.shared.favouritesClicked, with: !ObserverManager.shared.favouritesClicked.value)
        self.dismiss(animated: true)
    }
}
