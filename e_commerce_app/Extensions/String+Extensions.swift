//
//  String+Extensions.swift
//  e_commerce_app
//
//  Created by Bhavin Kapadia on 2022-11-30.
//

import Foundation

extension String {
    func localized() -> String{
        return NSLocalizedString(self, bundle: Bundle.main, value: String(), comment: String())
    }
}
