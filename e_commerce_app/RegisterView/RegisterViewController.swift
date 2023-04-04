//
//  RegisterViewController.swift
//  e_commerce_app
//
//  Created by Bhavin Kapadia on 2022-09-14.
//

import UIKit

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    @IBOutlet weak var registerErrorLabel: UILabel!
    
    let registerViewModel = RegisterViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerErrorLabel.alpha = 0 // hide error label
    }
    
    @IBAction func cancelRegistrationTapped(_ sender: Any) {
        self.transitionToLoginScreen()
    }
    
    @IBAction func signUpButtonTapped(_ sender: Any) {
        guard let firstNameEnteredTextfield = firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else {
            return
        }
        
        guard let lastNameEnteredTextfield = lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else {
            return
        }
        guard let usernameEnteredTextfield = userNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else {
            return
        }
        guard let passwordEnteredTextfield = passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else {
            return
        }
        guard let repeatedPasswordEnteredTextfield =  repeatPasswordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else {
            return
        }
        
        do {
            try registerViewModel.validateRegistrationFields(firstName: firstNameEnteredTextfield, lastName: lastNameEnteredTextfield, username: usernameEnteredTextfield, password: passwordEnteredTextfield, repeatedPassword: repeatedPasswordEnteredTextfield)
            
            registerViewModel.saveRegisteredUser(firstName: firstNameEnteredTextfield,
                                                 lastName: lastNameEnteredTextfield,
                                                 username: usernameEnteredTextfield,
                                                 password: passwordEnteredTextfield)
            self.registrationSuccessfulAlert()
        } catch {
            showErrorMessage(error.localizedDescription)
        }
    }
    
    private func showErrorMessage(_ message: String) {
        registerErrorLabel.text = message
        registerErrorLabel.alpha = 1
    }
    
    private func transitionToLoginScreen() {
        _ = navigationController?.popToRootViewController(animated: true)
    }
    
    private func registrationSuccessfulAlert() {
        registerErrorLabel.alpha = 0 
        let registrationSuccessAlert = UIAlertController(title: "Registration Successful",
                                                         message: "Registration was successful, please login with your credentials.",
                                                         preferredStyle: UIAlertController.Style.alert)
        registrationSuccessAlert.addAction(UIAlertAction(title: "OK",
                                                         style: .default,
                                                         handler: { (action: UIAlertAction!)in self.transitionToLoginScreen()}
                                                        ))
        present(registrationSuccessAlert, animated: true, completion: nil)
    }
    
}
