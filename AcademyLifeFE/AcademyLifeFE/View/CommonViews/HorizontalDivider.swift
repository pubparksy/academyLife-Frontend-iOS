//
//  HorizontalDivider.swift
//  AcademyLifeFE
//
//  Created by Heejae Seo on 12/12/24.
//

import SwiftUI

struct HorizontalDivider: View {
    var body: some View {
        Rectangle()
            .frame(width: 1, height: 39)
            .foregroundStyle(.timiGray.opacity(0.4))
            .padding(.horizontal, 4)
    }
}

#Preview {
    HorizontalDivider()
}
