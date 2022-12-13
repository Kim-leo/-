//
//  MessageViewController.swift
//  ToyProject
//
//  Created by 밥스엉클_IT개발팀_팀장 김승현 on 2022/12/07.
//

import UIKit

class MessageViewController: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableFooterView: UIView!
    
    @IBOutlet var emojiBtns: [UIButton]!
    let emojiArray = ["❤️", "🙌", "🔥", "👏", "😢", "😍", "😮", "😂"]
    
    @IBOutlet weak var myProfileBtn: UIButton!
    
    @IBOutlet weak var leaveCommentTF: UITextField!
    
    let profileIDArray = ["Sam", "Tom", "Jenny", "Lily", "Nathan"]
    let commentsArray = ["wow this is awesome.", "wow this is awesome.Bobsuncle is the best company.", "wow this is awesome.Bobsuncle is the best company.When is lunch time?", "wow this is awesome.Bobsuncle is the best company.When is lunch time?My name is Lily.", "I'm from the U.K.wow this is awesome.Bobsuncle is the best company.When is lunch time?My name is Lily.wow this is awesome.Bobsuncle is the best company.When is lunch time?My name is Lily."]
    
    var textViewYValue = CGFloat(0)
    
    override func viewWillAppear(_ animated: Bool) {
//        self.leaveCommentTF.becomeFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        title = "댓글"
        let nibName = UINib(nibName: "MessageCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "messageCell")
        
        settingForTableFooterView()
        
        keyboardCheck()
        
        
    }
    
    func settingForTableFooterView() {
        
        for i in emojiBtns {
            i.setTitle(emojiArray[i.tag], for: .normal)
        }
        leaveCommentTF.layer.masksToBounds = true
        leaveCommentTF.layer.cornerRadius = CGFloat(leaveCommentTF.frame.height / 2)
        leaveCommentTF.delegate = self
        
    }
    
    @IBAction func emojiBtnTapped(_ sender: UIButton) {
        print(sender.currentTitle ?? "")
    }
    
    func keyboardCheck() {
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow), name: UIResponder.keyboardDidShowNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow), name: UIResponder.keyboard, object: <#T##Any?#>)
    }
    
//    @objc func keyboardWillShow(notification: NSNotification) {
//        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
//            if self.tableFooterView.frame.origin.y == 0 {
//                self.tableFooterView.frame.origin.y += keyboardSize.height + UIApplication.shared.windows.first!.safeAreaInsets.bottom
//            }
//        }
//        print("will show")
//    }
    
    @objc func keyboardDidShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if textViewYValue == 0 {
                textViewYValue = self.tableFooterView.frame.origin.y
            }
            
            if self.tableFooterView.frame.origin.y == textViewYValue {
                textViewYValue = self.tableFooterView.frame.origin.y
                self.tableFooterView.frame.origin.y -= keyboardSize.height - UIApplication.shared.windows.first!.safeAreaInsets.bottom
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.tableFooterView.frame.origin.y != textViewYValue {
            self.tableFooterView.frame.origin.y = textViewYValue
        }
    }
    
    

    

}

extension MessageViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        leaveCommentTF.endEditing(true)
        leaveCommentTF.resignFirstResponder()
        print(leaveCommentTF.text ?? "")
        
        return true
    }
    
    
}

extension MessageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: MessageCell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as? MessageCell else { return UITableViewCell() }
        cell.profileIdLabel?.text = "\(profileIDArray[indexPath.row])  \(commentsArray[indexPath.row])"
        cell.profileIdLabel?.bold(targetString: "\(profileIDArray[indexPath.row])")
        
        
        return cell
    }
}


extension UILabel {
    func asFont(targetString: String, font: UIFont) {
        let fullText = text ?? ""
        let attributedString = NSMutableAttributedString(string: fullText)
        let range = (fullText as NSString).range(of: targetString)
        attributedString.addAttribute(.font, value: font, range: range)
        attributedText = attributedString
    }
}
