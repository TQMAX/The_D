//
//  TheD_TableViewCell.swift
//  The D
//
//  Created by FangRongJie on 2018/8/7.
//  Copyright © 2018年 TQMAX-Lemon. All rights reserved.
//

import UIKit
import Kingfisher

class TheD_TableViewCell: UITableViewCell {

    //懒加载label
    var spinnerName: String?
    
    private  lazy var iconView: UIImageView = {
        let iw = UIImageView()
        iw.contentMode = .scaleAspectFill
        iw.clipsToBounds = true
        return iw
    }()
    
    private  lazy var titleLabel: UILabel = {
        let tl = UILabel()
        tl.textColor = UIColor.black
        return tl
    }()
    
    private lazy var subTitleLabel: UILabel = {
        let sl = UILabel()
        sl.textColor = UIColor.gray
        sl.textAlignment = .right
        sl.font = UIFont.systemFont(ofSize: 14)
        return sl
    }()
    
    private lazy var descLabel: UILabel = {
        let dl = UILabel()
        dl.textColor = UIColor.gray
        dl.numberOfLines = 3
        dl.font = UIFont.systemFont(ofSize: 14)
        return dl
    }()
    
    private lazy var tagLabel: UILabel = {
        let tl = UILabel()
        tl.textColor = UIColor.orange
        tl.font = UIFont.systemFont(ofSize: 14)
        return tl
    }()
    
    private lazy var orderView: UIImageView = {
        let ow = UIImageView()
        ow.contentMode = .scaleAspectFit
        return ow
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        
        super . init(style: style, reuseIdentifier: reuseIdentifier)
        
        separatorInset = .zero
        
        contentView.addSubview(iconView)
        iconView.snp.makeConstraints {
            $0.left.top.bottom.equalToSuperview().inset(UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 0))
            $0.width.equalTo(100)
        }
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.left.equalTo(iconView.snp.right).offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.height.equalTo(30)
            $0.top.equalTo(iconView)
        }
        
        contentView.addSubview(subTitleLabel)
        subTitleLabel.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-10)
            $0.height.equalTo(30)
            $0.bottom.equalTo(titleLabel.snp.bottom).offset(0)
        }
        
        contentView.addSubview(orderView)
        orderView.snp.makeConstraints {
            $0.bottom.equalTo(iconView.snp.bottom)
            $0.height.width.equalTo(30)
            $0.right.equalToSuperview().offset(-10)
        }
        
        contentView.addSubview(tagLabel)
        tagLabel.snp.makeConstraints {
            $0.left.equalTo(iconView.snp.right).offset(10)
            $0.right.equalTo(orderView.snp.left).offset(-10)
            $0.height.equalTo(20)
            $0.bottom.equalTo(iconView.snp.bottom)
        }
        
        contentView.addSubview(descLabel)
        descLabel.snp.makeConstraints {
            $0.left.equalTo(iconView.snp.right).offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.top.equalTo(titleLabel.snp.bottom).offset(5)
            $0.bottom.equalTo(tagLabel.snp.top)
        }
    }
    
//    var model:listModel?{
//        didSet {
//            iconView.kf.setImage(with: URL(string: (model?.FrontCover)!))
//            titleLabel.text = model?.Title
//            subTitleLabel.text = model?.Author
//            descLabel.text = model?.Explain
//            tagLabel.text = model?.LastChapter?.Sort
//        }
//    }
    
    var model : NovelData?{
        didSet{
            titleLabel.text = model?.Name
            subTitleLabel.text = model?.Author
            descLabel.text = model?.Desc
            tagLabel.text = model?.LastTime
            if (!(model?.Img!.contains("http"))!) {
                model?.Img! = "https://cdn2.jianshu.io/assets/default_avatar/8-a356878e44b45ab268a3b0bbaaadeeb7.jpg"
            }
            iconView.kf.setImage(with: URL(string: (model?.Img)!))
        }
    }

    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
