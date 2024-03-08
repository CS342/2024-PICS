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
    @Binding var image: UIImage?
    @Environment(PICSStandard.self) private var standard
    
    private var swiftUIImage: some View {
        image.flatMap {
            Image(uiImage: $0)
                .accessibilityLabel(Text("Medication Plan"))
        }
    }
    
    var body: some View {
        ImageSource(image: $image)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .padding()
            .onChange(of: image) {
                uploadImage(image: image)
            }
    }
    func uploadImage(image: UIImage?) {
        if let img = image {
                if let pdfPage = PDFPage(image: img) {
                    let pdfDocument = PDFDocument()
                    pdfDocument.insert(pdfPage, at: 0)
                    Task {
                        await standard.storeImage(image: pdfDocument)
                    }
                } else {
                    print("Failed to create PDFPage from image")
                }
            }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(image: .constant(nil))
    }
}
