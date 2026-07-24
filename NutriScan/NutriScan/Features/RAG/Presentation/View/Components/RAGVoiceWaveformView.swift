//
//  RAGVoiceWaveformView.swift
//  NutriScan
//
//  Created by Osama Hosam on 24/07/2026.
//


//
//  RAGVoiceWaveformView.swift
//  NutriScan
//

import SwiftUI

struct RAGVoiceWaveformView: View {
    let state: RAGVoiceState

    @State private var phase: CGFloat = 0

    private var amplitude: CGFloat {
        switch state {
        case .idle: return 12
        case .listening: return 34
        case .thinking: return 18
        case .speaking: return 30
        case .error: return 8
        }
    }

    private var cycleSpeed: CGFloat {
        switch state {
        case .thinking: return 0.25
        case .idle: return 0.08
        case .error: return 0.05
        default: return 0.16
        }
    }

    var body: some View {
        ZStack {
            wave(amplitudeScale: 1.0, frequency: 1.4, phaseOffset: 0, opacity: 0.9, color: Color.RAGSemantic.sendButton)
            wave(amplitudeScale: 0.7, frequency: 1.9, phaseOffset: .pi / 2, opacity: 0.55, color: Color.RAGSemantic.sendButton)
            wave(amplitudeScale: 0.45, frequency: 2.6, phaseOffset: .pi, opacity: 0.3, color: Color.RAGSemantic.userBubble)
        }
        .onReceive(Timer.publish(every: 1.0 / 60.0, on: .main, in: .common).autoconnect()) { _ in
            phase += cycleSpeed
        }
        .animation(.easeInOut(duration: 0.35), value: amplitude)
    }

    private func wave(amplitudeScale: CGFloat, frequency: CGFloat, phaseOffset: CGFloat, opacity: Double, color: Color) -> some View {
        RAGWaveformShape(
            amplitude: amplitude * amplitudeScale,
            frequency: frequency,
            phase: phase + phaseOffset
        )
        .stroke(color, style: StrokeStyle(lineWidth: 3, lineCap: .round))
        .opacity(opacity)
    }
}

private struct RAGWaveformShape: Shape {
    var amplitude: CGFloat
    var frequency: CGFloat
    var phase: CGFloat

    var animatableData: AnimatablePair<CGFloat, CGFloat> {
        get { AnimatablePair(amplitude, phase) }
        set {
            amplitude = newValue.first
            phase = newValue.second
        }
    }

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let midY = rect.height / 2
        let step: CGFloat = 2

        path.move(to: CGPoint(x: 0, y: midY))

        var x: CGFloat = 0
        while x <= rect.width {
            let relativeX = x / rect.width
            let sine = sin(relativeX * frequency * .pi * 2 + phase)
            let taper = sin(min(max(relativeX, 0), 1) * .pi) // fades the wave toward both edges
            let y = midY + sine * amplitude * taper
            path.addLine(to: CGPoint(x: x, y: y))
            x += step
        }

        return path
    }
}