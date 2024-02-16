//
//  Mini-cog.swift
//  PICS
//
//  Created by Adil on 1/30/24.
//
import ImageSource
import SpeziContact
import SpeziOnboarding
import SwiftUI
import UIKit

struct CheckboxItem: Identifiable {
    var id = UUID()
    var label: String
    var isChecked: Bool
}

var threeWords = ["Building", "Digital", "Health"]

struct CheckboxView: View {
    @Binding var item: CheckboxItem
    
    var body: some View {
        Toggle(isOn: $item.isChecked) {
            Text(item.label)
        }
        .toggleStyle(CheckboxStyle()) // Custom style, defined below
    }
}

// Custom Toggle Style to make it look more like a checkbox
struct CheckboxStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        return HStack {
            configuration.label
            Spacer()
            Image(systemName: configuration.isOn ? "checkmark.square.fill" : "square")
                .resizable()
                .frame(width: 24, height: 24)
                .foregroundColor(.blue)
                .onTapGesture { configuration.isOn.toggle() }
        }
    }
}

struct CheckboxListView: View {
    @State private var items: [CheckboxItem] = [
        .init(label: "Item 1", isChecked: false),
        .init(label: "Item 2", isChecked: true),
        .init(label: "Item 3", isChecked: false)
    ]
    
    var body: some View {
        List {
            ForEach($items) { $item in
                CheckboxView(item: $item)
            }
        }
    }
}


struct MiniCog: View {
    @State var clockPic: UIImage?
    var body: some View {
        VStack {
            Text("Mini Cognitive test").font(.title).foregroundColor(.red)
            Text ("For this test you will need 1 sheet of paper and a pen")
            Spacer()
            CheckboxListView()
            //            Button(action: {clockPic = nil}, label: {
//                HStack {
//                    Text("Upload images")
//                    Spacer()
//                    ImageSource(image: $clockPic).frame(whidth: 50, height: 50, alignment:
//                    right)
//                   
//                }
//                
//            })
            
        }
//        .onChange(of: clockPic) {
//            if clockPic != nil {
//                // TODO save picture
//            }
//        }
    }
}

#Preview {
    MiniCog()
}
