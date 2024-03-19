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


struct ImageCanvas: View {
    @Environment(PICSStandard.self)
    private var standard

    @Binding var image: UIImage?
    
    var body: some View {
        ImageSource(image: $image)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .padding()
            .onChange(of: image) {
                guard let image else {
                    return
                }
                uploadImage(image: image)
            }
    }


    func uploadImage(image: UIImage) {
        if let pdfPage = PDFPage(image: image) {
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


#if DEBUG
#Preview {
    struct ImagePreview: View {
        @State var image: UIImage?

        var body: some View {
            ImageCanvas(image: $image)
        }
    }

    return ImagePreview()
        .previewWith(standard: PICSStandard()) {}
}
#endif
