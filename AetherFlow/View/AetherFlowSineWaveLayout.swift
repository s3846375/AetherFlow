//
//  AetherFlowSineWaveLayout.swift
//  AetherFlow
//
//  A Custom Layout that places subviews along a sine wave curve.
//
//  This layout can be configured using the amplitude, frequence, margin, and offset attributes
//      to adjust the appearance of the sine wave.
//
//  This layout also supports animation by varying the offset property
//
//  This layout is used as part of the logo of AetherFlow on the StartView screen.
//
//  Created by Gabby Sanchez and Christina Tu on 19/8/2024.
//

import SwiftUI

/// A custom layout that arranges subviews along a sine wave pattern.
///
/// `AetherFlowSineWaveLayout` is a layout that arranges its subviews along the curve of a sine wave, based on configurable properties for amplitude, frequency, margin, and offset.
struct AetherFlowSineWaveLayout: Layout {
    
    /// The amplitude controls the vertical distance of the sine wave.
    var amplitude: CGFloat = 50.0
    
    /// The frequency controls the number of waves across the layout's width.
    var frequency: CGFloat = 1.0
    
    /// The margin added to the x-coordinate of each subview.
    var margin: CGFloat = 0.0
    
    /// The offset added to each subview to shift each of them vertically.
    ///
    /// Increasing this value over time will simulate animation by moving the subviews along the sine wave. This can be useful for creating dynamic, animated wave effects.
    var offset: CGFloat = 0.0

    // MARK: - Layout Methods
    
    /// Calculates the size that best fits the subviews based on the proposed size.
    ///
    /// This method is part of the `Layout` protocol and is used to determine the overall size of the layout. In this layout, the proposed size is returned with any unspecified dimensions replaced by default values.
    ///
    /// - Parameters:
    ///   - proposal: The size proposed for the layout, which may have unspecified dimensions.
    ///   - subviews: The collection of subviews to be arranged.
    ///   - cache: An empty cache that can be used for optimization during layout calculations.
    /// - Returns: The size that best fits the layout, derived from the proposed size with any unspecified dimensions replaced.
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        proposal.replacingUnspecifiedDimensions()
    }
    
    /// Positions the subviews along the bounds of a sine wave.
    ///
    /// This method arranges each subview's position based on a sine function, using the layout's amplitude, frequency, margin, and offset properties. The x-coordinate is determined by dividing the bounds' width among all subviews, while the y-coordinate is derived from the sine wave equation.
    ///
    /// - Parameters:
    ///   - bounds: The bounding rectangle of the layout where subviews are positioned.
    ///   - proposal: The proposed size for the layout, which may be used for positioning calculations.
    ///   - subviews: The collection of subviews to be laid out.
    ///   - cache: An empty cache that can be used for optimization during layout calculations.
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let step = (bounds.width) / CGFloat(subviews.count)
        
        for (index, subview) in subviews.enumerated() {
            // Calculate the x-coordinate for the current subview, including the margin.
            let x = CGFloat(index) * step + bounds.minX + margin
            
            // Calculate the y-coordinate based on the sine function with amplitude, frequency, and offset.
            let y = amplitude * sin(frequency * (x + offset)) + bounds.midY
            
            // Place the subview at the calculated position, centered around the point.
            subview.place(at: CGPoint(x: x, y: y), anchor: .center, proposal: .unspecified)
        }
    }
}
