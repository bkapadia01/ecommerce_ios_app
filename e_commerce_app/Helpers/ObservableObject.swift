//
//  ObservableObject.swift
//  e_commerce_app
//
//  Created by Bhavin Kapadia on 2022-09-25.
//

import Foundation

final class ObservableObject<T> {
    typealias Listener = (T?) -> Void
    private var listener: Listener?
    
    var value: T? {
        didSet {
            listener?(value)
        }
    }

    init(_ value: T?) {
        self.value = value
    }

    
    func bind(_ listener: (Listener?)) {
        listener?(value)
        self.listener = listener
    }
}
