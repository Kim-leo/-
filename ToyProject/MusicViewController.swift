//
//  MusicViewController.swift
//  ToyProject
//
//  Created by 밥스엉클_IT개발팀_팀장 김승현 on 2022/12/02.
//

import UIKit

class MusicViewController: UIViewController {
    // MARK: - UI Components & 변수
    
    
    // MARK: - Life cycle
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        NotificationCenter.default.addObserver(self, selector: #selector(userTookScreenShot(_:)), name: UIApplication.userDidTakeScreenshotNotification, object: nil)
    }
    
    // MARK: - Action functions
    @objc func userTookScreenShot(_ notification: Notification) {
        let alert = UIAlertController(title: "ScreenSHot", message: "detected", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func backBarBtnTapped(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
