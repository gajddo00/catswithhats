//
//  ConfettiView.swift
//  catswithhats
//

import SwiftUI

struct ConfettiView: View {
    @State private var confettiPieces: [ConfettiPiece] = []
    let colors: [Color] = [.red, .blue, .green, .yellow, .orange, .purple, .pink]
    
    var body: some View {
        ZStack {
            ForEach(confettiPieces) { piece in
                ConfettiShape()
                    .fill(piece.color)
                    .frame(width: piece.size, height: piece.size)
                    .rotationEffect(.degrees(piece.rotation))
                    .offset(x: piece.x, y: piece.y)
                    .opacity(piece.opacity)
            }
        }
        .onAppear {
            startConfetti()
        }
    }
    
    private func startConfetti() {
        confettiPieces = (0..<100).map { _ in
            ConfettiPiece(
                x: CGFloat.random(in: -200...200),
                y: -50,
                color: colors.randomElement() ?? .blue,
                size: CGFloat.random(in: 8...16),
                rotation: Double.random(in: 0...360),
                opacity: 1.0
            )
        }
        
        // Animate confetti falling
        withAnimation(.easeOut(duration: 3.0)) {
            confettiPieces = confettiPieces.map { piece in
                var newPiece = piece
                newPiece.y = CGFloat.random(in: 600...800)
                newPiece.rotation = Double.random(in: 360...720)
                newPiece.opacity = 0.0
                return newPiece
            }
        }
    }
}

struct ConfettiPiece: Identifiable {
    let id = UUID()
    var x: CGFloat
    var y: CGFloat
    var color: Color
    var size: CGFloat
    var rotation: Double
    var opacity: Double
}

struct ConfettiShape: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: rect.midX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
            path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.midY))
            path.closeSubpath()
        }
    }
}

struct PurchaseSuccessOverlay: View {
    let packageTitle: String
    @Binding var isPresented: Bool
    
    var body: some View {
        ZStack {
            // Semi-transparent background
            Color.black.opacity(0.4)
                .ignoresSafeArea()
            
            VStack(spacing: 24) {
                // Success icon
                ZStack {
                    Circle()
                        .fill(Color.green)
                        .frame(width: 80, height: 80)
                    
                    Image(systemName: "checkmark")
                        .font(.system(size: 40, weight: .bold))
                        .foregroundStyle(.white)
                }
                .scaleEffect(isPresented ? 1.0 : 0.5)
                .animation(.spring(response: 0.5, dampingFraction: 0.6), value: isPresented)
                
                VStack(spacing: 8) {
                    Text("Purchase Successful!")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                    
                    Text("You got \(packageTitle)")
                        .font(.body)
                        .foregroundStyle(.white.opacity(0.9))
                }
                .opacity(isPresented ? 1.0 : 0.0)
                .animation(.easeIn(duration: 0.3).delay(0.2), value: isPresented)
                
                Button {
                    withAnimation {
                        isPresented = false
                    }
                } label: {
                    Text("Awesome!")
                        .font(.headline)
                        .foregroundStyle(.black)
                        .frame(width: 200, height: 50)
                        .background(Color.white)
                        .cornerRadius(25)
                }
                .opacity(isPresented ? 1.0 : 0.0)
                .animation(.easeIn(duration: 0.3).delay(0.4), value: isPresented)
            }
            .padding(40)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.black.opacity(0.8))
            )
            
            // Confetti overlay
            ConfettiView()
                .allowsHitTesting(false)
        }
    }
}

#Preview {
    PurchaseSuccessOverlay(packageTitle: "Starter Bag", isPresented: .constant(true))
}
