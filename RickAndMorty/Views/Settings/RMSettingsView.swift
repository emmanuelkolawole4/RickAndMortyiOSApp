//
//  RMSettingsView.swift
//  RickAndMorty
//
//  Created by ULU on 05/05/2023.
//

import SwiftUI

struct RMSettingsView: View {
    
    let vm: RMSettingsViewViewModel
    
    init(vm: RMSettingsViewViewModel) {
        self.vm = vm
    }
    
    var body: some View {
        List(vm.cellViewModels) { vm in
            HStack {
                if let image = vm.image {
                    Image(uiImage: image)
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(Color.white)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20, height: 20)
                        .padding(8)
                        .background(Color(vm.iconContainerColor))
                        .cornerRadius(6)
                }
                Text(vm.title)
                    .padding(.leading, 10)
                Spacer()
            }
            .padding(.bottom, 3)
            .contentShape(Rectangle())
            .onTapGesture {
                vm.tapHandler(vm.option)
            }
        }
    }
}

struct RMSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        RMSettingsView(vm: .init(
            cellViewModels: RMSettingsOption.allCases
                .compactMap { RMSettingsCellViewModel(
                    option: $0,
                    tapHandler: { option in
                        
                    })
                }
        ))
    }
}
