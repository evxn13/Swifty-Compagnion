// Confettis

import SwiftUI

struct ConfettiView: View {
    var count: Int = 120

    @State private var pieces: [ConfettiPiece] = []

    private static let palette: [Color] = [
        .blue, .green, .orange, .pink, .purple, .yellow, .red, .mint, .cyan
    ]

    var body: some View {
        GeometryReader { geo in
            ZStack {
                ForEach(pieces) { piece in
                    ConfettiPieceView(piece: piece, containerSize: geo.size)
                }
            }
            .onAppear { generate(in: geo.size) }
        }
        .allowsHitTesting(false)   // ne bloque pas les interactions
        .ignoresSafeArea()
    }

    private func generate(in size: CGSize) {
        pieces = (0..<count).map { _ in
            ConfettiPiece(
                x: CGFloat.random(in: 0...max(size.width, 1)),
                color: Self.palette.randomElement() ?? .blue,
                width: CGFloat.random(in: 6...11),
                height: CGFloat.random(in: 10...16),
                delay: Double.random(in: 0...0.5),
                duration: Double.random(in: 1.8...3.2),
                spin: Double.random(in: 180...1080),
                xDrift: CGFloat.random(in: -70...70)
            )
        }
    }
}

struct ConfettiPiece: Identifiable {
    let id = UUID()
    let x: CGFloat
    let color: Color
    let width: CGFloat
    let height: CGFloat
    let delay: Double
    let duration: Double
    let spin: Double
    let xDrift: CGFloat
}

private struct ConfettiPieceView: View {
    let piece: ConfettiPiece
    let containerSize: CGSize

    @State private var animate = false

    var body: some View {
        RoundedRectangle(cornerRadius: 2)
            .fill(piece.color)
            .frame(width: piece.width, height: piece.height)
            .rotationEffect(.degrees(animate ? piece.spin : 0))
            .position(
                x: piece.x + (animate ? piece.xDrift : 0),
                y: animate ? containerSize.height + 40 : -40
            )
            .opacity(animate ? 0 : 1)
            .onAppear {
                withAnimation(.easeOut(duration: piece.duration).delay(piece.delay)) {
                    animate = true
                }
            }
    }
}
