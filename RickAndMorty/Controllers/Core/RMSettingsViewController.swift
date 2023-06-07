//
//  RMSettingsViewController.swift
//  RickAndMorty
//
//  Created by ULU on 03/04/2023.
//

import UIKit
import SwiftUI
import SafariServices
import StoreKit

/// Controller to show various app options and settings
final class RMSettingsViewController: UIViewController {
    
    private var settingsSwiftUIVC: UIHostingController<RMSettingsView>?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Settings"
        setupChildController()
    }
    
    private func setupChildController() {
        let settingsSwiftUIVC = UIHostingController(
            rootView: RMSettingsView(
                vm: RMSettingsViewViewModel(
                    cellViewModels: RMSettingsOption.allCases
                        .compactMap { RMSettingsCellViewModel(option: $0) { [weak self] option in
                            self?.handleSettingsTap(for: option)
                        } }
                )
            )
        )
        
        addChild(settingsSwiftUIVC)
        settingsSwiftUIVC.didMove(toParent: self)
        view.addSubview(settingsSwiftUIVC.view)
        settingsSwiftUIVC.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            settingsSwiftUIVC.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            settingsSwiftUIVC.view.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            settingsSwiftUIVC.view.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            settingsSwiftUIVC.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        self.settingsSwiftUIVC = settingsSwiftUIVC
    }
    
    private func handleSettingsTap(for option: RMSettingsOption) {
        guard Thread.current.isMainThread else { return }
        
        if let url = option.targetUrl {
            let vc = SFSafariViewController(url: url)
            present(vc, animated: true)
        } else if option == .rateApp {
            if let windowScene = view.window?.windowScene {
                SKStoreReviewController.requestReview(in: windowScene)
            }
        }
    }

}
