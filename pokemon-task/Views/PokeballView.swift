import SwiftUI

struct PokeballView: View {
    
    var body: some View {
        ZStack {
            Circle()
                .fill(.red)
            
            Rectangle()
                .fill(.white)
                .frame(height: 23)
                .offset(y: 11.5)
            
            Rectangle()
                .fill(.white)
                .frame(height: 4)
            
            Circle()
                .fill(.white)
                .frame(width: 16, height: 16)
                .overlay {
                    Circle()
                        .stroke(.black, lineWidth: 4)
                }
        }
        .frame(width: 46, height: 46)
        .clipShape(Circle())
        .overlay {
            Circle()
                .stroke(.black, lineWidth: 2)
        }
    }
}

#Preview {
    PokeballView()
}
