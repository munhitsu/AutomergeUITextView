//
//  DocumentCachingTextStorage.swift
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
 In this example UITextView interfaces with Document through NSMutableAttributedString cache
 It is a safe bet from performance perspective as e.g. var string: String is called multiple times per user action. func attributes() is also heavily used
 We are also getting nice attribute store to implement any needed formatting
 */
class DocumentCachingTextStorage: NSTextStorage, ObservableObject {
    private var cache:NSMutableAttributedString // also works proxying to NSTextStorage()
    private var doc:Document
    var textId:ObjId! {
        switch try! doc.get(obj: ObjId.ROOT, key: "text") {
        case .Object(let id, .Text):
            return id
        default:
            return nil //this will return fatal error
        }
    }

    override init() {
        doc = Document()
        _ = try! doc.putObject(obj: ObjId.ROOT, key: "text", ty: .Text)
        cache = NSMutableAttributedString()
        super.init()
    }
    
    override init(string: String) {
        doc = Document()
        let textId = try! doc.putObject(obj: ObjId.ROOT, key: "text", ty: .Text)
        try! doc.spliceText(obj: textId, start: 0, delete: 0, value: string)
        cache = NSMutableAttributedString(string: string)
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var string: String { // this gets called all the time - make sure it's cheap
        return cache.string
    }
    
    override func replaceCharacters(in range: NSRange, with str: String) {
        beginEditing()
        try! doc.spliceText(obj: textId, start: UInt64(range.location), delete: Int64(range.length), value: str)
        cache.replaceCharacters(in: range, with: str)
        edited(.editedCharacters, range: range, changeInLength: str.count - range.length)
        endEditing()
    }
    
    override func attributes(at location: Int, effectiveRange range: NSRangePointer?) -> [NSAttributedString.Key : Any] {
        return cache.attributes(at: location, effectiveRange: range)
    }
    
    override func setAttributes(_ attrs: [NSAttributedString.Key : Any]?, range: NSRange) {
        beginEditing()
//        data.setAttributes(attrs, range: range)
        edited(.editedAttributes, range: range, changeInLength: 0)
        endEditing()
    }
    
}
