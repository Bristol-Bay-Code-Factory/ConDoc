//
//  Document.swift
//  ConDoc
//
//  Created by Philip Pegden on 11/08/2021.
//

import SwiftUI
import UniformTypeIdentifiers

extension UTType {
    static var conDocExample: UTType { UTType(importedAs: "com.example.condoc") }
}

final class Document: ReferenceFileDocument {
	
	@Published var content: RecordsViewModel?
	
	init() {
		Task { await MainActor.run { self.content = RecordsViewModel() } }
	}
	
	static var readableContentTypes: [UTType] { [.conDocExample] }
	
	init(configuration: ReadConfiguration) throws {
		guard let data = configuration.file.regularFileContents else {
			throw CocoaError(.fileReadCorruptFile)
		}
		let decoder = JSONDecoder()
		let store = try decoder.decode(RecordsModel.self, from: data)
		Task { self.content = await RecordsViewModel(fromRecordsModel: store) }
	}
	
	struct DocumentSnapshot { var data: Data }
	
	typealias Snapshot = DocumentSnapshot
	
	func snapshot(contentType: UTType) throws -> DocumentSnapshot {
		// Waiting to add Encodable conformance to RecordsModel
		DocumentSnapshot(data: Data())
		
	}
	
	func fileWrapper(snapshot: DocumentSnapshot, configuration: WriteConfiguration) throws -> FileWrapper {
		FileWrapper(regularFileWithContents: snapshot.data)
	}
}
