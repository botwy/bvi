//
//  String+Extensions.swift
//  bvi
//
//  Created by Елена Гончарова on 24.08.2023.
//

import UIKit

extension String {
    func parsedBold(fontSize: CGFloat) -> NSAttributedString? {
        let regexpBold = try? NSRegularExpression(pattern: "<b>(.*?)</b>", options: .caseInsensitive)
        guard let regexpBold = regexpBold else { return nil }
        let matches = regexpBold.matches(in: self, range: NSRange(location: .zero, length: self.utf16.count))
        
        let mutableStr = NSMutableAttributedString(string: self)
        mutableStr.addAttributes([.font : UIFont.systemFont(ofSize: fontSize)], range: NSRange(location: .zero, length: self.utf16.count))
        matches.forEach {
            mutableStr.addAttributes([.font : UIFont.boldSystemFont(ofSize: fontSize)], range: $0.range)
        }
        var offset = 0
        matches.forEach {
            let openCount = "<b>".utf16.count
            let closeCount = "</b>".utf16.count
            mutableStr.replaceCharacters(in: NSRange(location: $0.range.location - offset, length: openCount), with: "")
            offset += openCount
            mutableStr.replaceCharacters(in: NSRange(location: $0.range.location - offset + $0.range.length - closeCount, length: closeCount), with: "")
            offset += closeCount
        }
        return mutableStr
    }
    
    func htmlAttributedString() -> NSMutableAttributedString {
        guard let data = self.data(using: String.Encoding.utf8, allowLossyConversion: false) else {
            return NSMutableAttributedString()
        }
        
        guard let formattedString = try? NSMutableAttributedString(
            data: data,
            options: [
                .documentType: NSAttributedString.DocumentType.html,
                .characterEncoding: String.Encoding.utf8.rawValue
            ],
            documentAttributes: nil
        ) else {
            return NSMutableAttributedString()
        }
        
        return formattedString
    }
}

extension NSMutableAttributedString {
    func with(font: UIFont) -> NSMutableAttributedString {
        self.enumerateAttribute(NSAttributedString.Key.font, in: NSMakeRange(0, self.length), options: .longestEffectiveRangeNotRequired, using: { (value, range, stop) in
            if let originalFont = value as? UIFont,
               let newFont = applyTraitsFromFont(originalFont, to: font) {
                self.addAttribute(NSAttributedString.Key.font, value: newFont, range: range)
            }
        })
        return self
    }
    
    func applyTraitsFromFont(_ f1: UIFont, to f2: UIFont) -> UIFont? {
        let originalTrait = f1.fontDescriptor.symbolicTraits
        
        if originalTrait.contains(.traitBold) {
            var traits = f2.fontDescriptor.symbolicTraits
            traits.insert(.traitBold)
            if let fd = f2.fontDescriptor.withSymbolicTraits(traits) {
                return UIFont.init(descriptor: fd, size: 0)
            }
        }
        return f2
    }
}
