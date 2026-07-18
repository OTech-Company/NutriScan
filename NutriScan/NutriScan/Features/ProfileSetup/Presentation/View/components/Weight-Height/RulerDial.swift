import SwiftUI

// MARK: - Ruler Unit
enum RulerUnit {
    case height
    case weight

    var defaultRange: ClosedRange<Int> {
        switch self {
        case .height: return 100...220
        case .weight: return 30...200
        }
    }

    var majorInterval: Int {
        switch self {
        case .height: return 5
        case .weight: return 10
        }
    }

    var isArcStyle: Bool {
        self == .weight
    }
}

// MARK: - RulerDial
struct RulerDial: View {
    @Binding var value: Int
    let unit: RulerUnit

    var range: ClosedRange<Int>? = nil
    var visibleCount: Int = 10

    private var effectiveRange: ClosedRange<Int> { range ?? unit.defaultRange }
    private var majorInterval: Int { unit.majorInterval }

    @GestureState private var dragOffset: CGFloat = 0
    @State private var lastValue: Int = 0

    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let spacing = unit.isArcStyle
                ? min(20, width / CGFloat(visibleCount * 2))
                : min(18, width / CGFloat(visibleCount * 2))
            let pointsPerTick: CGFloat = spacing

            let dynamicOffset = Int(round(-dragOffset / pointsPerTick))
            let currentValue = max(effectiveRange.lowerBound,
                                   min(effectiveRange.upperBound,
                                       lastValue + dynamicOffset))

            ZStack(alignment: .top) {
                let lowerBound = max(effectiveRange.lowerBound, currentValue - visibleCount)
                let upperBound = min(effectiveRange.upperBound, currentValue + visibleCount)
                let visibleTicks = Array(lowerBound...upperBound)

                ForEach(visibleTicks, id: \.self) { tick in
                    let dragRemainder = (-dragOffset / pointsPerTick) - CGFloat(dynamicOffset)
                    let offset = CGFloat(tick - currentValue) - dragRemainder

                    let xOffset = offset * spacing
                    let yOffset = unit.isArcStyle ? (offset * offset) * 0.6 : 0
                    let rotationAngle = unit.isArcStyle ? Double(offset) * 1.5 : 0

                    let isSelected = tick == currentValue
                    let isMajorTick = tick % majorInterval == 0

                    // ----- TICK DIMENSIONS (ARC STYLE) -----
                    let (tickWidth, tickHeight): (CGFloat, CGFloat) = {
                        if unit.isArcStyle {
                            if isSelected {
                                return (2.5, 42)
                            } else if isMajorTick {
                                return (2.0, 36)
                            } else {
                                return (1.5, 18)
                            }
                        } else {
                            // Straight ruler (height) – unchanged
                            if isSelected {
                                return (2.5, 46)
                            } else if isMajorTick {
                                return (2.0, 30)
                            } else {
                                return (1.5, 20)
                            }
                        }
                    }()

                    VStack(spacing: 6) {
                        Rectangle()
                            .fill(isSelected ? Color.teal
                                    : (isMajorTick ? Color.teal.opacity(0.6) : Color.teal.opacity(0.2)))
                            .frame(width: tickWidth, height: tickHeight)

                        if isMajorTick || isSelected {
                            Text("\(tick)")
                                .font(.system(size: unit.isArcStyle ? 10 : 12,
                                              weight: isSelected ? .medium : .regular,
                                              design: unit.isArcStyle ? .rounded : .default))
                                .foregroundColor(isSelected ? .primary : .gray.opacity(0.6))
                        } else {
                            Color.clear.frame(height: 12)
                        }
                    }
                    .frame(width: 30, height: 55)
                    .rotationEffect(.degrees(rotationAngle), anchor: .top)
                    .offset(x: xOffset, y: yOffset)
//                    .opacity(max(0, 1.2 - abs(offset) / CGFloat(visibleCount)))
                }


            }
            .frame(width: width, height: 90, alignment: .top)
            .contentShape(Rectangle())
            .gesture(
                DragGesture()
                    .updating($dragOffset) { value, state, _ in
                        state = value.translation.width
                    }
                    .onChanged { gesture in
                        if gesture.translation == .zero {
                            Haptics.prepareSelection()
                        }

                        let newOffset = Int(round(-gesture.translation.width / pointsPerTick))
                        let computed = lastValue + newOffset
                        let bounded = max(effectiveRange.lowerBound,
                                          min(effectiveRange.upperBound, computed))
                        if value != bounded {
                            
                            Haptics.selectionChanged()
                            value = bounded
                        }
                    }
                    .onEnded { gesture in
                        let finalOffset = Int(round(-gesture.translation.width / pointsPerTick))
                        lastValue = max(effectiveRange.lowerBound,
                                        min(effectiveRange.upperBound,
                                            lastValue + finalOffset))
                        value = lastValue
                    }
            )
            .onAppear {
                lastValue = value
            }
            .onChange(of: value) { newValue in
                if lastValue != newValue && dragOffset == 0 {
                    lastValue = newValue
                }
            }
        }
        .frame(height: 90)
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: 40) {
        VStack(alignment: .leading, spacing: 4) {
            Text("Height")
                .font(.headline)
                .padding(.horizontal)
            RulerDial(value: .constant(175), unit: .height)
                .frame(height: 90)
        }

        VStack(alignment: .leading, spacing: 4) {
            Text("Weight")
                .font(.headline)
                .padding(.horizontal)
            RulerDial(value: .constant(76), unit: .weight)
                .frame(height: 90)
        }
    }
    .padding(.vertical)
}
