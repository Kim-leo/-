//
//  ViewController.swift
//  ToyProject
//
//  Created by 밥스엉클_IT개발팀_팀장 김승현 on 2022/12/02.
//

import UIKit

class VideoViewController: UIViewController {
    // MARK: - UI Components
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var likeBtn: UIButton!
    
    var isLikeBtnTapped: Bool = false
    typealias cellForVideo = VideoCell
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.footerReferenceSize = .zero
        layout.headerReferenceSize = .zero
        
        let v = UICollectionView(frame: .zero, collectionViewLayout: layout)
        v.isScrollEnabled = true
        v.isPagingEnabled = true
        v.showsHorizontalScrollIndicator = false
        v.backgroundColor = .black
        v.register(VideoCell.self, forCellWithReuseIdentifier:  "VideoCell")
        return v
    }()
    
    private var cardContents: [String] = ["verticalVideo.mp4", "vertical2.mp4"]
//    private var cardContents: [String] = ["SK1.mp4", "SK2.mp4"]
    
    
    
    // MARK: - Life cycle
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(userTookScreenShot(_:)), name: UIApplication.userDidTakeScreenshotNotification, object: nil)
        
        backView.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionViewLayout()
        
        NotificationCenter.default.addObserver(self, selector: #selector(appMovedToForeground(_:)), name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(appMovedToBackground(_:)), name: UIScene.willDeactivateNotification, object: nil)
        
    }
        
    override func viewWillDisappear(_ animated: Bool) {
        initCartView()
    }
    
    
    // MARK: - 액션함수
    @objc func userTookScreenShot(_ notification: Notification) {
        let alert = UIAlertController(title: "ScreenSHot", message: "detected", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func cameraBtnTapped(_ sender: UIButton) {
        let ac = UIAlertController(title: "퇴근", message: "퇴근시켜줘!", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "어림없는 소리!", style: .default)
        ac.addAction(okAction)
        self.present(ac, animated: true)
    }
    
    @IBAction func messageBtnTapped(_ sender: UIButton) {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "MessageViewController") as? MessageViewController else { return }
//        vc.modalPresentationStyle = .pageSheet
//        self.present(vc, animated: true)
        
//        let vc = UIViewController()
//        vc.view.backgroundColor = .systemYellow
        vc.modalPresentationStyle = .pageSheet
        if let sheet = vc.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.delegate = self
            sheet.prefersGrabberVisible = true
        }
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func likeBtnTapped(_ sender: UIButton) {
        
        switch isLikeBtnTapped {
        case true:
            sender.isSelected = false
            isLikeBtnTapped = false
           
        case false:
            sender.isSelected = true
            isLikeBtnTapped = true
        default: break
        }
    }
    
    @IBAction func musicBtnTapped(_ sender: UIButton) {
        guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "MusicViewController") as? MusicViewController else { return }
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    
    @objc func appMovedToForeground(_ notification: Notification) {
        playFirstVisibleVideo()
    }
    
    @objc func appMovedToBackground(_ notification: Notification) {
        initCartView()
    }
    
    func initCartView() {
        playFirstVisibleVideo(false)
    }
    
    


}

extension VideoViewController: UISheetPresentationControllerDelegate {
    func sheetPresentationControllerDidChangeSelectedDetentIdentifier(_ sheetPresentationController: UISheetPresentationController) {
        print(sheetPresentationController.selectedDetentIdentifier == .large ? "large" : "medium")
    }
}


extension VideoViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VideoCell", for: indexPath) as! VideoCell
        cell.configure(video: cardContents[indexPath.item])
        return cell
    }
    
    func collectionViewLayout() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.leadingAnchor.constraint(equalTo: backView.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: backView.trailingAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: backView.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: backView.bottomAnchor).isActive = true
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
    }
    
    
}


extension VideoViewController {
    func playFirstVisibleVideo(_ shouldPlay: Bool = true) {
        let cells = collectionView.visibleCells.sorted {
            collectionView.indexPath(for: $0)?.item ?? 0 < collectionView.indexPath(for: $1)?.item ?? 0
        }
        let videoCells = cells.compactMap( { $0 as? VideoCell })
        if videoCells.count > 0 {
            let firstVisibleCell = videoCells.first(where: { checkVideoFrameVisibility(ofCell: $0) })
            for videoCell in videoCells {
                if shouldPlay && firstVisibleCell == videoCell {
                    videoCell.play()
                } else {
                    videoCell.pause()
                }
            }
        }
    }
    
    func checkVideoFrameVisibility(ofCell cell: VideoCell) -> Bool {
        var cellRect = cell.bounds
        cellRect = cell.convert(cell.bounds, to: collectionView.superview)
        return collectionView.frame.contains(cellRect)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        playFirstVisibleVideo()
    }
}
