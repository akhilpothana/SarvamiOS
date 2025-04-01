import SwiftUI

struct CustomActionButton: View {
    let text: String?
    let icon: String?
    let action: () -> Void
    
    @Binding var isLoading: Bool
    
    var body: some View {
        Button(action: action) {
            HStack {
                if let text = text {
                    Text(text)
                        .font(.system(size: 16, weight: .heavy))
                }
                
                if let icon = icon {
                    if isLoading {
                        RotatingImage(systemName: icon)
                    }
                }
            }
            .padding()
            .foregroundColor(.white)
            .background(Color.buttonPurple)
            .cornerRadius(24)
        }
    }
}

struct RotatingImage: View {
    @State private var isRotating = false
    let systemName: String
    
    var body: some View {
        Image(systemName: systemName)
            .font(.system(size: 16, weight: .heavy))
            .rotationEffect(.degrees(isRotating ? 360 : 0))
            .animation(
                Animation.linear(duration: 2)
                    .repeatForever(autoreverses: false),
                value: isRotating
            )
            .onAppear {
                isRotating = true
            }
    }
}
