//
//  ChaptersCollectionHead.swift
//  The D
//
//  Created by FangRongJie on 2018/8/9.
//  Copyright © 2018年 TQMAX-Lemon. All rights reserved.
//

import UIKit
import Kingfisher

class ChaptersCollectionHead: UICollectionReusableView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private  lazy var iconView: UIImageView = {
        let iw = UIImageView()
        iw.contentMode = .scaleAspectFill
        iw.clipsToBounds = true
        return iw
    }()
    
    private lazy var lastUpdateTimeLab: UILabel = {
        let vl = UILabel()
        vl.textColor = UIColor.gray
        vl.font = UIFont.systemFont(ofSize: 13)
        vl.textAlignment = .right
        vl.numberOfLines = 2
        return vl
    }()
    
    private lazy var authorLab: UILabel = {
        let vl = UILabel()
        vl.textColor = UIColor.gray
        vl.font = UIFont.systemFont(ofSize: 13)
        return vl
    }()
    
    private lazy var explainLab: UILabel = {
        let vl = UILabel()
        vl.numberOfLines = 0
        vl.textColor = UIColor.gray
        vl.font = UIFont.systemFont(ofSize: 13)
        return vl
    }()

    func configUI() {
        
        addSubview(iconView)
        iconView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.top.equalToSuperview().offset(15)
            make.bottom.equalToSuperview().offset(-15)
            make.width.equalTo(100)
        }
        
        addSubview(authorLab)
        authorLab.snp.makeConstraints { (make) in
            make.left.equalTo(iconView.snp.right).offset(15)
            make.top.equalTo(iconView).offset(0)
        }
        
        addSubview(explainLab)
        explainLab.snp.makeConstraints { (make) in
            make.left.equalTo(authorLab).offset(0)
            make.top.equalTo(authorLab.snp.bottom).offset(15)
            make.right.equalToSuperview().offset(-15)
        }
        
        addSubview(lastUpdateTimeLab)
        lastUpdateTimeLab.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-15)
            make.bottom.equalToSuperview().offset(-15)
        }
        
    }
    
    var model : listModel?{
        didSet{
            if (model?.FrontCover == nil) {
                return
            }
            iconView.kf.setImage(with: URL(string: (model?.FrontCover)!))
            authorLab.text = model?.Author
            explainLab.text = model?.Explain
            lastUpdateTimeLab.text = String (format: "%@ %@\n%@", (model?.LastChapter?.Sort)! , (model?.LastChapter?.Title)! , (model?.LastChapter?.RefreshTimeStr)!)
        }
    }
}
