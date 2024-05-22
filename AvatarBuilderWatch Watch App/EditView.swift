//
//  EditView.swift
//  AvatarBuilderWatch Watch App
//
//  Created by user on 22/05/2024.
//



import SwiftUI

struct EditView: View {
    
    @EnvironmentObject var viewModel: AvatarViewModel
    
    var body: some View {
        VStack {
            Text("Edit \(viewModel.editedAttribute.rawValue)")
                .font(.title2)
            TextField("Enter new value", text: $viewModel.editedText)
                .font(.title3)
                .multilineTextAlignment(.center)
            HStack {
                Button(action: { viewModel.confirmEditing() }) {
                    Text("Save")
                }
                .foregroundColor(.green)
                Button(action: { viewModel.isEditing.toggle() }) {
                    Text("Cancel")
                }
                .foregroundColor(.red)
            }
            .padding(.top)
        }
    }
}

#Preview {
    EditView()
        .environmentObject(AvatarViewModel())
}
