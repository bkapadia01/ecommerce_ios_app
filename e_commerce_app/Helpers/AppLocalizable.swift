//
//  AppLocalizable.swift
//  e_commerce_app
//
//  Created by Bhavin Kapadia on 2022-11-30.
//
import Foundation

enum AppLocalizable: String {
    case missingTitle = "Missing Title"
    case missingImage = "Missing Image"
    case welcomeTitle = "Welcome "
    case cancel = "Cancel"
    case ok = "OK"
    case edit = "Edit"
    case checkOut = "Checkout"
    case returnHome = "Return Home"
    case itemAddedToCart = "Item added to cart!"
    case viewItemInCart = "Navigate to cart to view the item in the cart"
    case checkOutItemCart = "Checkout Items In Cart"
    case wouldCheckoutItemsCart = "Would you like to checkout the items in cart? "
    case checkOutItems = "Checkout Items"
    case yourCart = "Your Cart"
    case missingName = "Missing Name"
    case profile = "Profile"
    case logout = "Logout"
    case wouldLogout = "Would you like to logout?"
    case agreeLogout =  "Yes, Logout"
    case orderHistory = "Purchase Order History"
    case noItemsPurchased = "No items purchased"
    case addItemsToPurchase = "Add items to cart to purchase"
    func localized() -> String {
        rawValue.localized()
    }
}

