//
//  AsyncImageView.swift
//  MyiOS15
//
//  Created by Cédric Bahirwe on 14/06/2021.
//

import SwiftUI

struct Photo: Identifiable {
    let id: Int
    let url: String
}
struct AsyncImageView: View {
    let images = (1...12).map { Photo(id: $0, url: "https://source.unsplash.com/random") }
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 420))]) {
                ForEach(images) { photo in
                    AsyncImage(url: URL(string: photo.url)!)
                        .frame(width: 400, height: 226)
                        .mask(RoundedRectangle(cornerRadius: 16))
                }
            }
            .padding()

        }
    }
}

struct AsyncImageView_Previews: PreviewProvider {
    static var previews: some View {
        AsyncImageView()
    }
}
