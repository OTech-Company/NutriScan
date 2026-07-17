//
//  ProgressNextButton.swift
//  NutriScan
//
//  Created by albaraa alsayed on 03/02/1448 AH.
//

import SwiftUI

struct ProgressNextButton: View {
    var currentStep: Int
    var totalSteps: Int = 4
    var action: () -> Void
    
    private var progress: CGFloat {
        CGFloat(currentStep) / CGFloat(totalSteps)
    }
    
    private var guideColor: Color {
        Color(light: Color.Teal.teal200, dark: Color.Teal.teal1400)
    }
    
    var body: some View {
        Button(action: action) {
            ZStack {
                
                Circle()
                    .stroke(guideColor, lineWidth: 1)
                    .frame(width: 90, height: 90)
                
                
                Circle()
                    .trim(from: 0.0, to: progress)
                    .stroke(
                        Color.Teal.teal1000,
                        style: StrokeStyle(lineWidth: 2, lineCap: .round)
                    )
                    .frame(width: 90, height: 90)
                    .rotationEffect(.degrees(-90))
                    .animation(.easeInOut(duration: 0.4), value: progress)
                
                Circle()
                    .fill(Color.Teal.teal1000)
                    .frame(width: 69, height: 69)
                    .customTealShadow()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(Color.Teal.teal100)
            }
        }
        .padding()
    }
}

private struct ProgressButtonPreviewWrapper: View {
    @State private var step = 1
    
    var body: some View {
        VStack(spacing: 50) {
            ProgressNextButton(currentStep: step) {
                if step < 4 {
                    step += 1
                } else {
                    step = 1
                }
            }
            
            Text("Tap to animate progress")
                .foregroundColor(.gray)
        }
    }
}

#Preview("Light Mode") {
    ProgressButtonPreviewWrapper()
        .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    ProgressButtonPreviewWrapper()
        .preferredColorScheme(.dark)
}
