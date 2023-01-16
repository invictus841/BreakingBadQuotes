//
//  ContentView.swift
//  BreakingBadQuotes
//
//  Created by Alexandre Talatinian on 16/01/2023.
//

import SwiftUI

struct ContentView: View {
    
    @State private var quotes = [Quote]()
    
    var body: some View {
        
            NavigationStack {
                
                ZStack {
                    Color("Laurel Green")
                        .ignoresSafeArea()
                    
                    ScrollView {
                        VStack {
                            ForEach(quotes, id: \.quote) { quote in
                                VStack {
                                    Text(quote.author)
                                        .font(.headline)
                                        .foregroundColor(Color("English Violet"))
                                    Text(quote.quote)
                                        .font(.body)
                                        .foregroundColor(.black.opacity(0.5))
                                }
                                .padding()
                            }
                           
                        }
                    }
                    Button("Refresh!") {
                        fetchDataAgain()
                    }
                    .buttonStyle(.borderedProminent)
                    .frame(maxHeight: .infinity, alignment: .bottom)
                }
                .navigationTitle("Breaking Bad Quotes")
                .task {
                    await fetchData()
                }
            }
        
    }
    
    func fetchDataAgain() {
        Task {
            await fetchData()
        }
    }
    
    func fetchData() async {
        // create url
        guard let url = URL(string: "https://api.breakingbadquotes.xyz/v1/quotes/15")
        else {
            print("This url does not seem to work.")
            return
        }
        
        // fetch data from url
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            // decode fetched data
            if let decodedResponse = try? JSONDecoder().decode([Quote].self, from: data) {
                quotes = decodedResponse
            }
        } catch {
            print("Walter is not happy cause this data is not valid.")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
