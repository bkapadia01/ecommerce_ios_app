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
    private let reuseIdentifier = Constants.Stroyboard.profileCell
    
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
        navigationItem.title = AppLocalizable.profile.localized()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: AppLocalizable.logout.localized(), style: .plain, target: self, action: #selector(logoutFromApp))
    }
    
    @objc func logoutFromApp() {
        let logoutUserAC = UIAlertController(title: AppLocalizable.logout.localized(), message: AppLocalizable.wouldLogout.localized(), preferredStyle: UIAlertController.Style.alert)
        logoutUserAC.addAction(UIAlertAction(title: AppLocalizable.agreeLogout.localized(), style: .default, handler: { _ in
            let loginVC = UIStoryboard(name: Constants.Stroyboard.main, bundle: nil).instantiateViewController(withIdentifier: Constants.Stroyboard.loginViewController) as! LoginViewController
            loginVC.modalPresentationStyle = .fullScreen
            self.present(loginVC, animated: false)
        }))
        logoutUserAC.addAction(UIAlertAction(title: AppLocalizable.cancel.localized(), style:.cancel, handler: nil))
        self.present(logoutUserAC, animated: true, completion: nil)
    }
}

extension ProfileViewController:  UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return AppLocalizable.orderHistory.localized()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if profileViewModel.getCountOfPaidOrders() != 0 {
            return profileViewModel.getCountOfPaidOrders()
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Stroyboard.paidOrderCell, for: indexPath)
        if profileViewModel.getCountOfPaidOrders() != 0 {
            let paidOrder = profileViewModel.getPaidOrderAtIndexPath(indexPath: indexPath)
            cell.textLabel?.text = paidOrder?.paidDate.formatted(date: .abbreviated, time: .complete)
            cell.detailTextLabel?.text =  "$" + String(profileViewModel.getTotalPaidOrderAtIndexPath(indexPath: indexPath) as Double)
            return cell
        } else {
            cell.textLabel?.text = AppLocalizable.noItemsPurchased.localized()
            cell.detailTextLabel?.text = AppLocalizable.addItemsToPurchase.localized()
            return cell
        }
    }
}
