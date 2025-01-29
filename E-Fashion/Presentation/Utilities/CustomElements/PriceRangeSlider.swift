//
//  PriceRangeSlider.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 28.01.25.
//

import SwiftUI

struct SUIPriceRangeSlider: View {
    @Binding var minPrice: Double
    @Binding var maxPrice: Double
    let range: ClosedRange<Double>
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: 4)
                
                Rectangle()
                    .fill(Color.accentRed)
                    .frame(width: getSelectedWidth(width: geometry.size.width),
                           height: 4)
                    .offset(x: getMinOffset(width: geometry.size.width))
                
                Circle()
                    .fill(Color.white)
                    .frame(width: 24, height: 24)
                    .shadow(radius: 2)
                    .offset(x: getMinOffset(width: geometry.size.width) - 12)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                updateMinPrice(with: value, in: geometry)
                            }
                    )
                
                Circle()
                    .fill(Color.white)
                    .frame(width: 24, height: 24)
                    .shadow(radius: 2)
                    .offset(x: getMaxOffset(width: geometry.size.width) - 12)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                updateMaxPrice(with: value, in: geometry)
                            }
                    )
            }
        }
        .frame(height: 24)
    }
    
    private func getMinOffset(width: CGFloat) -> CGFloat {
        let percentageFromMin = (minPrice - range.lowerBound) / (range.upperBound - range.lowerBound)
        return width * CGFloat(percentageFromMin)
    }
    
    private func getMaxOffset(width: CGFloat) -> CGFloat {
        let percentageFromMin = (maxPrice - range.lowerBound) / (range.upperBound - range.lowerBound)
        return width * CGFloat(percentageFromMin)
    }
    
    private func getSelectedWidth(width: CGFloat) -> CGFloat {
        getMaxOffset(width: width) - getMinOffset(width: width)
    }
    
    private func updateMinPrice(with gesture: DragGesture.Value, in geometry: GeometryProxy) {
        let width = geometry.size.width
        let percentage = max(0, min(gesture.location.x / width, CGFloat((maxPrice - range.lowerBound) / (range.upperBound - range.lowerBound))))
        minPrice = range.lowerBound + (range.upperBound - range.lowerBound) * Double(percentage)
    }
    
    private func updateMaxPrice(with gesture: DragGesture.Value, in geometry: GeometryProxy) {
        let width = geometry.size.width
        let percentage = max(CGFloat((minPrice - range.lowerBound) / (range.upperBound - range.lowerBound)), min(1, gesture.location.x / width))
        maxPrice = range.lowerBound + (range.upperBound - range.lowerBound) * Double(percentage)
    }
}
