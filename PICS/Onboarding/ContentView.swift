//
// This source file is part of the ImageSource open source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import ImageSource
import SwiftUI

struct ContentView: View {
    @State var image: UIImage?
    @AppStorage("isPhotoUploaded") var isPhotoUploaded = false
    
    private var swiftUIImage: Image? {
        image.flatMap {
            Image(uiImage: $0)
        }
    }
    
    var body: some View {
        NavigationStack {
            ImageSource(image: $image)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .padding()
                .navigationTitle("Image Source Example")
                .toolbar {
                    if let swiftUIImage = swiftUIImage {
                        ToolbarItem {
                            ShareLink(
                                item: swiftUIImage,
                                subject: Text("Image Source"),
                                message: Text("Check it out the Image Source Swift Package: https://github.com/StanfordBDHG/ImageSource"),
                                preview: SharePreview("Image Source Example", image: swiftUIImage)
                            )
                        }
                    }
                }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
