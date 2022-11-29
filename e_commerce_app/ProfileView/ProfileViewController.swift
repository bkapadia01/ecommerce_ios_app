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
    @IBOutlet weak var paidOrderTableView: UITableView!
    
    private let profileViewModel: ProfileViewModel
    private let reuseIdentifier = "ProfileCell"

    init?(profileViwModel: ProfileViewModel, coder: NSCoder) {
        self.profileViewModel = profileViwModel
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        paidOrderTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let currentRegisteredUser = try? profileViewModel.getRegisteredUser(appDelegate:appDelegate)
        paidOrderTableView.delegate = self
        paidOrderTableView.dataSource = self
        firstName.text = currentRegisteredUser?.firstName
        lastName.text = currentRegisteredUser?.lastName
        userName.text = currentRegisteredUser?.username
        view.backgroundColor = .white
        navigationItem.title = "Profile"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logout))
    }
    
    @objc func logout() {
        let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        loginVC.modalPresentationStyle = .fullScreen
        present(loginVC, animated: false)
    }
}

extension ProfileViewController:  UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
       return "Order History"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if profileViewModel.getCountOfPaidOrders() != 0 {
            return profileViewModel.getCountOfPaidOrders()
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PaidOrdersCell", for: indexPath)
        if profileViewModel.getCountOfPaidOrders() != 0 {
            let paidOrder = profileViewModel.getPaidOrderAtIndexPath(indexPath: indexPath)
            cell.textLabel?.text = paidOrder?.paidDate.formatted(date: .abbreviated, time: .complete)
            cell.detailTextLabel?.text =  "$" + String(profileViewModel.getTotalPaidOrderAtIndexPath(indexPath: indexPath) as Double)
            return cell
        } else {
            cell.textLabel?.text = "No items purchased"
            cell.detailTextLabel?.text =  ""
            return cell
        }

    }
}
