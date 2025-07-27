//
//  String+.swift
//  Assignment-ShoppingList
//
//  Created by 김민성 on 7/28/25.
//

import Foundation


extension String {
    
    
    /// returns empty attributed string when failed to decode.
    var readHTMLToAttributed: NSAttributedString {
        guard let titleTextData = data(using: .utf8) else {
            return NSAttributedString(string: "")
        }
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        let atrString = try? NSAttributedString(
            data: titleTextData,
            options: options,
            documentAttributes: nil
        )
        return atrString ?? NSAttributedString(string: "")
    }
    
    /// returns empty string when failed to decode.
    var readHTML: String {
        guard let titleTextData = data(using: .utf8) else {
            return ""
        }
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        let atrString = try? NSAttributedString(
            data: titleTextData,
            options: options,
            documentAttributes: nil
        )
        return atrString?.string ?? ""
    }
    
}
