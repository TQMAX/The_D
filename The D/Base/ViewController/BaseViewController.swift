//
//  BaseViewController.swift
//  The D
//
//  Created by FangRongJie on 2018/8/7.
//  Copyright © 2018年 TQMAX-Lemon. All rights reserved.
//

import UIKit
import SnapKit


class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.shadowImage = UIImage()

        view.backgroundColor = UIColor.background
        if #available(iOS 11.0, *) {
            UIScrollView.appearance().contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        
        configUI()
        
    }

    func configUI() {}

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configNavigationBar()
    }

    func configNavigationBar() {
        guard let navi = navigationController else { return }
        if navi.visibleViewController == self {
            navi.disablePopGesture = false
            navi.setNavigationBarHidden(false, animated: true)
            if navi.viewControllers.count > 1 {
                let backImage = UIImage (named: "nav_back")
                // 返回按钮
                let backButton = UIButton(type: .custom)
                // 给按钮设置返回箭头图片
                backButton.setBackgroundImage(backImage, for: .normal)
                // 设置frame
                backButton.frame = CGRect(x: 200, y: 13, width: 13, height: 23)
                backButton.addTarget(self, action: #selector(pressBack), for: .touchUpInside)
                // 自定义导航栏的UIBarButtonItem类型的按钮
                let backView = UIBarButtonItem(customView: backButton)
                // 重要方法，用来调整自定义返回view距离左边的距离
                let barButtonItem = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
                barButtonItem.width = -10
                // 返回按钮设置成功
                navigationItem.leftBarButtonItems = [barButtonItem, backView]
//                navigationItem.leftBarButtonItem = UIBarButtonItem(image: backImage , style: UIBarButtonItemStyle.plain, target: self, action: #selector(pressBack))
            }
        }
    }
    
    @objc func pressBack() {
        navigationController?.popViewController(animated: true)
    }

}
