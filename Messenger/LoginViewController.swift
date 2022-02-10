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
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - IBActions
    @IBAction func loginButtonPressed(_ sender: Any) {
    }
    
    @IBAction func forgotPasswordButtonPressed(_ sender: Any) {
    }

    @IBAction func resendEmailButtonPressed(_ sender: Any) {
    }
    
    @IBAction func signUpButtonPressed(_ sender: Any) {
    }
}

