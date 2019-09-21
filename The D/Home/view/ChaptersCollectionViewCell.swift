//
//  ChaptersCollectionViewCell.swift
//  The D
//
//  Created by FangRongJie on 2018/8/9.
//  Copyright © 2018年 TQMAX-Lemon. All rights reserved.
//

import UIKit

class ChaptersCollectionViewCell: UICollectionViewCell {
    
    private var titleLab : UILabel = {
        let tl = UILabel()
        tl.font = UIFont .systemFont(ofSize: 16)
        tl.textColor = UIColor.darkGray
        tl.text = "666话 测试"
        return tl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configUI(){
        contentView.backgroundColor = UIColor.white
        layer.cornerRadius = 5
        layer.borderWidth = 1
        layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        layer.masksToBounds = true

        contentView .addSubview(titleLab)
        titleLab.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
        }
    }
    
    var model:listModel?{
        didSet{
            titleLab.text = String (format: "%d %@",arguments:[ (model?.ChapterNo)!, (model?.Title)!])
        }
    }
}
