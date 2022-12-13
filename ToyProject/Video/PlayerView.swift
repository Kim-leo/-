//
//  PlayerView.swift
//  ToyProject
//
//  Created by 밥스엉클_IT개발팀_팀장 김승현 on 2022/12/02.
//

import UIKit
import AVKit

class PlayerView: UIView {
    static var videoIsMuted: Bool = true

    override class var layerClass: AnyClass {
        return AVPlayerLayer.self
    }
        
    private var assetPlayer:AVPlayer? {
        didSet {
            DispatchQueue.main.async {
                if let layer = self.layer as? AVPlayerLayer {
                    layer.player = self.assetPlayer
                }
            }
        }
    }
        
    private var playerItem:AVPlayerItem?
    private var urlAsset: AVURLAsset?
        
    var isMuted: Bool = true {
        didSet {
            self.assetPlayer?.isMuted = isMuted
        }
    }
        
    var url: URL?
        
    init() {
        super.init(frame: .zero)
        initialSetup()
    }
        
    required init?(coder: NSCoder) {
        super.init(frame: .zero)
        initialSetup()
    }
        
    private func initialSetup() {
        if let layer = self.layer as? AVPlayerLayer {
            layer.videoGravity = AVLayerVideoGravity.resizeAspect
        }
    }
        
    func prepareToPlay(withUrl url:URL, shouldPlayImmediately: Bool = false) {
        guard !(self.url == url && assetPlayer != nil && assetPlayer?.error == nil) else {
            if shouldPlayImmediately {
                play()
            }
            return
        }
            
        cleanUp()
        
        self.url = url
        
        let options = [AVURLAssetPreferPreciseDurationAndTimingKey : true]
        let urlAsset = AVURLAsset(url: url, options: options)
        self.urlAsset = urlAsset
            
        let keys = ["tracks"]
        urlAsset.loadValuesAsynchronously(forKeys: keys, completionHandler: { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.startLoading(urlAsset, shouldPlayImmediately)
        })
        NotificationCenter.default.addObserver(self, selector: #selector(self.playerItemDidReachEnd), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
    }
        
    private func startLoading(_ asset: AVURLAsset, _ shouldPlayImmediately: Bool) {
        var error:NSError?
        let status:AVKeyValueStatus = asset.statusOfValue(forKey: "tracks", error: &error)
        if status == AVKeyValueStatus.loaded {
            let item = AVPlayerItem(asset: asset)
            self.playerItem = item
            self.assetPlayer = AVPlayer(playerItem: item)
            self.didFinishLoading(self.assetPlayer, shouldPlayImmediately)
        }
    }
        
    private func didFinishLoading(_ player: AVPlayer?, _ shouldPlayImmediately: Bool) {
        guard let player = player, shouldPlayImmediately else { return }
        DispatchQueue.main.async {
            player.play()
        }
    }
        
    @objc private func playerItemDidReachEnd(_ notification: Notification) {
        guard notification.object as? AVPlayerItem == self.playerItem else { return }
        DispatchQueue.main.async {
            guard let videoPlayer = self.assetPlayer else { return }
            videoPlayer.seek(to: .zero)
            // videoPlayer.play() // 내가 생각한 카드뷰는 한번 재생하고 끝나면서 다음 카드로 넘어가고 하는거라 play 를 또 하면 영상이 겹쳐 들리는문제가 발생해서 뺐다.
        }
    }
        
    func play() {
        guard self.assetPlayer?.isPlaying == false else { return }
        DispatchQueue.main.async {
            self.assetPlayer?.play()
        }
    }
        
    func pause() {
        guard self.assetPlayer?.isPlaying == true else { return }
        DispatchQueue.main.async {
            self.assetPlayer?.pause()
            self.assetPlayer?.seek(to: .zero) // 여기도 셀을 떠났다가 해당 셀에 다시 들어가면 영상이 처음부터 실행되도록 하기 위해 변경.
        }
    }
        
    func cleanUp() {
        pause()
        urlAsset?.cancelLoading()
        urlAsset = nil
        assetPlayer = nil
        removeObservers()
    }
        
    func removeObservers() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
    }

    deinit {
        cleanUp()
    }
}
