//
//  Extensions.swift
//  RickAndMorty
//
//  Created by ULU on 14/04/2023.
//

import UIKit

extension UIView {
    
    func addSubviews(_ views: UIView...) {
        views.forEach { addSubview($0) }
    }
}
