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
    
    // return error string if validation is incorrect else return nil
    func validateRegistrationFields() -> String? {

        // check all fields are completed
        if firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            userNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            repeatPasswordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Please complete all fields."
        }

        if userNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).count ?? 0 < 5 {
            return "Username must greater than 4 chars."
        }
        
        // validate if username is unique

        if passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) !=
            repeatPasswordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) {
            return "The passwords do not match."
        }

        if passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).count ?? 0 < 5 ||
            repeatPasswordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).count ?? 0 < 5 {
            return "Password must greater than 4 chars."
        }
        
        if registerViewModel.isUsernameUnique( userNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "") == false {
            return "Username already exists."
        }
        return nil
    }
    
    @IBAction func cancelRegistrationTapped(_ sender: Any) {
        self.transitionToLoginScreen()

    }
    
    
    @IBAction func signUpButtonTapped(_ sender: Any) {
        let registrationFieldErrorExist = validateRegistrationFields()
        
        if registrationFieldErrorExist != nil {
            showErrorMessaage(registrationFieldErrorExist!)
        } else {
            registerErrorLabel.alpha = 0
            let firstName = firstNameTextField.text!
            let lastName = lastNameTextField.text!
            let userName = userNameTextField.text!
            let password = passwordTextField.text!
            
            registerViewModel.saveRegisteredUser(firstName: firstName, lastName: lastName, username: userName, password: password)
            registerViewModel.fetchRegisteredUsers()
            
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
        let registrationSuccessAlert = UIAlertController(title: "Registration Successful", message: "Registration was successful, please login with your credentials.", preferredStyle: UIAlertController.Style.alert)

        registrationSuccessAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            self.transitionToLoginScreen()
        }))
        present(registrationSuccessAlert, animated: true, completion: nil)
    }
    
}
