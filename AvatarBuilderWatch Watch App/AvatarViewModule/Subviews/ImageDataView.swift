//
//  ImageDataView.swift
//  AvatarBuilderWatch Watch App
//
//  Created by user on 23/05/2024.
//

import SwiftUI

struct ImageDataView: View {
    
    let imageData: Data
    let width: CGFloat
    let height: CGFloat
    
    var body: some View {
        HStack() {
            Spacer()
            imageView(imageData)
                .frame(width: width, height: height)
                .padding(.bottom)
            Spacer()
        }
    }
    
    @ViewBuilder
    func imageView(_ imageData: Data) -> some View {
        if let image = UIImage(data: imageData) {
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
        } else {
            Image(systemName: "person.circle.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
        }
    }
}

#Preview {
    ImageDataView(imageData: Data(), width: 50, height: 50)
}
