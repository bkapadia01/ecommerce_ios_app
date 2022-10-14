//
//  LoginViewController.swift
//  e_commerce_app
//
//  Created by Bhavin Kapadia on 2022-09-04.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginErrorLabel: UILabel?
    @IBOutlet weak var loginUsernameField: UITextField!
    @IBOutlet weak var loginPasswordField: UITextField!
    
    let loginViewModel = LoginViewModel()
    
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
            print("Error parsing password field")
            return
        }
        
        do {
            try loginViewModel.validateCredentials(username: loginUsername, password: loginPassword)
            transitionToHomeScreen()
        } catch {
            showErrorMessaage(error.localizedDescription)
        }
    }
    

    private func showErrorMessaage(_ message: String) {
        loginErrorLabel?.text = message
        loginErrorLabel?.alpha = 1
    }
    
    private func transitionToHomeScreen() {
        
        let homeViewController = storyboard?.instantiateViewController(identifier: Constants.Stroyboard.homeViewController, creator: { coder in
            guard let userID = self.loginViewModel.userID else {
                preconditionFailure("UserID not set")
            }
            let homeViewModel = HomeViewModel(userID: userID)
            return HomeViewController(homeViewModel: homeViewModel, coder: coder)
        })
        
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
