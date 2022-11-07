//
//  LoginViewController.swift
//  e_commerce_app
//
//  Created by Bhavin Kapadia on 2022-09-04.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginImageIcon: UIImageView!
    @IBOutlet weak var loginErrorLabel: UILabel?
    @IBOutlet weak var loginUsernameField: UITextField!
    @IBOutlet weak var loginPasswordField: UITextField!
    
    let loginViewModel = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginImageIcon.image = UIImage(named: "homeShoppingArt")
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
        if let homeViewController = storyboard?.instantiateViewController(identifier: Constants.Stroyboard.homeCollectionViewController, creator: { coder in
            guard let userID = self.loginViewModel.userID else {
                preconditionFailure("UserID not set")
            }
            
            let homeViewModel = HomeViewModel(userID: userID)
            return HomeCollectionViewController(homeViewModel: homeViewModel, coder: coder)
            
        }) {
            let homeNavigationController = UINavigationController(rootViewController: homeViewController)
            let cartNavigationController = UINavigationController(rootViewController: CartCollectionViewController())
            let profileNavigationController = UINavigationController(rootViewController: ProfileViewController())

            let mainTabBarController = UITabBarController()
            
            mainTabBarController.setViewControllers([homeNavigationController], animated: true)
            view.window?.rootViewController = mainTabBarController
            view.window?.makeKeyAndVisible()
            
            let homeTabBarItem = UITabBarItem(title: "HomeBoy", image: UIImage(systemName: "house.fill"), selectedImage: nil)
            homeViewController.tabBarItem = homeTabBarItem
            
            let cartTabBarItem = UITabBarItem(title: "Cart", image: UIImage(systemName: "cart.fill"), selectedImage: nil)
            cartNavigationController.tabBarItem = cartTabBarItem
            
            let profileTabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.fill"), selectedImage: nil)
            profileNavigationController.tabBarItem = profileTabBarItem
            
            mainTabBarController.viewControllers = [homeNavigationController, cartNavigationController, profileNavigationController]
        }
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
