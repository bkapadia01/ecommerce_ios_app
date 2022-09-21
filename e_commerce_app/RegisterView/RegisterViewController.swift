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
        registerViewModel.fetchRegisteredUsers()
    }
    
    @IBAction func cancelRegistrationTapped(_ sender: Any) {
        self.transitionToLoginScreen()
    }
    
    
    @IBAction func signUpButtonTapped(_ sender: Any) {
        guard let firstNameEnteredText = firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        guard let lastNameEnteredText = lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        guard let usernameEnteredText = userNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        guard let passwordEnteredText = passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        guard let repeatedPasswordEnteredText =  repeatPasswordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        
        let registrationFieldErrorExist = registerViewModel.validateRegistrationFields(firstName: firstNameEnteredText,
                                                                                       lastName: lastNameEnteredText,
                                                                                       username: usernameEnteredText,
                                                                                       password: passwordEnteredText,
                                                                                       repeatedPassword: repeatedPasswordEnteredText)
        
        if registrationFieldErrorExist != nil {
            showErrorMessaage(registrationFieldErrorExist!)
        } else {
            registerViewModel.saveRegisteredUser(firstName: firstNameEnteredText,
                                                 lastName: lastNameEnteredText,
                                                 username: usernameEnteredText,
                                                 password: passwordEnteredText)
            self.registrationSuccessfulAlert()
        }
    }
    
    private func showErrorMessaage(_ message: String) {
        registerErrorLabel.text = message
        registerErrorLabel.alpha = 1
    }
    
    private func transitionToLoginScreen() {
        _ = navigationController?.popToRootViewController(animated: true)
    }
    
    private func registrationSuccessfulAlert() {
        let registrationSuccessAlert = UIAlertController(title: "Registration Successful",
                                                         message: "Registration was successful, please login with your credentials.",
                                                         preferredStyle: UIAlertController.Style.alert)
        
        registrationSuccessAlert.addAction(UIAlertAction(title: "Ok",
                                                         style: .default,
                                                         handler: { (action: UIAlertAction!)in self.transitionToLoginScreen()}
                                                        ))
        
        present(registrationSuccessAlert, animated: true, completion: nil)
    }
    
}
