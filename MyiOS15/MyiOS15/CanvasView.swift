//
//  CanvasView.swift
//  MyiOS15
//
//  Created by Cédric Bahirwe on 14/06/2021.
//

import SwiftUI
let symbol = Array(repeating: Symbol("guhemba"), count: 80) + Array(repeating: Symbol("hellokigali"), count: 50)
+ Array(repeating: Symbol("eventsbash"), count: 40)

struct CanvasView: View {
    
    let symbols: [Symbol]  = symbol.shuffled()
    @GestureState private var focalPoint: CGPoint? = nil
    
    var body: some View {
        Canvas { context , size in
            let metrics = gridMetrics(in: size)
            for (index, symbol) in symbols.enumerated() {
                let rect = metrics[index]
                let (sRect, opacity) = rect.fishEyeTransform(around: focalPoint)
                context.opacity = opacity
                
                let image = context.resolve(symbol.image)
                context.draw(image, in: sRect.fit(image.size))
            }
        }
        .gesture(DragGesture(minimumDistance: 0).updating($focalPoint, body: { value, focalPoint, _ in
            focalPoint = value.location
        }))
    }
    
    func gridMetrics(in size: CGSize) -> SymbolGridMetrics {
        SymbolGridMetrics(size: size, numberOfSymbols: symbols.count)
    }
}

struct Symbol: Identifiable {
    let name: String

    init(_ name: String) { self.name = name }
    var image: Image { Image(name) }
    var id: String { name }
    
}
struct SymbolGridMetrics {
    let symbolWidth: CGFloat
    let symbolsPerRow: Int
    let numberOfSymbols: Int
    let insetProportion: CGFloat
    
    init(size: CGSize, numberOfSymbols: Int, insetProportion: CGFloat = 0.1) {
        let areaPerSymbol = (size.width * size.height) / CGFloat(numberOfSymbols)
        self.symbolsPerRow = Int(size.width / sqrt(areaPerSymbol))
        self.symbolWidth = size.width / CGFloat(symbolsPerRow)
        self.numberOfSymbols = numberOfSymbols
        self.insetProportion = insetProportion
    }
    
    subscript(_ index: Int) -> CGRect {
        precondition(index >= 0 && index < numberOfSymbols)
        let row = index / symbolsPerRow
        let column = index % symbolsPerRow
        let rect = CGRect(
            x: CGFloat(column) * symbolWidth,
            y: CGFloat(row) * symbolWidth,
            width: symbolWidth, height: symbolWidth)
        
        return rect.insetBy(dx: symbolWidth * insetProportion, dy: symbolWidth * insetProportion)
    }
}

extension CGRect {
    func fit(_ otherSize: CGSize) -> CGRect {
        let scale = min(size.width / otherSize.width, size.height / otherSize.height)
        let newSize = CGSize(width: otherSize.width * scale, height: otherSize.height * scale)
        let newOrigin = CGPoint(x: midX - newSize.width/2, y: midY - newSize.height/2)
        return CGRect(origin: newOrigin, size: newSize)
    }
    /// Returns a transformed rect and relative opacity based on a fish eye effect centered around point`. /// The rectangles closer to the center of that point will be larger and brighter, and those further away will be smaller, up to a

    func fishEyeTransform (around point: CGPoint?, radius: CGFloat = 300, zoom: CGFloat = 1.0) -> (frame: CGRect, opacity: CGFloat) {
        guard let point = point else {
            return (self, 1.0)
        }
        
        let deltaX = midX - point.x
        
        let deltaY = midY - point.y
        
        let distance = sqrt(deltaX*deltaX + deltaY*deltaY)
        
        let theta = atan2(deltaY, deltaX)
        
        let scaledClampedDistance = pow(min (1, max(0, distance/radius)), 0.7)
        let scale = (1.0 - scaledClampedDistance)*zoom + 0.5
        
        let newOffset = distance * (2.0 - scaledClampedDistance)*sqrt(zoom)
        
        let newDeltaX = newOffset * cos(theta)
        
        let newDeltaY = newOffset * sin(theta)
        
        let newSize = CGSize (width: size.width * scale, height: size.height * scale)
        
        let newOrigin = CGPoint (x: (newDeltaX + point.x) - newSize.width/2, y: (newDeltaY + point.y) - newSize.height/2)
        
        // Clamp the opacity to be 0.1 at the lowest
        
        let opacity = max(0.1, 1.0 - scaledClampedDistance)
        
        return (CGRect(origin: newOrigin, size: newSize), opacity)
                
    }
}

struct CanvasView_Previews: PreviewProvider {
    static var previews: some View {
        CanvasView()
    }
}
