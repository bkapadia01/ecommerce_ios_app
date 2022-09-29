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
        setDelegates()
        loginErrorLabel?.alpha = 0 // hide error label on launch
    }
    
    @IBAction func signInButtonTapped(_ sender: Any) {
        validateSignInFields()
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
    
    private func goToHomePage() {
        let controller = storyboard?.instantiateViewController(withIdentifier: Constants.Stroyboard.homeViewController) as? HomeViewController
    }
    
    private func setDelegates() {
        loginUsernameField.delegate = self
        loginPasswordField.delegate = self
    }
    
    @IBAction func signInButton(_ sender: UIButton) {
        let loginFieldsErrorExists = validateSignInFields()

        if loginFieldsErrorExists != nil {
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
        let homeViewController = storyboard?.instantiateViewController(withIdentifier: Constants.Stroyboard.homeViewController) as? HomeViewController
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        loginUsernameField.resignFirstResponder()
        loginPasswordField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
