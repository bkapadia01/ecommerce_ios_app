//
//  LoginViewController.swift
//  e_commerce_app
//
//  Created by Bhavin Kapadia on 2022-09-04.
//

import Foundation
import UIKit
import CoreData

class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginErrorLabel: UILabel?
    
    @IBOutlet weak var loginUsernameField: UITextField!
    
    @IBOutlet weak var loginPasswordField: UITextField!
    
    private let loginViewModel = LoginViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        loginErrorLabel?.alpha = 0 // hide error label
        setupBinder()
    }
    
    @IBAction func signInButtonTapped(_ sender: Any) {
        
        validateSignInFields()
    }
    
    private func setupBinder() {
        loginViewModel.error.bind { [weak self] error in
            if let error = error {
                print(error)
            } else {
                self?.goToHomePage()
            }
        }
    }
    
    private func validateSignInFields() -> String? {
        if  loginUsernameField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Please enter a username"
        }
        
        if
            loginPasswordField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Please enter a password"
        }
        
        return nil
    }
    
    
    
    private func loginCredentialsValid() -> String? {
        
            let usernameEntered = loginUsernameField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let passwordEntered = loginPasswordField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if loginViewModel.login(username: usernameEntered, password: passwordEntered) == nil {
        
         return "failed"
        }
        return nil
        
    }
    
    private func goToHomePage() {
        let controller = storyboard?.instantiateViewController(withIdentifier: Constants.Stroyboard.homeViewController) as? HomeViewController
        
//        present(controller, animated: true)
    }
    
    @IBAction func signInButton(_ sender: UIButton) {
        
        let loginFieldsErrorExists = validateSignInFields()
        let loginCredentialsValid = loginCredentialsValid()

        if loginFieldsErrorExists != nil || loginCredentialsValid != nil {
            showErrorMessaage(loginFieldsErrorExists!)
            return
        } else  {
            
            guard let fetchRegistredUserLogin = loginViewModel.fetchRegisteredUser(username: loginUsernameField.text!.trimmingCharacters(in: .whitespacesAndNewlines)) else {
                showErrorMessaage("Invalid Credentials!")
                return
            }
            if loginViewModel.validatePasswordForRegisteredUser(registeredUser: fetchRegistredUserLogin, password: loginPasswordField.text!.trimmingCharacters(in: .whitespacesAndNewlines)) {
                    transitionToHomeScreen()
            } else {
                showErrorMessaage("Invalid Credentials!")
            }
            
        }
    }
    
    private func showErrorMessaage(_ message: String) {
        loginErrorLabel?.text = message
        loginErrorLabel?.alpha = 1
    }
    
    private func transitionToHomeScreen() {
        let homeViewController =
        storyboard?.instantiateViewController(withIdentifier: Constants.Stroyboard.homeViewController) as? HomeViewController
        
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
    }
}
