//
//  AvatarOverviewView.swift
//  AvatarBuilderWatch Watch App
//
//  Created by user on 22/05/2024.
//

import SwiftUI

struct AvatarOverviewView: View {
    
    @EnvironmentObject var viewModel: AvatarViewModel
    @State private var isShowingSheet: Bool = false
    
    typealias Attribute = AvatarViewModel.AvatarAttribute
    
    var body: some View {
        if let avatar = viewModel.avatar {
            GeometryReader { geometry in
                let size = geometry.size.width * 0.5
                List {
                    Section(header: ImageDataView(imageData: avatar.image,
                                                  width: size, height: size)) {
                        attributeRow("Age:", avatar.age, .age)
                        attributeRow("Height:", avatar.height, .height)
                        attributeRow("Weight:", avatar.weight, .weight)
                    }
                }
                .sheet(isPresented: $viewModel.isEditing) {
                    EditView()
                }
            }
        } else {
            Text("Oops...\nNo avatar was found")
                .multilineTextAlignment(.center)
                .font(.title2)
        }
    }
    
    @ViewBuilder
    func attributeRow(_ label: String, _ value: String, _ attribute: Attribute) -> some View {
        HStack {
            Text(label)
            Text(value)
            Spacer()
            Button(action: { viewModel.editAttribute(value, attribute) }) {
                Text("Edit")
                    .font(.system(.caption2))
                    .foregroundStyle(.gray)
            }
        }
    }
}

#Preview {
    AvatarOverviewView()
        .environmentObject(AvatarViewModel())
}
