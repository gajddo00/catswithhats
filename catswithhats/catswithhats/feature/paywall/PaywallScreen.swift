//
//  PaywallScreen.swift
//  catswithhats
//

import SwiftUI

struct PaywallScreen: View {
    @State private var store = PaywallStore()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Cream/beige background matching the screenshot
                Color(red: 0.95, green: 0.94, blue: 0.87)
                    .ignoresSafeArea()
                
                contentView
            }
            .navigationTitle("Shop")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private var contentView: some View {
        ScrollView {
            VStack(spacing: 16) {
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
        .onAppear {
            store.send(.onAppear)
        }
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
                    .frame(width: 70, height: 40)
                
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

#Preview {
    PaywallScreen()
}
