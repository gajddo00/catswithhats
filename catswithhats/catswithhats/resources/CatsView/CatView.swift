import SwiftUI

// MARK: - Cat Images Enum

enum CatImage: String, CaseIterable {
    case astronaut
    case artist
    case chef
    case chef2 = "chef_2"
    case detective
    case farmer
    case firefighter
    case pilot
    case pirate
    case wizard

    // MARK: - Image Asset Name
    var imageName: String { rawValue }

    // MARK: - Display Name
    var displayName: String {
        switch self {
            case .astronaut:   return "Astronaut Cat"
            case .artist:      return "Artist Cat"
            case .chef:        return "Chef Cat"
            case .chef2:       return "Sous Chef Cat"
            case .detective:   return "Detective Cat"
            case .farmer:      return "Farmer Cat"
            case .firefighter: return "Firefighter Cat"
            case .pilot:       return "Pilot Cat"
            case .pirate:      return "Pirate Cat"
            case .wizard:      return "Wizard Cat"
        }
    }

    // MARK: - Hat Name
    var hatName: String {
        switch self {
            case .astronaut:   return "Space Helmet"
            case .artist:      return "Beret"
            case .chef:        return "Toque Blanche"
            case .chef2:       return "Bandana"
            case .detective:   return "Fedora"
            case .farmer:      return "Straw Hat"
            case .firefighter: return "Fire Helmet"
            case .pilot:       return "Aviator Cap"
            case .pirate:      return "Tricorn Hat"
            case .wizard:      return "Pointy Hat"
        }
    }

    // MARK: - Background Color
    var backgroundColor: Color {
        switch self {
            case .astronaut:   return Color(hex: "0D1B2A")  // deep space navy
            case .artist:      return Color(hex: "F5E6D3")  // warm cream
            case .chef:        return Color(hex: "E8F4E8")  // soft mint
            case .chef2:       return Color(hex: "FFF3E0")  // warm apricot
            case .detective:   return Color(hex: "2C2C2C")  // charcoal
            case .farmer:      return Color(hex: "D4EDAA")  // meadow green
            case .firefighter: return Color(hex: "FF6B4A")  // fire orange
            case .pilot:       return Color(hex: "CDEEFF")  // sky blue
            case .pirate:      return Color(hex: "1A1035")  // midnight plum
            case .wizard:      return Color(hex: "2D1B5E")  // arcane purple
        }
    }

    // MARK: - Accent Color (for text / badges)
    var accentColor: Color {
        switch self {
            case .astronaut:   return Color(hex: "7EC8E3")
            case .artist:      return Color(hex: "C0392B")
            case .chef:        return Color(hex: "27AE60")
            case .chef2:       return Color(hex: "E67E22")
            case .detective:   return Color(hex: "BDC3C7")
            case .farmer:      return Color(hex: "27AE60")
            case .firefighter: return Color(hex: "FFD700")
            case .pilot:       return Color(hex: "2980B9")
            case .pirate:      return Color(hex: "F1C40F")
            case .wizard:      return Color(hex: "9B59B6")
        }
    }
}

// MARK: - Image Background Shape

enum ImageBackgroundShape: String, CaseIterable {
    case circle  = "Circle"
    case square  = "Square"
    case rounded = "Rounded"

    var label: String { rawValue }

    /// Corner radius given the view size
    func cornerRadius(for size: CGFloat) -> CGFloat {
        switch self {
            case .circle:  return size / 2
            case .square:  return 0
            case .rounded: return size * 0.22
        }
    }
}

// MARK: - SwiftUI Image View

struct CatImageView: View {
    let cat: CatImage
    var size: CGFloat = 120
    var shape: ImageBackgroundShape = .rounded

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: shape.cornerRadius(for: size))
                .fill(cat.backgroundColor)

            Image(cat.imageName)
                .resizable()
                .scaledToFit()
                .padding(size * 0.1)
            // Clip image to same shape so it never bleeds outside
                .clipShape(RoundedRectangle(cornerRadius: shape.cornerRadius(for: size)))
        }
        .frame(width: size, height: size)
    }
}

// MARK: - Card View (image + name + hat)

struct CatCardView: View {
    let cat: CatImage
    var size: CGFloat = 140
    var shape: ImageBackgroundShape = .rounded

    var body: some View {
        VStack(spacing: 8) {
            CatImageView(cat: cat, size: size, shape: shape)

            Text(cat.displayName)
                .font(.system(size: 13, weight: .semibold, design: .rounded))
                .foregroundStyle(.primary)

            Text(cat.hatName)
                .font(.system(size: 11, weight: .regular, design: .rounded))
                .foregroundStyle(.secondary)
        }
    }
}

// MARK: - Preview Gallery

struct CatImagesGalleryView: View {
    @State private var selectedShape: ImageBackgroundShape = .rounded

    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]

    var body: some View {
        ScrollView {
            // Shape picker
            Picker("Shape", selection: $selectedShape) {
                ForEach(ImageBackgroundShape.allCases, id: \.self) { shape in
                    Text(shape.label).tag(shape)
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
            .padding(.top, 8)

            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(CatImage.allCases, id: \.self) { cat in
                    CatCardView(cat: cat, shape: selectedShape)
                }
            }
            .padding()
            .animation(.spring(duration: 0.3), value: selectedShape)
        }
        .navigationTitle("Cats with Hats")
    }
}

// MARK: - Color Hex Extension

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r, g, b: UInt64
        switch hex.count {
            case 6:
                (r, g, b) = ((int >> 16) & 0xFF, (int >> 8) & 0xFF, int & 0xFF)
            default:
                (r, g, b) = (0, 0, 0)
        }
        self.init(
            red:   Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255
        )
    }
}

// MARK: - Previews

#Preview("Gallery") {
    NavigationStack {
        CatImagesGalleryView()
    }
}

#Preview("All Shapes") {
    VStack(spacing: 24) {
        HStack(spacing: 20) {
            CatCardView(cat: .wizard,    shape: .circle)
            CatCardView(cat: .astronaut, shape: .circle)
        }
        HStack(spacing: 20) {
            CatCardView(cat: .wizard,    shape: .square)
            CatCardView(cat: .astronaut, shape: .square)
        }
        HStack(spacing: 20) {
            CatCardView(cat: .wizard,    shape: .rounded)
            CatCardView(cat: .astronaut, shape: .rounded)
        }
    }
    .padding()
}

#Preview("Shape Sizes") {
    VStack(spacing: 16) {
        HStack(spacing: 12) {
            CatImageView(cat: .pirate, size: 60,  shape: .circle)
            CatImageView(cat: .pirate, size: 60,  shape: .square)
            CatImageView(cat: .pirate, size: 60,  shape: .rounded)
        }
        HStack(spacing: 12) {
            CatImageView(cat: .pirate, size: 90,  shape: .circle)
            CatImageView(cat: .pirate, size: 90,  shape: .square)
            CatImageView(cat: .pirate, size: 90,  shape: .rounded)
        }
        HStack(spacing: 12) {
            CatImageView(cat: .pirate, size: 120, shape: .circle)
            CatImageView(cat: .pirate, size: 120, shape: .square)
            CatImageView(cat: .pirate, size: 120, shape: .rounded)
        }
    }
    .padding()
}
