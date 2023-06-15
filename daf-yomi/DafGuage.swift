//
//  Guage.swift
//  הדף היומי
//
//  Created by Yehuda Neufeld on 15/06/2023.
//

import SwiftUI

struct DafGuage: View {
    
    var dafYomiData: DafYomiData
    
    var body: some View {
        ZStack {
            Gauge(value: Double(dafYomiData.dafNumber()), in: 0.0...Double(dafYomiData.totalDafim())) {
                Text(dafYomiData.tractate)
                    .font(Font.custom("SiddurOC-Regular", size: 16))
            }
            .gaugeStyle(.accessoryCircular)
            Text(String(dafYomiData.daf))
                .font(Font.custom("SiddurOC-Black", size: [0, 50, 44, 30][dafYomiData.daf.count]))
                .offset(x: 0, y: -10)
        }
        .gaugeStyle(.accessoryCircular)
    }
}
