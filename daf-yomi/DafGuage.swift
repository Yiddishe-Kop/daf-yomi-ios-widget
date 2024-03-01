//
//  Guage.swift
//  הדף היומי
//
//  Created by Yehuda Neufeld on 15/06/2023.
//

import SwiftUI

struct DafGuage: View {
    
    var dafYomiData: DafYomiData
    
    @State private var offset: CGSize = CGSize(width: -100, height: 100)
    @State private var timerStarted = false

    var body: some View {
        ZStack {
            Gauge(value: Double(dafYomiData.dafNumber()), in: 0.0...Double(dafYomiData.totalDafim())) {
                Text(dafYomiData.shortTractateName())
                    .font(Font.custom("SiddurOC-Regular", size: 16))
            }
            .gaugeStyle(.accessoryCircular)
            Text(String(dafYomiData.daf))
                .font(Font.custom("SiddurOC-Black", size: [0, 50, 44, 30][dafYomiData.daf.count]))
                .offset(x: 0, y: -13)
            if dafYomiData.daf == "ב" && timerStarted {
                Text("🚀")
                    .font(.system(size: 42))
                    .offset(offset)
                    .onAppear {
                        Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { timer in
                            withAnimation(Animation.easeOut(duration: 2.0)) {
                                self.offset = CGSize(width: 100, height: -100)
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                  self.offset = CGSize(width: -100, height: 100) // Reset the offset
                              }
                        }
                    }
            }
        }
        .gaugeStyle(.accessoryCircular)
        .onAppear {
            timerStarted = true
        }
    }
}
