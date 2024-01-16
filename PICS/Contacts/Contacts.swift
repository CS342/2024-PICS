//
// This source file is part of the PICS based on the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import Foundation
import SpeziContact
import SwiftUI


/// Displays the contacts for the PICS.
struct Contacts: View {
    let contacts = [
        Contact(
            name: PersonNameComponents(
                givenName: "Eduardo",
                familyName: "Salgado"
            ),
            image: Image("dr. eduardo salgado"), // swiftlint:disable:this accessibility_label_for_image
            title: "Co-Principal Investigator",
            description: String(localized: "Dr. Eduardo Salgado is an anaesthesiologist and researcher. He graduated from the Faculty of [...] (https://drive.google.com/file/d/1del5rft_UEpQqsHVIFflX5NKM3VwpXQq/view?usp=sharing)"),
            organization: "Charité: Universitätsmedizin Berlin",
            address: {
                let address = CNMutablePostalAddress()
                address.country = "Germany"
                address.postalCode = "13353"
                address.city = "Berlin"
                address.street = "Augustenburger Pl. 1"
                return address
            }(),
            contactOptions: [
                .call("+49 (0) 30 450 631167"),
                .email(addresses: ["eduardo.salgado@charite.de"])
            ]
        ),
        Contact(
            name: PersonNameComponents(
                givenName: "Alexander",
                familyName: "Bartschke"
            ),
            image: Image("Alexander-Bartschke"), // swiftlint:disable:this accessibility_label_for_image
            title: "Co-Principal Investigator",
            description: String(localized: "Alexander Bartschke is a trained Medical Information Manager with extensive expertise [...] (https://drive.google.com/file/d/1del5rft_UEpQqsHVIFflX5NKM3VwpXQq/view?usp=sharing)"),
            organization: "Charité: Universitätsmedizin Berlin",
            address: {
                let address = CNMutablePostalAddress()
                address.country = "Germany"
                address.postalCode = "13353"
                address.city = "Berlin"
                address.street = "Augustenburger Pl. 1"
                return address
            }(),
            contactOptions: [
                .email(addresses: ["alexander.bartschke@bih-charite.de"])
            ]
        ),
        Contact(
            name: PersonNameComponents(
                givenName: "Julian",
                familyName: "Saß"
            ),
            image: Image("Julian-Sass"), // swiftlint:disable:this accessibility_label_for_image
            title: "Co-Principal Investigator",
            description: String(localized: "Julian Saß is a registered nurse, health economist and medical informatics specialist in [...] (https://drive.google.com/file/d/1del5rft_UEpQqsHVIFflX5NKM3VwpXQq/view?usp=sharing)"),
            organization: "Charité: Universitätsmedizin Berlin",
            address: {
                let address = CNMutablePostalAddress()
                address.country = "Germany"
                address.postalCode = "13353"
                address.city = "Berlin"
                address.street = "Augustenburger Pl. 1"
                return address
            }(),
            contactOptions: [
                .email(addresses: ["julian.sass@bih-charite.de"])
            ]
        )
    ]
    
    @Binding var presentingAccount: Bool
    
    
    var body: some View {
        NavigationStack {
            ContactsList(contacts: contacts)
                .navigationTitle(String(localized: "CONTACTS_NAVIGATION_TITLE"))
                .toolbar {
                    if AccountButton.shouldDisplay {
                        AccountButton(isPresented: $presentingAccount)
                    }
                }
        }
    }
    
    
    init(presentingAccount: Binding<Bool>) {
        self._presentingAccount = presentingAccount
    }
}


#if DEBUG
#Preview {
    Contacts(presentingAccount: .constant(false))
}
#endif
