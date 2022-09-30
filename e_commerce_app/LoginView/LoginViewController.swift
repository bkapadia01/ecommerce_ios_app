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
    
    private func setDelegates() {
        loginUsernameField.delegate = self
        loginPasswordField.delegate = self
    }
    
    @IBAction func signInButtonTapped(_ sender: UIButton) {
        guard let loginUsername = loginUsernameField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else {
            print("Error parsing username field")
            return
        }
        guard let loginPassword = loginPasswordField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else {
            print("Error retrieving password field")
            return
        }
        
        let loginFieldsErrorExists = loginViewModel.validateSignInFields(loginUsernameField: loginUsername, loginPaswordField: loginPassword)

        if loginFieldsErrorExists != nil {
            showErrorMessaage(loginFieldsErrorExists!)
            return
        } else  {
            guard let fetchRegistredUserLogin = loginViewModel.fetchRegisteredUser(username: loginUsername) else {
                showErrorMessaage("Invalid Credentials!")
                return
            }
            if loginViewModel.validatePasswordForRegisteredUser(registeredUser: fetchRegistredUserLogin, password: loginPassword) {
                    
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
