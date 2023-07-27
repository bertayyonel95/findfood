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
    private lazy var userEmailLabel: UILabel = {
        let userEmailLabel = UILabel(frame: .zero)
        userEmailLabel.text = FirebaseManager.shared.user?.email ?? .empty
        userEmailLabel.textColor = .customLabelColor
        return userEmailLabel
    }()
    
    private lazy var favouritesButton: UIButton = {
        let favouritesButton = UIButton(frame: .zero)
        favouritesButton.addTarget(self, action: #selector(favouritesPressed), for: .touchUpInside)
        favouritesButton.backgroundColor = .customSecondaryBackgroundColor
        favouritesButton.setTitle(Constant.ViewText.favouritesTitle, for: .normal)
        favouritesButton.setTitleColor(.customLabelColor, for: .normal)
        favouritesButton.layer.cornerRadius = 8.0
        return favouritesButton
    }()
    
    private lazy var logoutButton: UIButton = {
        let logoutButton = UIButton(frame: .zero)
        logoutButton.addTarget(self, action: #selector(logoutPressed), for: .touchUpInside)
        logoutButton.backgroundColor = .customSecondaryBackgroundColor
        logoutButton.setTitle(Constant.ViewText.logoutTitle, for: .normal)
        logoutButton.setTitleColor(.red, for: .normal)
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
        view.backgroundColor = .customBackgroundColor
        view.addSubview(userEmailLabel)
        view.addSubview(favouritesButton)
        view.addSubview(logoutButton)
        
        userEmailLabel.setConstraint(
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
    
    @objc func logoutPressed() {
        FirebaseManager.shared.signOut()
        self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    @objc func favouritesPressed() {
        ObserverManager.shared.changeStatus(for: ObserverManager.shared.favouritesPressed, with: !ObserverManager.shared.favouritesPressed.value)
        self.dismiss(animated: true)
    }
}
