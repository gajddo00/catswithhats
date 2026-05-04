//
//  GachaScreen.swift
//  catswithhats
//

import SwiftUI

struct GachaScreen: View {
    @State private var store: GachaStore

    init(authService: any AuthService, databaseService: any DatabaseService) {
        _store = State(initialValue: GachaStore(
            authService: authService,
            databaseService: databaseService
        ))
    }

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            content
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("CATS WITH HATS")
                    .font(.system(size: 16, weight: .black))
                    .foregroundStyle(Color.cInk)
            }
            ToolbarItem(placement: .topBarTrailing) {
                TokenChip(tokens: tokens)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear { store.send(.onAppear) }
        .sheet(item: drawnCardBinding) { card in
            GachaResultSheet(card: card) {
                store.send(.dismissResult)
            }
            .presentationDetents([.large])
        }
    }
}

private extension GachaScreen {
    @ViewBuilder
    var content: some View {
        switch store.state.uiState {
        case .loading:
            ProgressView()
                .tint(Color.cInk)
        case .error(let message):
            Text(message)
                .font(.system(size: 14, weight: .bold))
                .foregroundStyle(.red)
                .padding(.regular)
        case .content(let state):
            contentView(state)
        }
    }

    func contentView(_ state: GachaState) -> some View {
        VStack(spacing: .extraLarge) {
            Spacer(minLength: 0)
            GachaMachineView(isSpinning: state.isSpinning)
            TurnButton(
                cost: 24,
                isEnabled: state.canSpin,
                action: { store.send(.spinTapped) }
            )
            Spacer(minLength: 0)
        }
        .padding(.horizontal, .regular)
        .padding(.vertical, .large)
    }

    var tokens: Int {
        if case .content(let s) = store.state.uiState { return s.tokens }
        return 0
    }

    var drawnCardBinding: Binding<Card?> {
        Binding(
            get: {
                if case .content(let s) = store.state.uiState { return s.drawnCard }
                return nil
            },
            set: { newValue in
                if newValue == nil { store.send(.dismissResult) }
            }
        )
    }
}

// MARK: - Token Chip

private struct TokenChip: View {
    let tokens: Int

    var body: some View {
        HStack(spacing: .min) {
            Image(systemName: "dollarsign.circle.fill")
                .font(.system(size: 16, weight: .black))
                .foregroundStyle(.yellow)
            Text(tokens.formatted())
                .font(.system(size: 14, weight: .black))
                .foregroundStyle(Color.cInk)
        }
        .padding(.horizontal, .mid)
        .padding(.vertical, 6)
        .background(Color.white)
        .stickerStyle(Capsule(), lineWidth: 2, shadowOffset: 3)
        .padding(.horizontal, .regular)
        .padding(.vertical, .small)
    }
}

// MARK: - Turn Button

private struct TurnButton: View {
    let cost: Int
    let isEnabled: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: .mid) {
                Text("TURN")
                Capsule()
                    .fill(Color.cInk)
                    .frame(width: 56, height: 28)
                    .overlay(
                        HStack(spacing: 3) {
                            Image(systemName: "dollarsign.circle.fill")
                                .font(.system(size: 12, weight: .black))
                                .foregroundStyle(.yellow)
                            Text("\(cost)")
                                .font(.system(size: 13, weight: .black))
                                .foregroundStyle(.white)
                        }
                    )
            }
        }
        .buttonStyle(.sticker)
        .disabled(!isEnabled)
        .frame(maxWidth: 240)
    }
}

// MARK: - Gacha Machine

private struct GachaMachineView: View {
    let isSpinning: Bool
    @State private var wobble: Double = 0

    var body: some View {
        machineBody
            .rotationEffect(.degrees(wobble))
            .onChange(of: isSpinning) { _, spinning in
                if spinning {
                    withAnimation(.linear(duration: 0.12).repeatForever(autoreverses: true)) {
                        wobble = 3
                    }
                } else {
                    withAnimation(.spring(duration: 0.4)) {
                        wobble = 0
                    }
                }
            }
    }

    private var machineBody: some View {
        VStack(spacing: 0) {
            globe
                .padding(.top, .large)

            mechanicalPanel
                .padding(.top, .regular)

            chute
                .padding(.top, .small)
                .padding(.bottom, .regular)
        }
        .frame(width: 280)
        .background(
            UnevenRoundedRectangle(
                topLeadingRadius: 100,
                bottomLeadingRadius: 24,
                bottomTrailingRadius: 24,
                topTrailingRadius: 100,
                style: .continuous
            )
            .fill(Color.cPink)
        )
        .stickerStyle(
            UnevenRoundedRectangle(
                topLeadingRadius: 100,
                bottomLeadingRadius: 24,
                bottomTrailingRadius: 24,
                topTrailingRadius: 100,
                style: .continuous
            ),
            lineWidth: 4,
            shadowOffset: 8
        )
    }

    private var globe: some View {
        ZStack {
            Circle()
                .fill(Color.white.opacity(0.45))
            Circle()
                .stroke(Color.cInk, lineWidth: 4)
            CapsulesView(isSpinning: isSpinning)
                .padding(.large)
        }
        .frame(width: 220, height: 200)
    }

    private var mechanicalPanel: some View {
        HStack {
            // Coin slot
            RoundedRectangle(cornerRadius: 4, style: .continuous)
                .fill(Color.cInk)
                .frame(width: 26, height: 44)
                .overlay(
                    Capsule()
                        .fill(Color.white.opacity(0.25))
                        .frame(width: 4, height: 30)
                )

            Spacer()

            // Twist knob
            ZStack {
                Circle()
                    .fill(Color(red: 0.91, green: 0.89, blue: 0.80))
                Circle()
                    .stroke(Color.cInk, lineWidth: 4)
                Capsule()
                    .fill(Color.cInk)
                    .frame(width: 4, height: 38)
                    .rotationEffect(.degrees(45))
                Capsule()
                    .fill(Color.cInk)
                    .frame(width: 4, height: 38)
                    .rotationEffect(.degrees(-45))
                Circle()
                    .fill(Color.cInk)
                    .frame(width: 12, height: 12)
            }
            .frame(width: 56, height: 56)
            .shadow(color: Color.cInk, radius: 0, x: 4, y: 4)
            .rotationEffect(.degrees(isSpinning ? 360 : 0))
            .animation(
                isSpinning
                    ? .linear(duration: 0.6).repeatForever(autoreverses: false)
                    : .easeOut(duration: 0.3),
                value: isSpinning
            )
        }
        .padding(.horizontal, .extraLarge)
    }

    private var chute: some View {
        UnevenRoundedRectangle(
            topLeadingRadius: 8,
            bottomLeadingRadius: 4,
            bottomTrailingRadius: 4,
            topTrailingRadius: 8,
            style: .continuous
        )
        .fill(Color(white: 0.15))
        .frame(width: 90, height: 40)
        .overlay(
            UnevenRoundedRectangle(
                topLeadingRadius: 8,
                bottomLeadingRadius: 4,
                bottomTrailingRadius: 4,
                topTrailingRadius: 8,
                style: .continuous
            )
            .stroke(Color.cInk, lineWidth: 3)
        )
    }
}

// MARK: - Capsules

private struct CapsulesView: View {
    let isSpinning: Bool
    @State private var rotation: Double = 0

    private let capsules: [Capsule_] = [
        .init(color: Color(red: 0.66, green: 0.82, blue: 0.97), offset: CGSize(width: -50, height: -28)),
        .init(color: Color(red: 1.0, green: 0.86, blue: 0.45), offset: CGSize(width: 0, height: -36)),
        .init(color: Color(red: 1.0, green: 0.71, blue: 0.78), offset: CGSize(width: 50, height: -28)),
        .init(color: Color(red: 0.81, green: 0.74, blue: 0.95), offset: CGSize(width: 50, height: 18)),
        .init(color: Color(red: 0.69, green: 0.92, blue: 0.78), offset: CGSize(width: -25, height: 25)),
        .init(color: Color(red: 1.0, green: 0.81, blue: 0.61), offset: CGSize(width: 25, height: 25))
    ]

    var body: some View {
        ZStack {
            ForEach(0..<capsules.count, id: \.self) { i in
                Circle()
                    .fill(capsules[i].color)
                    .frame(width: 30, height: 30)
                    .overlay(Circle().stroke(Color.cInk, lineWidth: 2))
                    .shadow(color: Color.cInk, radius: 0, x: 2, y: 2)
                    .offset(capsules[i].offset)
            }
        }
        .rotationEffect(.degrees(rotation))
        .onChange(of: isSpinning) { _, spinning in
            if spinning {
                withAnimation(.linear(duration: 0.8).repeatForever(autoreverses: false)) {
                    rotation += 360
                }
            } else {
                withAnimation(.easeOut(duration: 0.4)) {
                    rotation = 0
                }
            }
        }
    }

    private struct Capsule_ {
        let color: Color
        let offset: CGSize
    }
}

// MARK: - Result Sheet

private struct GachaResultSheet: View {
    let card: Card
    let onDismiss: () -> Void

    @State private var appeared = false

    var body: some View {
        ZStack {
            Color.cPink.ignoresSafeArea()

            VStack(spacing: .large) {
                Text("YOU GOT")
                    .font(.system(size: 14, weight: .black))
                    .tracking(2)
                    .foregroundStyle(Color.cSubtitle)

                if let cat = CatImage(rawValue: card.assetID) {
                    CatImageView(cat: cat, size: 220, shape: .rounded)
                        .background(Color.white)
                        .stickerStyle(cornerRadius: .large, lineWidth: 4, shadowOffset: 8)
                }

                Text(card.name)
                    .font(.system(size: 28, weight: .black))
                    .foregroundStyle(Color.cInk)

                RarityBadge(rarity: card.rarity)

                Spacer()

                Button {
                    onDismiss()
                } label: {
                    Text("AWESOME!")
                }
                .buttonStyle(.sticker)
                .frame(maxWidth: 240)
            }
            .padding(.large)
            .padding(.top, .extraLarge)
            .scaleEffect(appeared ? 1 : 0.6)
            .opacity(appeared ? 1 : 0)
            .rotationEffect(.degrees(appeared ? 0 : -8))
        }
        .onAppear {
            withAnimation(.spring(response: 0.55, dampingFraction: 0.65)) {
                appeared = true
            }
        }
    }
}

private struct RarityBadge: View {
    let rarity: Rarity

    var body: some View {
        StickerChip(
            icon: iconName,
            label: label,
            backgroundColor: backgroundColor
        )
    }

    private var iconName: String {
        switch rarity {
        case .common: "circle.fill"
        case .uncommon: "diamond.fill"
        case .rare: "star.fill"
        case .legendary: "crown.fill"
        }
    }

    private var label: LocalizedStringKey {
        switch rarity {
        case .common: "COMMON"
        case .uncommon: "UNCOMMON"
        case .rare: "RARE"
        case .legendary: "LEGENDARY"
        }
    }

    private var backgroundColor: Color {
        switch rarity {
        case .common: .cBlue
        case .uncommon: .cMint
        case .rare: Color(red: 1.0, green: 0.86, blue: 0.45)
        case .legendary: .cPink
        }
    }
}
