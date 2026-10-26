//
//  Translation.swift
//  TranslateMe
//

import Foundation

// one saved translation in the history
struct Translation: Identifiable {
    let id: String          // firestore document id
    let original: String
    let translated: String
    let fromLang: String
    let toLang: String
    let date: Date
}

// what the MyMemory api sends back (only need the translated text)
struct MyMemoryResponse: Decodable {
    let responseData: ResponseData
}

struct ResponseData: Decodable {
    let translatedText: String
}

// languages for the pickers (stretch feature)
struct Language: Hashable {
    let name: String
    let code: String
}

let languages: [Language] = [
    Language(name: "English", code: "en"),
    Language(name: "Spanish", code: "es"),
    Language(name: "French", code: "fr"),
    Language(name: "Italian", code: "it"),
    Language(name: "German", code: "de"),
    Language(name: "Portuguese", code: "pt"),
    Language(name: "Japanese", code: "ja"),
    Language(name: "Korean", code: "ko")
]
