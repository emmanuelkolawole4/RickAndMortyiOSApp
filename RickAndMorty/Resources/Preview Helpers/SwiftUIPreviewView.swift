//
//  SwiftUIPreviewView.swift
//  RickAndMorty
//
//  Created by ULU on 04/05/2023.
//

import UIKit
import SwiftUI

struct ViewPreview: UIViewRepresentable {
    let viewBuilder: () -> UIView

    init(_ viewBuilder: @escaping () -> UIView) {
        self.viewBuilder = viewBuilder
    }

    func makeUIView(context: Context) -> some UIView {
        viewBuilder()
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {
        // Not needed
    }
}
