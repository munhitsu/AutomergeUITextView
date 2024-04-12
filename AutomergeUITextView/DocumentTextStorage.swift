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


// https://forums.swift.org/t/so-how-do-you-implement-a-nstextstorage-subclass-in-swift/5141/2

class DocumentTextStorage: NSTextStorage, ObservableObject {
    
    var attributedString:NSMutableAttributedString
    var doc: Document
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
        attributedString = NSMutableAttributedString()
        super.init()
    }
    
    override init(string: String) {
        doc = Document()
        let textId = try! doc.putObject(obj: ObjId.ROOT, key: "text", ty: .Text)
        try! doc.spliceText(obj: textId, start: 0, delete: 0, value: string)
        attributedString = NSMutableAttributedString(string: string)
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - NSTextStorage
        
    
    override var string: String {
        logger.debug("string")
        return attributedString.string
    }

//    
//    
//    
//    override var string: String {
//        logger.debug("string")
//        let str = try! doc.text(obj: textId)
//        return str
//    }
    
    override func attributes(at location: Int, effectiveRange range: NSRangePointer?) -> [NSAttributedString.Key: Any] {
        // Return the attributes for the given location
        // You can customize this based on your requirements
        return [:]
    }
    
    override func replaceCharacters(in range: NSRange, with str: String) {
        try! doc.spliceText(obj: textId, start: UInt64(range.location), delete: Int64(range.length), value: str)
        edited(.editedCharacters, range: range, changeInLength: (str as NSString).length - range.length)
    }
    
    override func setAttributes(_ attrs: [NSAttributedString.Key: Any]?, range: NSRange) {
        // Set the attributes for the specified range
        // You can customize this based on your requirements
        edited(.editedAttributes, range: range, changeInLength: 0)
    }
}
