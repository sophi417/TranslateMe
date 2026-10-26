//
//  ContentView.swift
//  TranslateMe
//
//  Created by Sophia Sartor on 10/25/26.
//

//
//  ContentView.swift
//  TranslateMe
//

import SwiftUI

struct ContentView: View {

    @StateObject private var manager = TranslationManager()

    @State private var inputText = ""
    @State private var fromLang = "en"
    @State private var toLang = "es"
    @State private var showClearAlert = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {

                    // language pickers
                    HStack {
                        Picker("From", selection: $fromLang) {
                            ForEach(languages, id: \.code) { lang in
                                Text(lang.name).tag(lang.code)
                            }
                        }

                        // swap button
                        Button {
                            let temp = fromLang
                            fromLang = toLang
                            toLang = temp
                        } label: {
                            Image(systemName: "arrow.left.arrow.right")
                        }

                        Picker("To", selection: $toLang) {
                            ForEach(languages, id: \.code) { lang in
                                Text(lang.name).tag(lang.code)
                            }
                        }
                    }

                    // input field
                    TextField("Enter a word, phrase or sentence", text: $inputText, axis: .vertical)
                        .lineLimit(3...5)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(12)

                    // translate button
                    Button {
                        Task {
                            await manager.translate(text: inputText, from: fromLang, to: toLang)
                        }
                    } label: {
                        if manager.isLoading {
                            ProgressView()
                                .frame(maxWidth: .infinity)
                        } else {
                            Text("Translate")
                                .bold()
                                .frame(maxWidth: .infinity)
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.purple)
                    .disabled(inputText.isEmpty || manager.isLoading)

                    // output field (empty at first)
                    Text(manager.translatedText.isEmpty ? "Translation will show here" : manager.translatedText)
                        .foregroundColor(manager.translatedText.isEmpty ? .gray : .primary)
                        .frame(maxWidth: .infinity, minHeight: 80, alignment: .topLeading)
                        .padding()
                        .background(Color.purple.opacity(0.1))
                        .cornerRadius(12)

                    if let error = manager.errorMessage {
                        Text(error)
                            .foregroundColor(.red)
                            .font(.footnote)
                    }

                    // history section
                    HStack {
                        Text("History")
                            .font(.title2)
                            .bold()
                        Spacer()
                        Button("Clear", role: .destructive) {
                            showClearAlert = true
                        }
                        .disabled(manager.history.isEmpty)
                    }
                    .padding(.top)

                    if manager.history.isEmpty {
                        Text("No translations yet")
                            .foregroundColor(.gray)
                    }

                    ForEach(manager.history) { item in
                        VStack(alignment: .leading, spacing: 4) {
                            Text("\(item.fromLang.uppercased()) → \(item.toLang.uppercased())")
                                .font(.caption)
                                .foregroundColor(.purple)
                            Text(item.original)
                                .foregroundColor(.gray)
                            Text(item.translated)
                                .bold()
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(10)
                    }
                }
                .padding()
            }
            .navigationTitle("TranslateMe")
            .alert("Clear all history?", isPresented: $showClearAlert) {
                Button("Clear", role: .destructive) {
                    manager.clearHistory()
                }
                Button("Cancel", role: .cancel) { }
            }
        }
    }
}

#Preview {
    ContentView()
}
