//
//  UIViewExtension.swift
//  ToyProject
//
//  Created by 밥스엉클_IT개발팀_팀장 김승현 on 2022/12/02.
//

import Foundation
import UIKit

extension UIView {
    // 모서리 둥글기
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    // 테두리 두께
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    // 테두리 컬러
    @IBInspectable var borderColor: UIColor? {
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
        set {
            guard let uiColor = newValue else { return }
            layer.borderColor = uiColor.cgColor
        }
    }
}


extension UILabel {
    
    // 레이블내의 특정문자열 볼드처리 메소드
    func bold(targetString: String) {
        let fontSize = self.font.pointSize
        let font = UIFont.boldSystemFont(ofSize: fontSize)
        let fullText = self.text ?? ""
        let range = (fullText as NSString).range(of: targetString)
        let attributedString = NSMutableAttributedString(string: fullText)
        attributedString.addAttribute(.font, value: font, range: range)
        self.attributedText = attributedString
    }
}

extension UIViewController {
    func emojiEncoding(_ inputString: String) -> String {
        let data = inputString.data(using: .nonLossyASCII, allowLossyConversion: true)!
        
        if let outputString = String(data: data, encoding: .utf8) {
            return outputString
        } else { return "" }
    }
    
    func emojiDecoding(_ inputString: String) -> String {
        let data = inputString.data(using: .utf8)!
        
        if let outputString = String(data: data, encoding: .nonLossyASCII) {
            return outputString
        } else { return "" }
    }
    
    func writeEmoji(_ inputEmoji: String) -> String {
        let dataEnc = inputEmoji.data(using: .nonLossyASCII, allowLossyConversion: true)!
        if let outputString = String(data: dataEnc, encoding: .utf8) {
            let dataDec = outputString.data(using: .utf8)!
            
            if let outputStringDecoded = String(data: dataDec, encoding: .nonLossyASCII) {
                return outputStringDecoded
            } else { return "" }
        } else { return ""}
    }
}
