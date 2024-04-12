//
//  DocumentTextView.swift
//  AutomergeUITextView
//
//  Created by Mateusz Łapsa-Malawski on 12/04/2024.
//

import Foundation
import SwiftUI
import Automerge

import OSLog
private let logger = Logger(subsystem: "AutomergeUITextView", category: "DocumentTextView")


@MainActor struct DocumentTextView: UIViewRepresentable {
//    typealias UIViewType = UITextView

    var note: DocumentTextStorage
//    var document: Document
//    var mutableString: NSMutableAttributedString
    
    func makeUIView(context: Context) -> UITextView {
        let textLayoutManager = NSTextLayoutManager()
        let textContainer = NSTextContainer()
        textLayoutManager.textContainer = textContainer
        
        let textContentStorage = NSTextContentStorage()
//        let textStorage = note
        textContentStorage.textStorage = ProxyNSTextStorage(string: "Proxy Hello World")
        textContentStorage.addTextLayoutManager(textLayoutManager)
        


                
//        let textView = UITextView(usingTextLayoutManager: true)
//        textView.frame = .infinite
//        textView.textLayoutManager = textLayoutManager
        let textView = UITextView(frame: .infinite, textContainer: textLayoutManager.textContainer)
        textView.delegate = context.coordinator
        
        guard let _ = textView.textLayoutManager else {
            fatalError("We are not in TextKit2 mode")
        }

        //        textLayoutManager.textContainer = textContainer
//        textContentStorage.addTextLayoutManager(textLayoutManager)

        //        textView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        textView.isScrollEnabled = true
        textView.isEditable = true
        textView.isUserInteractionEnabled = true
        textView.isSelectable = true
        textView.textContainerInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        textView.backgroundColor = .clear
        context.coordinator.view = textView
        return textView
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    /*
     will be triggered by new text in the parent view
     */
    func updateUIView(_ textView: UITextView, context: Context) {
        logger.debug("updateUIView()")
    }
    
    class Coordinator: NSObject, UITextViewDelegate {
        var parent: DocumentTextView
        var view: UITextView!
        
        init(_ documentTextView: DocumentTextView) {
            self.parent = documentTextView
            super.init()
//            NotificationCenter.default.addObserver(self, selector: #selector(textStorageDidEndEditing), name: NSTextStorage.didProcessEditingNotification , object: nil)
        }
        
        func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            logger.debug("Text is about to change from '\(textView.text ?? "")' at \(range) to `\(text)`")
            return true
        }
        
        /*
         is executed on every character change
         in response to user-initiated changes to the text
         */
        func textViewDidChange(_ textView: UITextView) {
            logger.debug("textViewDidChange")
        }
        
        func textViewDidBeginEditing(_ textView: UITextView) {
            logger.debug("textViewDidBeginEditing")
        }
        
        func textViewDidEndEditing(_ textView: UITextView) {
            logger.debug("textViewDidEndEditing")
        }
        
        @objc func textStorageDidEndEditing(notification: Notification) {
            logger.debug("textStorageDidEndEditing")
        }
                
        func textViewDidChangeSelection(_ textView: UITextView) {
            logger.debug("textStorageDidEndEditing")
        }
        
//        deinit {
//            NotificationCenter.default.removeObserver(self)
//        }
    }
}
