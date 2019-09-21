//
//  AboutViewController.swift
//  The D
//
//  Created by FangRongJie on 2018/8/30.
//  Copyright © 2018年 TQMAX-Lemon. All rights reserved.
//

import UIKit

class AboutViewController: BaseViewController {

    private lazy var icon_v : UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage (named: "about")
        return iv
    }()
    
    private lazy var contents : UITextView = {
        let ct = UITextView()
        ct.text = "本APP仅为个人爱好所制造，无任何商业利益，如有侵权，请联系删之\n如有更好的建议和改进也可以在微博联系我，最好希望能得到鼠绘官方的支持😁\n以下是本人微博:\nhttps://weibo.com/tqmax"
        ct.font = UIFont.systemFont(ofSize: 14)
        return ct
    }()
    
    private lazy var canYou : UILabel = {
        let cy = UILabel()
        cy.text = "可以请我喝可乐吗😁"
        cy.numberOfLines = 0
        return cy
    }()
    
    private lazy var QR_Code_View : UIImageView = {
        let qr = UIImageView()
        qr.image = UIImage (named: "QR code")
        qr.contentMode = .scaleAspectFit
        return qr
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "关于及声明"
        
    }

    override func configUI() {
        view.addSubview(icon_v)
        icon_v .snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(80)
            make.size.equalTo(CGSize(width: 200, height: 200))
            make.centerX.equalToSuperview()
        }
        view.addSubview(contents)
        contents.snp.makeConstraints { (make) in
            make.top.equalTo(icon_v.snp.bottom).offset(20)
            make.size.equalTo(CGSize(width: 300, height: 120))
            make.centerX.equalToSuperview()
        }
        view.addSubview(canYou)
        canYou.snp.makeConstraints { (make) in
            make.top.equalTo(contents.snp.bottom).offset(20)
            make.width.equalTo(22)
            make.left.equalToSuperview().offset(50)
        }
        view.addSubview(QR_Code_View)
        QR_Code_View.snp.makeConstraints { (make) in
            make.top.equalTo(contents.snp.bottom).offset(10)
            make.left.equalTo(canYou.snp.right).offset(15)
            make.bottom.right.equalToSuperview().offset(-15)
        }
    }
    

}
