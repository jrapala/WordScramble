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
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showingError = false
    
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
            .navigationBarItems(leading: Button("New Game") {
                startGame()
            })
        }
        .onAppear(perform: startGame)
        .alert(isPresented: $showingError) {
            Alert(title: Text(errorTitle), message: Text(errorMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    func addNewWord() {
        // 1. Lowercase the newWord and trim
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        // 2a. Check if there is at least one character
        guard answer.count > 0 else {
            return
        }
        
        // 2b. Check if the word has been used already
        guard isOriginal(word: answer) else {
            wordError(title: "Word used already", message: "Be more original")
            return
        }
        
        // 2b. Check if the word is a possible result
        guard isPossible(word: answer) else {
            wordError(title: "Word not recognized", message: "You can't just make them up, you know!")
            return
        }
        
        // 2c. Check if the word is real
        guard isReal(word: answer) else {
            wordError(title: "Word not possible", message: "That isn't a real word.")
            return
        }
        
        guard isLongEnough(word: answer) else {
            wordError(title: "Word is too short", message: "Word must be at least 3 letters long.")
            return
        }
        
        // 3. Insert the word at beginning of usedWords
        usedWords.insert(answer, at: 0)
        
        // 4. Reset newWord
        newWord = ""
    }
    
    func isOriginal(word: String) -> Bool {
        !usedWords.contains(word)
    }
    
    func isPossible(word: String) -> Bool {
        var tempWord = rootWord
        
        for letter in word {
            if let pos = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: pos)
            } else {
                return false
            }
        }
        
        return true
    }
    
    func isReal(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        return misspelledRange.location == NSNotFound
    }
    
    func isLongEnough(word: String) -> Bool {
        return word.count > 2
    }
    
    func wordError(title: String, message: String) {
        errorTitle = title
        errorMessage = message
        showingError = true
    }
    
    func startGame() {
        usedWords = [String]()

        // 1. Find the URL for the file in our app bundle
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            // 2. Load the file into a string
            if let startWords = try? String(contentsOf: startWordsURL) {
                // 3. Split the string into an array
                let allWords = startWords.components(separatedBy: "\n")
                
                // 4. Pick one randome word
                rootWord = allWords.randomElement() ?? "silkworm"
                
                // 5. Exit
                return
            }
        }
        
        // If any errors, trigger a crash
        fatalError("Could not load start.txt from bundle.")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
