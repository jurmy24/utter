//
//  LanguagePartnerRow.swift
//  Utter
//
//  Created by Victor Magnus Oldensand on 2023-10-26.
//

import SwiftUI

struct LanguagePartnerRow: View {
    var body: some View {
        HStack(spacing: 12) {
            
            PartnerImage()
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Tim")
                    .font(.headline)
                Text("Plans on the weekend, taking a walk, coffee, ordering...")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .frame(alignment: .leading)
            }
        }.padding()
    }
}

#Preview {
    LanguagePartnerRow()
}
