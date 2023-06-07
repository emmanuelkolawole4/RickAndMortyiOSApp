//
//  SwiftUIPreviewViewController.swift
//  RickAndMorty
//
//  Created by ULU on 04/05/2023.
//

import UIKit
import SwiftUI

struct ViewControllerPreview: UIViewControllerRepresentable {
    
    typealias UIViewControllerType = UIViewController
    
    
    let viewControllerBuilder: () -> UIViewController

    init(_ viewControllerBuilder: @escaping () -> UIViewController) {
        self.viewControllerBuilder = viewControllerBuilder
    }
    
    func makeUIViewController(context: Context) -> UIViewController {
        return viewControllerBuilder()
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // Not needed
    }
    
}



