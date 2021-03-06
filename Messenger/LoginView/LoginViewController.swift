//
//  LoginViewController.swift
//  Messenger
//
//  Created by Олег Федоров on 10.02.2022.
//

import UIKit

class LoginViewController: UIViewController {

    // MARK: - IBOutlets
    // labels
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var repeatPasswordLabel: UILabel!
    @IBOutlet weak var signUpLabel: UILabel!
    
    // textFields
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    
    // buttons
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var resendEmailButton: UIButton!
    
    // views
    @IBOutlet weak var repeatPasswordLineView: UIView!
    
    // MARK: - Variables
    var isLogin = true
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTextFieldDelegates()
        updateUIFor(login: isLogin)
        setupBackgroundTap()
    }
    
    // MARK: - IBActions
    @IBAction func loginButtonPressed(_ sender: Any) {
        if isDataInputedFor(type: isLogin ? "login" : "register") {
            // login or register
            print("DEBUG: have data for login/reg")
            isLogin ? loginUser() : registerUser()
        } else {
            ProgressHUD.showFailed("All Fields are required")
        }
    }
    
    @IBAction func forgotPasswordButtonPressed(_ sender: Any) {
        if isDataInputedFor(type: "password") {
            // reset password
            resetPassword()
        } else {
            ProgressHUD.showFailed("Email is required")
        }
    }

    @IBAction func resendEmailButtonPressed(_ sender: Any) {
        if isDataInputedFor(type: "password") {
            // Resend verification email
            resendVerificationEmail()
        } else {
            ProgressHUD.showFailed("Email is required")
        }
    }
    
    @IBAction func signUpButtonPressed(_ sender: UIButton) {
        updateUIFor(login: sender.titleLabel?.text == "Login")
        isLogin.toggle()
    }
    
    // MARK: - Setup
    private func setupTextFieldDelegates() {
        emailTextField.addTarget(
            self,
            action: #selector(textFieldDidChange(_:)),
            for: .editingChanged
        )
        passwordTextField.addTarget(
            self,
            action: #selector(textFieldDidChange(_:)),
            for: .editingChanged
        )
        repeatPasswordTextField.addTarget(
            self,
            action: #selector(textFieldDidChange(_:)),
            for: .editingChanged
        )
    }
    
    private func setupBackgroundTap() {
        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(backgroundTap)
        )
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        updatePlaceholderLabels(textField: textField)
    }
    
    @objc private func backgroundTap() {
        view.endEditing(false)
    }
    
    // MARK: - Animations
    private func updateUIFor(login: Bool) {
        loginButton.setImage(
            UIImage(named: login ? "loginBtn" : "registerBtn"),
            for: .normal
        )
        signUpButton.setTitle(login ? "Sign Up" : "Login", for: .normal)
        
        signUpLabel.text = login ? "Don't have an accont?" : "Have an accont?"
        
        UIView.animate(withDuration: 0.5) {
            self.repeatPasswordTextField.isHidden = login
            self.repeatPasswordLabel.isHidden = login
            self.repeatPasswordLineView.isHidden = login
        }
    }
    
    private func updatePlaceholderLabels(textField: UITextField) {
        switch textField {
        case emailTextField:
            emailLabel.text = textField.hasText ? "Email" : ""
        case passwordTextField:
            passwordLabel.text = textField.hasText ? "Password" : ""
        default:
            repeatPasswordLabel.text = textField.hasText ? "Repeat password" : ""
        }
    }
    
    // MARK: - Helpers
    private func isDataInputedFor(type: String) -> Bool {
        
        switch type {
        case "login":
            return emailTextField.text != "" && passwordTextField.text != ""
        case "register":
            return emailTextField.text != "" &&
            passwordTextField.text != "" &&
            repeatPasswordTextField.text != ""
        default:
            return emailTextField.text != ""
        }
    }
    
    private func loginUser() {
        
        FirebaseUserListener.shared.loginUserWithEmail(
            email: emailTextField.text ?? "",
            password: passwordTextField.text ?? ""
        ) { error, isEmailVerified in
            
            if error == nil {
                if isEmailVerified {
                    self.goToApp()
                    print("user has logged in with email ", User.currentUser?.email ?? "")
                } else {
                    ProgressHUD.showFailed("Please verify email")
                    self.resendEmailButton.isHidden = false
                }
            } else {
                ProgressHUD.showFailed(error?.localizedDescription)
            }
        }
    }
    
    private func registerUser() {
        
        if passwordTextField.text == repeatPasswordTextField.text {
            
            FirebaseUserListener.shared.registerUserWith(
                email: emailTextField.text ?? "",
                password: passwordTextField.text ?? ""
            ) { error in

                if error == nil {
                    ProgressHUD.showSuccess("Verification email sent.")
                    self.resendEmailButton.isHidden = false
                } else {
                    ProgressHUD.showFailed(error?.localizedDescription)
                }
            }
        } else {
            ProgressHUD.showFailed("The passwords don't match")
        }
    }
    
    private func resetPassword() {
        FirebaseUserListener.shared.resetPasswordFor(
            email: emailTextField.text ?? ""
        ) { error in
            
            if error == nil {
                ProgressHUD.showSuccess("Reset link sent to email.")
            }  else {
                ProgressHUD.showFailed(error?.localizedDescription)
            }
        }
    }
    
    private func resendVerificationEmail() {
        FirebaseUserListener.shared.resendVerificationEmail(
            email: emailTextField.text ?? ""
        ) { error in
            
            if error == nil {
                ProgressHUD.showSuccess("New verification email sent.")
            }  else {
                ProgressHUD.showFailed(error?.localizedDescription)
            }
        }
    }
    
    // MARK: - Navigation
    private func goToApp() {
        
        let mainView = UIStoryboard(
            name: "Main", bundle: nil
        ).instantiateViewController(withIdentifier: "MainApp") as! UITabBarController
        
        mainView.modalPresentationStyle = .fullScreen
        present(mainView, animated: true, completion: nil)
    }
}

