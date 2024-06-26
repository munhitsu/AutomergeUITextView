//
//  Note.swift
//  AutomergeUITextView
//
//  Created by Mateusz Łapsa-Malawski on 12/04/2024.
//

import Foundation
import SwiftUI
import Automerge

import OSLog
private let logger = Logger(subsystem: "AutomergeUITextView", category: "DocumentTextStorage")


/**
 In this example UITextView interfaces directry with Document
 Just an example to get a feeling of performance
 */

class DocumentTextStorage: NSTextStorage, ObservableObject {
    private var doc:Document
    private var textId:ObjId

    override init() {
        doc = Document()
        textId = try! doc.putObject(obj: ObjId.ROOT, key: "text", ty: .Text)
        super.init()
    }
    
    override init(string: String) {
        doc = Document()
        textId = try! doc.putObject(obj: ObjId.ROOT, key: "text", ty: .Text)
        try! doc.spliceText(obj: textId, start: 0, delete: 0, value: string)
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var string: String { // this gets called all the time - make sure it's cheap
        let str = try! doc.text(obj: textId)
        return str
    }
    
    override func replaceCharacters(in range: NSRange, with str: String) {
        beginEditing()
        try! doc.spliceText(obj: textId, start: UInt64(range.location), delete: Int64(range.length), value: str)
        edited(.editedCharacters, range: range, changeInLength: str.count - range.length)
        endEditing()
    }
    
    override func attributes(at location: Int, effectiveRange range: NSRangePointer?) -> [NSAttributedString.Key : Any] {
        // example implementation where we always return that there are no attributes assigned throughout the document
        // when productionising consider processing Marks
        if let range = range {
           range.pointee = NSRange(location: 0, length: length)
        }
        return [:]
    }
    
    override func setAttributes(_ attrs: [NSAttributedString.Key : Any]?, range: NSRange) {
        beginEditing()
        edited(.editedAttributes, range: range, changeInLength: 0)
        endEditing()
    }
    
    override var length: Int {
        return Int(doc.length(obj: textId))
    }
}
