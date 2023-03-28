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
//            try loginViewModel.validateCredentials(username: loginUsername, password: loginPassword)
            try loginViewModel.validateCredentialUsingKeychain(username: loginUsername, password: loginPassword)
            //set userID from viewmodel
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
        
        // Home Tab
        guard let homeViewController = storyboard?.instantiateViewController(identifier: Constants.Stroyboard.homeCollectionViewController, creator: { coder in
            guard let userID = self.loginViewModel.userID else {
                preconditionFailure("UserID not set")
            }
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let homeViewModel = HomeViewModel(userID: userID, appDelegate: appDelegate)
            return HomeCollectionViewController(homeViewModel: homeViewModel, coder: coder)
            
        }) else {
            preconditionFailure("Tab view controller could not be setup")
        }
        
        // Cart Tab
        guard let cartCollectionViewController = storyboard?.instantiateViewController(identifier: Constants.Stroyboard.cartCollectionViewController, creator: { coder in
            guard let userID = self.loginViewModel.userID else {
                preconditionFailure("UserID not set")
            }
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let cartViewModel = CartViewModel(userID: userID, appDelegate: appDelegate)
            return CartCollectionViewController(cartViewModel: cartViewModel, coder: coder)
        }) else {
            preconditionFailure("Tab view controller could not be setup")
        }
        
        // Profile tab
        guard let profileViewController = storyboard?.instantiateViewController(identifier: Constants.Stroyboard.profileViewController, creator: { coder in
            guard let userID = self.loginViewModel.userID else {
                preconditionFailure("UserID not set")
            }
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let profileViewModel = ProfileViewModel(userID: userID, appDelegate: appDelegate)
            return ProfileViewController(profileViwModel: profileViewModel, coder: coder)
        }) else {
            preconditionFailure("Tab view controller could not be setup")
        }
        
        let homeNavigationController = UINavigationController(rootViewController: homeViewController)
        let cartNavigationController = UINavigationController(rootViewController: cartCollectionViewController)
        let profileNavigationController = UINavigationController(rootViewController: profileViewController)
        
        let mainTabBarController = UITabBarController()
        
        mainTabBarController.setViewControllers([homeNavigationController], animated: true)
        view.window?.rootViewController = mainTabBarController
        view.window?.makeKeyAndVisible()
        
        let homeTabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house.fill"), selectedImage: nil)
        homeViewController.tabBarItem = homeTabBarItem
        
        let cartTabBarItem = UITabBarItem(title: "Cart", image: UIImage(systemName: "cart.fill"), selectedImage: nil)
        cartNavigationController.tabBarItem = cartTabBarItem
        
        let profileTabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.fill"), selectedImage: nil)
        profileNavigationController.tabBarItem = profileTabBarItem
        
        mainTabBarController.viewControllers = [homeNavigationController, cartNavigationController, profileNavigationController]
        
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
