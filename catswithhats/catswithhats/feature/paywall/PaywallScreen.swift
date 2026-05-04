//
//  PaywallScreen.swift
//  catswithhats
//

import SwiftUI

struct PaywallScreen: View {
    @State private var store: PaywallStore
    @Environment(\.dismiss) private var dismiss

    init(
        databaseService: any DatabaseService,
        userID: String,
        onCoinsChanged: (() -> Void)? = nil
    ) {
        _store = State(initialValue: PaywallStore(
            databaseService: databaseService,
            userID: userID,
            onCoinsChanged: onCoinsChanged
        ))
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Cream/beige background matching the screenshot
                Color(red: 0.95, green: 0.94, blue: 0.87)
                    .ignoresSafeArea()

                contentView

                // Purchase success overlay with confetti
                if store.state.showPurchaseSuccess,
                   let packageTitle = store.state.purchasedPackageTitle {
                    PurchaseSuccessOverlay(
                        packageTitle: packageTitle,
                        isPresented: Binding(
                            get: { store.state.showPurchaseSuccess },
                            set: { if !$0 { store.send(.dismissPurchaseSuccess) } }
                        )
                    )
                    .transition(.opacity)
                }
            }
            .navigationTitle("Shop")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private var contentView: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 16) {
                    // Error message if any
                    if let errorMessage = store.state.errorMessage {
                        errorBanner(errorMessage)
                    }
                    
                    // Limited Time Offer Banner
                    limitedOfferBanner
                    
                    // Package Cards
                    VStack(spacing: 12) {
                        ForEach(store.state.packages) { package in
                            packageCard(package, isSelected: store.state.selectedPackage?.id == package.id)
                                .onTapGesture {
                                    store.send(.selectPackage(package))
                                }
                        }
                    }
                    .padding(.horizontal, 16)
                    
                    Spacer(minLength: 32)
                    
                    // Missing a Hat Banner
                    missingHatBanner
                    
                    // Purchase Button
                    if let selectedPackage = store.state.selectedPackage {
                        purchaseButton(package: selectedPackage, isPurchasing: store.state.isPurchasing)
                    }
                }
                .padding(.top, 16)
                .padding(.bottom, 100)
            }
            .opacity(store.state.isLoading ? 0.5 : 1)
            .disabled(store.state.isLoading)
            
            if store.state.isLoading {
                ProgressView()
                    .scaleEffect(1.5)
            }
        }
        .onAppear {
            store.send(.onAppear)
        }
    }
    
    private func errorBanner(_ message: String) -> some View {
        HStack {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundStyle(.red)
            Text(message)
                .font(.caption)
                .foregroundStyle(.red)
            Spacer()
        }
        .padding()
        .background(Color.red.opacity(0.1))
        .cornerRadius(8)
        .padding(.horizontal, 16)
    }
    
    private var limitedOfferBanner: some View {
        ZStack {
            // Green background with rounded corners
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(red: 0.56, green: 0.73, blue: 0.56))
                .frame(height: 120)
            
            HStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text("LIMITED TIME OFFER")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.black)
                            .cornerRadius(4)
                    }
                    
                    Text("Unlock Rare Weighted")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                    
                    Text("Odds & Limited Edition purchases Today only!")
                        .font(.subheadline)
                        .foregroundStyle(.white)
                        .lineLimit(2)
                }
                .padding(.leading, 16)
                
                Spacer()
                
                // Cat image placeholder
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color(red: 0.85, green: 0.75, blue: 0.65))
                        .frame(width: 80, height: 80)
                    
                    Image(systemName: "photo")
                        .font(.system(size: 30))
                        .foregroundStyle(.white.opacity(0.5))
                }
                .padding(.trailing, 16)
            }
        }
        .padding(.horizontal, 16)
    }
    
    private func packageCard(_ package: PackageInfo, isSelected: Bool) -> some View {
        HStack(spacing: 12) {
            // Icon
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(red: 0.9, green: 0.85, blue: 0.75))
                    .frame(width: 60, height: 60)
                
                Text(package.icon)
                    .font(.system(size: 32))
            }
            
            // Title and subtitle
            VStack(alignment: .leading, spacing: 2) {
                Text(package.title)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundStyle(.black)
                
                Text(package.subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.gray)
            }
            
            Spacer()
            
            // Price
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .strokeBorder(Color.black, lineWidth: 2)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(isSelected ? Color.black : Color.white)
                    )
                    .frame(width: 100, height: 40)

                Text(package.price)
                    .font(.callout)
                    .fontWeight(.bold)
                    .foregroundStyle(isSelected ? .white : .black)
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .strokeBorder(Color.black, lineWidth: 2)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.white)
                )
        )
    }
    
    private var missingHatBanner: some View {
        VStack(spacing: 8) {
            Image(systemName: "gift")
                .font(.system(size: 40))
                .foregroundStyle(.gray.opacity(0.4))
            
            Text("Missing a Hat?")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundStyle(.black)
            
            Text("Complete your Summer Mode set with any token purchase today!")
                .font(.caption)
                .foregroundStyle(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
        }
        .padding(.vertical, 24)
    }
    
    private func purchaseButton(package: PackageInfo, isPurchasing: Bool) -> some View {
        Button {
            if !isPurchasing {
                store.send(.purchase)
            }
        } label: {
            HStack {
                if isPurchasing {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                } else {
                    Text("Purchase \(package.title) for \(package.price)")
                        .fontWeight(.semibold)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(Color.black)
            .foregroundStyle(.white)
            .cornerRadius(25)
        }
        .disabled(isPurchasing)
        .padding(.horizontal, 16)
    }
}

