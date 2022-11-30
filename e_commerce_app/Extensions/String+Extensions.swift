//
//  String+Extensions.swift
//  e_commerce_app
//
//  Created by Bhavin Kapadia on 2022-11-30.
//

import Foundation

extension String {
    func localized() -> String{
        var fileName = String()
        fileName = "WeatherLocalizable"
        return NSLocalizedString(self, tableName: fileName, bundle: Bundle.main, value: String(), comment: String())
    }
}
