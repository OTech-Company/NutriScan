//
//  CaloriesHistoryMetricCard.swift
//  NutriScan
//
//  Created by albaraa alsayed on 20/02/1448 AH.
//

import SwiftUI

struct CaloriesHistoryMetricCard: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    let state: DayStatusCardUIState
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            metricHeader
            
            Spacer(minLength: 0)
            
            VStack(alignment: .leading, spacing: 0) {
                valueLine(value: state.primaryValue, unit: state.type.primaryUnit)
                
                if let secondaryValue = state.secondaryValue,
                   let secondaryUnit = state.type.secondaryUnit {
                    valueLine(value: secondaryValue, unit: secondaryUnit)
                }
            }
        }
        .padding(6)
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(height: 72)
        .background(Color.CaloriesHistorySemantic.metricBackground)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .customLightShadow()
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(state.type.accessibilityTitle)
        .accessibilityValue(accessibilityValue)
    }
    
    private var metricHeader: some View {
        HStack(alignment: state.type == .totalMeals ? .top : .center, spacing: 4) {
            metricIcon
            
            Text(state.type.title)
                .font(Font.AppFont.textCaption)
                .foregroundStyle(Color.CaloriesHistorySemantic.metricTitle)
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
    
    private var metricIcon: some View {
        Image(state.type.icon)
            .renderingMode(.template)
            .foregroundStyle(Color.Teal.teal1000)
            
            .frame(width: 16, height: 16)
            .padding(1)
            .background {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.CaloriesHistorySemantic.iconBackground)
            }
    }
    
    private func valueLine(value: String, unit: String) -> some View {
        HStack(alignment: .lastTextBaseline, spacing: 2) {
            Text(value)
                .font(Font.AppFont.textDefault)
                .foregroundStyle(Color.CaloriesHistorySemantic.metricValue)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
                .contentTransition(.numericText())
                .animation(valueAnimation, value: value)
            
            Text(unit)
                .font(Font.AppFont.textCaption)
                .foregroundStyle(Color.CaloriesHistorySemantic.metricUnit)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
        }
    }

    private var valueAnimation: Animation? {
        reduceMotion ? nil : .easeOut(duration: 0.25)
    }
    
    private var accessibilityValue: String {
        var value = "\(state.primaryValue) \(state.type.primaryUnit)"
        if let secondaryValue = state.secondaryValue,
           let secondaryUnit = state.type.secondaryUnit {
            value += ", \(secondaryValue) \(secondaryUnit)"
        }
        return value
    }
}

#Preview("total meals") {
    CaloriesHistoryMetricCard(state: DayStatusCardUIState(type: .totalMeals, primaryValue: "23000"))
}

#Preview("water") {
    CaloriesHistoryMetricCard(state: DayStatusCardUIState(type: .water, primaryValue: "2300", secondaryValue: "2000"))
}

#Preview("steps") {
    CaloriesHistoryMetricCard(state: DayStatusCardUIState(type: .steps, primaryValue: "2300", secondaryValue: "2000"))
}

#Preview("exercise") {
    CaloriesHistoryMetricCard(state: DayStatusCardUIState(type: .exercise, primaryValue: "2300", secondaryValue: "2000"))
}
