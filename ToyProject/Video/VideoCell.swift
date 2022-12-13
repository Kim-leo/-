//
//  VideoCell.swift
//  ToyProject
//
//  Created by 밥스엉클_IT개발팀_팀장 김승현 on 2022/12/02.
//

import UIKit

class VideoCell: UICollectionViewCell {
    
    private let playerView = PlayerView()
    
    var url: URL?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    func setupUI() {
        self.contentView.addSubview(playerView)
        playerView.translatesAutoresizingMaskIntoConstraints = false
        playerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        playerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        playerView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        playerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
    func play() {
        if let url = url {
            playerView.prepareToPlay(withUrl: url, shouldPlayImmediately: true)
        }
    }
    
    func pause() {
        playerView.pause()
    }
    
    func configure(video file: String) {
        let file = file.components(separatedBy: ".")
        guard let path = Bundle.main.path(forResource: file[0], ofType: file[1]) else {
            debugPrint(" \(file.joined(separator: ".")) not found")
            return
        }
        let url = URL(fileURLWithPath: path)
        self.url = url
        playerView.prepareToPlay(withUrl: url, shouldPlayImmediately: false)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

