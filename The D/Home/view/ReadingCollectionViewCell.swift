//
//  ReadingCollectionViewCell.swift
//  The D
//
//  Created by FangRongJie on 2018/8/10.
//  Copyright © 2018年 TQMAX-Lemon. All rights reserved.
//

import UIKit
import Kingfisher

extension UIImageView: Placeholder {}

class ReadingCollectionViewCell: UICollectionViewCell {
    lazy var imageView: UIImageView = {
        let iw = UIImageView()
        iw.contentMode = .scaleAspectFit
        return iw
    }()
    
    lazy var placeholder: UIImageView = {
        let pr = UIImageView(image: UIImage(named: "mainBg"))
        pr.contentMode = .center
        return pr
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configUI() {
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()

//            $0.top.width.centerX.equalToSuperview()
        }
    }
    
    var image : String?{
        didSet{
            print(image as Any)
            if !(image? .isEqual(""))! {
                imageView.kf.setImage(with: URL (string: image!), placeholder: placeholder)
            }
        }
    }
    
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        return super.preferredLayoutAttributesFitting(layoutAttributes);
    }
    

}
