//
// This source file is part of the ImageSource open source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//
import Foundation
import ImageSource
import PDFKit
import SwiftUI


struct ContentView: View {
    @State var image: UIImage?
    @Environment(PICSStandard.self) private var standard
    
    private var swiftUIImage: Image? {
        image.flatMap {
            Image(uiImage: $0)
        }
    }
    
    var body: some View {
        ImageSource(image: $image)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .padding()
            .toolbar {
                if let swiftUIImage = swiftUIImage {
                    ToolbarItem {
                        ShareLink(
                            item: swiftUIImage,
                            subject: Text("Image Source"),
                            message: Text("Check it out the Image Source Swift Package: https://github.com/StanfordBDHG/ImageSource"),
                            preview: SharePreview("", image: swiftUIImage)
                        )
                    }
                }
            }
            .onChange(of: image) {
                uploadImage(image: image)
            }
    }
    func uploadImage(image: UIImage?) {
        if let img = image {
            let pdfDocument = PDFDocument()
            let pdfPage = PDFPage(image: img)
            pdfDocument.insert(pdfPage!, at: 0)
            Task {
                await standard.storeImage(image: pdfDocument)
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
