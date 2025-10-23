

import SwiftUI

struct AsyncImageView: View {
    let urlString: String
    
    var body: some View {
        AsyncImage(url: URL(string: urlString)) { phase in
            if let image = phase.image {
                image
                    .resizable()
                    .scaledToFit()
                    .clipShape(ConcentricRectangle(corners: .concentric, isUniform: true))
                    .containerShape(.rect(cornerRadius: 10))
            } else if phase.error != nil {
                Rectangle()
                    .fill(Color(.systemGray5))
                    .clipShape(ConcentricRectangle(corners: .concentric, isUniform: true))
                    .containerShape(.rect(cornerRadius: 10))
            } else {
                ProgressView("Loading...")
            }
        }
    }
}

#Preview("AsyncImageView - Success") {
    AsyncImageView(urlString: Product.sample.image)
        .frame(width: 200, height: 200)
}


#Preview("AsyncImageView - Loading / Error") {
    AsyncImageView(urlString: "invalid-url")
        .frame(width: 200, height: 200)
}
