//
//  LogInController.swift
//  findfood
//
//  Created by Bertay Yönel on 18.03.2023.
//

import UIKit
// MARK: - LogInController
class LogInController: UIViewController {
    // MARK: Properties
    var oldFrameY: CGFloat = 0.0
    private var viewModel: LoginViewModelInput
    private var keyboardIsPresent: Bool = false
    // MARK: Views
    private lazy var emailField: UITextField = {
        let emailField = UITextField(frame: .zero)
        emailField.backgroundColor = .systemGray
        emailField.autocapitalizationType = .none
        emailField.autocorrectionType = .no
        emailField.keyboardType = .emailAddress
        return emailField
    }()
    
    private lazy var passwordField: UITextField = {
        let passwordField = UITextField(frame: .zero)
        passwordField.backgroundColor = .systemGray
        passwordField.autocapitalizationType = .none
        passwordField.autocorrectionType = .no
        return passwordField
    }()
    
    private lazy var loginButton: UIButton = {
        let loginButton = UIButton(frame: .zero)
        loginButton.backgroundColor = .systemGray
        loginButton.addTarget(self, action: #selector(loginClicked), for: .touchUpInside)
        loginButton.setTitle("Login", for: .normal)
        return loginButton
    }()
    
    private lazy var signupButton: UIButton = {
        let signupButton = UIButton(frame: .zero)
        signupButton.backgroundColor = .systemGray
        signupButton.addTarget(self, action: #selector(signupClicked), for: .touchUpInside)
        signupButton.setTitle("Sign Up", for: .normal)
        return signupButton
    }()
    // MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(keyboardWillHide))
        tapGesture.numberOfTapsRequired = 1
        view.addGestureRecognizer(tapGesture)
        setupView()
        setupKeyboardHiding()
    }
    // MARK: init
    init(viewModel: LoginViewModelInput) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: .main)
        self.viewModel.output = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension LogInController {
    // MARK: Functions
    func setupView() {
        view.backgroundColor = .customBackgroundColor
        view.addSubview(emailField)
        view.addSubview(passwordField)
        view.addSubview(loginButton)
        view.addSubview(signupButton)
        
        emailField.setConstraint(
            top: view.safeAreaLayoutGuide.topAnchor,
            leading: view.leadingAnchor,
            trailing: view.trailingAnchor,
            topConstraint: 120.0,
            leadingConstraint: 45.0,
            trailingConstraint: 45.0,
            height: 50.0
        )
        
        passwordField.setConstraint(
            top: emailField.bottomAnchor,
            leading: view.leadingAnchor,
            trailing: view.trailingAnchor,
            topConstraint: 25.0,
            leadingConstraint: 45.0,
            trailingConstraint: 45.0,
            height: 50.0
        )

        loginButton.setConstraint(
            top: passwordField.bottomAnchor,
            topConstraint: 15.0,
            bottomConstraint: 10.0,
            centerX: view.centerXAnchor
        )
        
        signupButton.setConstraint(
            top: loginButton.bottomAnchor,
            topConstraint: 15.0,
            bottomConstraint: 10.0,
            centerX: view.centerXAnchor
        )
    }
    
    @objc func loginClicked() {
        viewModel.logInUser(email: emailField.text ?? " ", password: passwordField.text ?? " ")
        self.view.endEditing(true)
    }
    
    @objc func signupClicked() {
        viewModel.registerUser(email: emailField.text ?? " ", password: passwordField.text ?? " ")
        self.view.endEditing(true)
    }
    
    @objc func touchOutsideTextField() {
        self.view.endEditing(true)
    }
}

private extension LogInController {
    
    func setupKeyboardHiding() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
           NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(sender: NSNotification) {
        keyboardIsPresent = true
        guard let userInfo = sender.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
              let currentTextField = UIResponder.currentFirst() as? UITextField else { return }
        
        let keyboardTopY = keyboardFrame.cgRectValue.origin.y
        let convertedTextFieldFrame = view.convert(signupButton.frame, to: view.superview?.superview)
        let textFieldBottomY = convertedTextFieldFrame.origin.y + convertedTextFieldFrame.size.height
        
        if textFieldBottomY > keyboardTopY {
            let textBoxY = convertedTextFieldFrame.origin.y
            let newFrameY = ( (textBoxY - keyboardTopY) / 4 ) * -1
            oldFrameY = view.frame.origin.y
            view.frame.origin.y = newFrameY
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if keyboardIsPresent {
            self.view.endEditing(true)
            self.view.frame.origin.y = oldFrameY
            keyboardIsPresent = false
        }
    }
}
// MARK: - LoginViewModelOutput
extension LogInController: LoginViewModelOutput {
    func showErrorMessage(errorMessage: String) {
        ErrorMessageManager.shared.showErrorMessage(in: self, title: "Error", errorMessage: errorMessage, actions: [])
    }
    
    func popController() {
        self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
    }
}
