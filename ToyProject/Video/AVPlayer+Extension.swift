//
//  AVPlayer+Extension.swift
//  ToyProject
//
//  Created by 밥스엉클_IT개발팀_팀장 김승현 on 2022/12/02.
//

import Foundation
import AVKit

extension AVPlayer {
    var isPlaying: Bool {
        get {
            return (self.rate != 0 && self.error == nil)
        }
    }
}
