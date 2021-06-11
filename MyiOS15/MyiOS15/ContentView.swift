//
//  ContentView.swift
//  MyiOS15
//
//  Created by Cédric Bahirwe on 11/06/2021.
//

import SwiftUI

struct Colors: Identifiable {
    let id = UUID()
    var name: String
}

// Async Image
// Searchable List
// Refreshable List
// listSeparator

let imageUrl = "https://source.unsplash.com/random"

struct ContentView: View {
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
            let _ = Self._printChanges()
            List {
                ForEach(searchResults) { color in
                    RowView(color: color)
                        .listRowSeparator(.visible)
                        .listRowSeparatorTint(nil)
                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                            
                            Button(role: .destructive, action: {
                                withAnimation {
                                    if let index = colors.firstIndex(where: { $0.id == color.id}) {
                                        colors.remove(at: index)
                                    }
                                }
                            }) {
                                Label("Delete", systemImage: "xmark.bin")
                            }
                        }
                    
                        .swipeActions(edge: .leading, allowsFullSwipe: true) {
                            Button(action: { }) {
                                Label("Pin", systemImage: "pin")
                            }
                        }
                }
            }
            
            .searchable("Search color", text: $searchQuery, placement: .automatic)
            .refreshable {
                colors.append(Colors(name: colors.randomElement()!.name))
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

struct RowView: View {
    let color: Colors
    var body: some View {
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
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
