//
//  ContentView.swift
//  MyiOS15
//
//  Created by Cédric Bahirwe on 11/06/2021.
//

import SwiftUI

struct Colors: Identifiable {
    var id = UUID()
    var name: String
}

struct ContentView: View {
    let imageUrl = "https://source.unsplash.com/random"
    @State private var searchQuery: String = ""
    @State private var colors: [Colors] = [Colors(name: "Blue"),Colors(name: "Red"),Colors(name: "Green"), Colors(name: "Yellow"), Colors(name: "White"), Colors(name: "Purple"), Colors(name: "Orange"), Colors(name: "Pink"), Colors(name: "Brown"), Colors(name: "Black"), Colors(name: "Gray"), Colors(name: "Clear")]

    var searchResults: [Colors] {
        if searchQuery.isEmpty {
            return colors
        } else {
            return colors.filter({ $0.name.lowercased().contains(searchQuery.lowercased())})
        }
    }
    var body: some View {
        NavigationView {
            
            List(searchResults) { color in
                HStack {
                    AsyncImage(url: URL(string: imageUrl)!, scale: 0.6, content: { image in
                        image
                    }, placeholder: {
                        Image(systemName: "person.circle.fill")
                            .renderingMode(.original)
                            .font(.system(size: 60))
                    })
                    
                        .frame(width: 60, height: 60)
                        .clipShape(Circle())
                    Text(color.name)
                }
            }
            .searchable("Search color", text: $searchQuery, placement: .automatic){
                Text("re").searchCompletion("red")
                Text("b")
            }
            .navigationTitle("Async Images")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
