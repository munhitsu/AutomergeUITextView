//
//  ProxyNSTextStorage.swift
//  AutomergeUITextView
//
//  Created by Mateusz Łapsa-Malawski on 12/04/2024.
//

import Foundation
import SwiftUI

class ProxyNSTextStorage: NSTextStorage {
    private var data = NSTextStorage()
    
    
    override init(string: String) {
        super.init()
        data = NSTextStorage(string: string)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var string: String {
        data.string
    }

    override func replaceCharacters(in range: NSRange, with str: String) {
        beginEditing()
        data.replaceCharacters(in: range, with: str)
        edited(.editedCharacters, range: range, changeInLength: str.count - range.length)
        endEditing()
    }
    
    override func attributes(at location: Int, effectiveRange range: NSRangePointer?) -> [NSAttributedString.Key : Any] {
        return data.attributes(at: location, effectiveRange: range)
    }

    override func setAttributes(_ attrs: [NSAttributedString.Key : Any]?, range: NSRange) {
        beginEditing()
        data.setAttributes(attrs, range: range)
        edited(.editedAttributes, range: range, changeInLength: 0)
        endEditing()
    }
}
