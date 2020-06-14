//
//  CoachTableViewCell.swift
//  InterviewTask
//
//  Created by Manish Mahajan  on 14/06/20.
//  Copyright © 2020 Manish Mahajan. All rights reserved.


import UIKit
import CoreData

class RecordTableViewCell : UITableViewCell {
    
    //On didSet cell will update with data
    var coach : Coach? {
        didSet {
            if let name = coach?.name {
                coachNameLabel.text = name.capitalized
            }
            if let timeTaken =  coach?.timetaken {
                completionTimeLabel.text = "Required Time:  "+timeTaken
            }
            if let createdAt = coach?.creationDate {
                datelabel.text = "Recorded At:  "+createdAt.toString()
            }
            
            if let rank = coach?.rank {
                rankLabel.text = "\(rank)"
                
            }
        }
    }
    
    private let coachNameLabel : UILabel = {
        let lbl = UILabel()
        lbl.textColor = UIColor.FlatColor.SecondaryColor
        lbl.font = UIFont.boldSystemFont(ofSize: 20)
        lbl.textAlignment = .left
        return lbl
    }()
    
    
    private let completionTimeLabel  : UILabel = {
        let lbl = UILabel()
        lbl.textColor = UIColor.FlatColor.SecondaryColor
        lbl.font = UIFont.systemFont(ofSize: 16)
        lbl.textAlignment = .left
        lbl.numberOfLines = 0
        return lbl
    }()
    
    var datelabel : UILabel =  {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .left
        label.text = "22 July 2019"
        label.textColor = UIColor.FlatColor.SecondaryColor
        return label
        
    }()
    
    var rankLabel : UILabel =  {
        let label = UILabel()
        label.backgroundColor = UIColor.lightText
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.textAlignment = .center
        label.text = "1"
        label.textColor = UIColor.FlatColor.PrimaryColor
        return label
        
    }()
    
    //Cell UI update
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(rankLabel)
        let stackView = UIStackView(arrangedSubviews: [coachNameLabel,completionTimeLabel,datelabel])
        stackView.distribution = .equalSpacing
        stackView.axis = .vertical
        stackView.spacing = 8
        
        addSubview(stackView)
        rankLabel.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: 20, paddingLeft: 8, paddingBottom: 20, paddingRight: 10, width: 50, height: 0, enableInsets: false)
        
        stackView.anchor(top: topAnchor, left: rankLabel.rightAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 20, paddingLeft: 8, paddingBottom: 20, paddingRight: 10, width: 0, height: 0, enableInsets: false)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
