//
//  DateDisplay.swift
//  AcademyLifeFE
//
//  Created by 서희재 on 12/11/24.
//

import SwiftUI

struct DateDisplay: View {
    var today:Date = Date()
    
    var body: some View {
        Text(formatDate(today))
            .padding(.horizontal)
            .padding(.vertical, 5)
            .font(.caption)
            .foregroundStyle(.timiBlackLight)
            .background(Color.timiTextField)
            .cornerRadius(20)
            .padding(.bottom, 28)
    }
}

#Preview {
    DateDisplay()
}
