//
//  ContentView.swift
//  WordScramble
//
//  Created by Juliette Rapala on 10/3/20.
//

import SwiftUI

struct ContentView: View {
    @State private var usedWords = [String]()
    @State private var rootWord = ""
    @State private var newWord = ""
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Enter your word", text: $newWord, onCommit: addNewWord)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .autocapitalization(.none)
                
                List(usedWords, id: \.self) {
                    // Add icon with word length in circle (1-50 is available)
                    Image(systemName: "\($0.count).circle")
                    Text($0)
                }
            }
            .navigationBarTitle(rootWord)
        }
    }
    
    func addNewWord() {
        // 1. Lowercase the newWord and trim
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        // 2. Check if there is at least one character
        guard answer.count > 0 else {
            return
        }
        
        // 3. Insert the word at beginning of usedWords
        usedWords.insert(answer, at: 0)
        
        // 4. Reset newWord
        newWord = ""
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}