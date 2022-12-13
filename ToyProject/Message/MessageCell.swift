//
//  MessageCell.swift
//  ToyProject
//
//  Created by 밥스엉클_IT개발팀_팀장 김승현 on 2022/12/07.
//

import UIKit

class MessageCell: UITableViewCell {
    
    @IBOutlet weak var profileBtn: UIButton!
    @IBOutlet weak var profileIdLabel: UILabel!
    @IBOutlet weak var likeCommentBtn: UIButton!
    
    @IBOutlet weak var commentTime: UILabel!
    @IBOutlet weak var commentLikeNumLabel: UILabel!
    @IBOutlet weak var replyToCommentBtn: UIButton!
    @IBOutlet weak var sendCommentToBtn: UIButton!
    
    
    var isLikeBtnTapped: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupUIForComponents()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setupUIForComponents() {
        likeCommentBtn.tintColor = .darkGray
    }
    
    @IBAction func likeCommnetBtnTapped(_ sender: UIButton) {
        switch isLikeBtnTapped {
        case true:
            sender.tintColor = .darkGray
            sender.isSelected = false
            isLikeBtnTapped = false
            
           
        case false:
            sender.tintColor = .systemPink
            sender.isSelected = true
            isLikeBtnTapped = true
        default: break
        }
    }
    
    
}
