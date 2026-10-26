//
//  TranslationManager.swift
//  TranslateMe
//

import Foundation
import FirebaseFirestore

@MainActor
class TranslationManager: ObservableObject {

    @Published var translatedText = ""
    @Published var history: [Translation] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let db = Firestore.firestore()
    private var listener: ListenerRegistration?

    init() {
        listenForHistory()
    }

    // MARK: - API

    // calls MyMemory and saves the result to firestore
    func translate(text: String, from: String, to: String) async {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.isEmpty { return }

        // build the url like: /get?q=hello&langpair=en|es
        var components = URLComponents(string: "https://api.mymemory.translated.net/get")!
        components.queryItems = [
            URLQueryItem(name: "q", value: trimmed),
            URLQueryItem(name: "langpair", value: "\(from)|\(to)")
        ]

        guard let url = components.url else { return }

        isLoading = true
        errorMessage = nil

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let result = try JSONDecoder().decode(MyMemoryResponse.self, from: data)
            translatedText = result.responseData.translatedText

            saveTranslation(original: trimmed, translated: translatedText, from: from, to: to)
        } catch {
            print("translate error: \(error)")
            errorMessage = "Couldn't translate. Try again."
        }

        isLoading = false
    }

    // MARK: - Firestore

    private func saveTranslation(original: String, translated: String, from: String, to: String) {
        db.collection("translations").addDocument(data: [
            "original": original,
            "translated": translated,
            "fromLang": from,
            "toLang": to,
            "date": Timestamp(date: Date())
        ]) { error in
            if let error = error {
                print("save error: \(error)")
            }
        }
    }

    // keeps history updated live, newest first
    private func listenForHistory() {
        listener = db.collection("translations")
            .order(by: "date", descending: true)
            .addSnapshotListener { [weak self] snapshot, error in
                guard let docs = snapshot?.documents else {
                    print("listen error: \(error?.localizedDescription ?? "unknown")")
                    return
                }

                let items = docs.map { doc -> Translation in
                    let data = doc.data()
                    return Translation(
                        id: doc.documentID,
                        original: data["original"] as? String ?? "",
                        translated: data["translated"] as? String ?? "",
                        fromLang: data["fromLang"] as? String ?? "",
                        toLang: data["toLang"] as? String ?? "",
                        date: (data["date"] as? Timestamp)?.dateValue() ?? Date()
                    )
                }

                Task { @MainActor in
                    self?.history = items
                }
            }
    }

    // deletes every doc in the collection
    func clearHistory() {
        db.collection("translations").getDocuments { snapshot, error in
            guard let docs = snapshot?.documents else { return }

            let batch = self.db.batch()
            for doc in docs {
                batch.deleteDocument(doc.reference)
            }
            batch.commit { error in
                if let error = error {
                    print("clear error: \(error)")
                }
            }
        }
    }
}
