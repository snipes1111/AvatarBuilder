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
    
    var body: some View {
            List {
                Image(.avatar1)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                attributeRow(for: .age)
                attributeRow(for: .weight)
                attributeRow(for: .height)
            }
            .padding()
            .ignoresSafeArea()
            .sheet(isPresented: $viewModel.isEditing) {
                EditView()
            }
        }
    
    @ViewBuilder
    func attributeRow(for attribute: AvatarAttribute) -> some View {
        HStack {
            Text(attribute.rawValue)
            Text(viewModel.getAttributeValue(for: attribute))
            Spacer()
            Button(action: { viewModel.editAttribute(attribute) }) {
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
