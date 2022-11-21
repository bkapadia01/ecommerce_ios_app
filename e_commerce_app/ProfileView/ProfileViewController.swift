//
//  ProfileViewController.swift
//  e_commerce_app
//
//  Created by Bhavin Kapadia on 2022-11-01.
//

import Foundation
import UIKit

class ProfileViewController: UIViewController {
    @IBOutlet weak var firstName: UILabel!
    @IBOutlet weak var lastName: UILabel!
    @IBOutlet weak var userName: UILabel!
    
    private let profileViewModel: ProfileViewModel
    private let reuseIdentifier = "ProfileCell"

    init?(profileViwModel: ProfileViewModel, coder: NSCoder) {
        self.profileViewModel = profileViwModel
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        tableView.register(UINib(nibName: "ProfileCell", bundle: nil), forCellReuseIdentifier: reuseIdentifier)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate

        let userInfo = try? profileViewModel.getRegisteredUser(appDelegate:appDelegate)
        firstName.text = userInfo?.firstName
        lastName.text = userInfo?.lastName
        userName.text = userInfo?.username
        
        view.backgroundColor = .white
        navigationItem.title = "Profile"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logout))
    }
    
    @objc func logout() {
        
        print("logging out")
    }

    
    

}

class ProfileTableView: UITableView {
    
}
