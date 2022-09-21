//
//  ObservableObject.swift
//  e_commerce_app
//
//  Created by Bhavin Kapadia on 2022-09-04.
//

import Foundation

final class ObservableObject<T> {

    var value: T {
        didSet {
            listener?(value)
        }
    }
    private var listener: ((T) -> Void)?
    
    init(_ value: T) {
        self.value = value
    }

    func bind(_ listener: @escaping(T) -> Void) {
        listener(value)
    
        self.listener = listener
    }
}
