//
//  ReadingTopBar.swift
//  The D
//
//  Created by FangRongJie on 2018/8/10.
//  Copyright © 2018年 TQMAX-Lemon. All rights reserved.
//

import UIKit

class ReadingTopBar: UIView {

    lazy var backButton: UIButton = {
        let bn = UIButton(type: .custom)
        bn.setImage(UIImage(named: "nav_back"), for: .normal)
        return bn
    }()
    
    lazy var titleLabel: UILabel = {
        let tl = UILabel()
        tl.textAlignment = .center
        tl.textColor = UIColor.black
        tl.font = UIFont.boldSystemFont(ofSize: 18)
        return tl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configUI() {
        
        addSubview(backButton)
        
        backButton.snp.makeConstraints {
            $0.width.height.equalTo(40)
            $0.left.centerY.equalToSuperview()
        }
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 50, bottom: 0, right: 50))
        }
    }
}
