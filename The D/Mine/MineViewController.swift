//
//  MineViewController.swift
//  The D
//
//  Created by FangRongJie on 2018/8/7.
//  Copyright © 2018年 TQMAX-Lemon. All rights reserved.
//

import UIKit

class MineViewController: BaseViewController {

    private var theSureNumber = 0
    private var haveChange = false
    
    private lazy var bgImgVive : UIImageView = {
        let bgiv = UIImageView()
        bgiv.image = UIImage (named: "mainBg")
        bgiv.alpha = 0.5
        return bgiv
    }()
    
    private lazy var tableView: UITableView = {
        let tw = UITableView(frame: CGRect(x: 0, y: 64, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 64 - 40), style: .plain)
        tw.backgroundColor = UIColor.background
        tw.tableFooterView = UIView()
        tw.delegate = self
        tw.dataSource = self
        tw.register(MineTableViewCell.self, forCellReuseIdentifier: MineTableViewCell.reuseIdentifier)
        return tw
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func configUI() {
        view.addSubview(tableView)
//        tableView.snp.makeConstraints{ $0.edges.equalTo(self.view.usnp.edges) }
        view .addSubview(bgImgVive)
        bgImgVive .snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-50)
            make.size.equalTo(CGSize(width: 200, height: 200))
            make.centerX.equalToSuperview()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        if haveChange {
            return
        }
        theSureNumber = 0
        tableView .reloadData()
    }
}

extension MineViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = MineTableViewCell.cell(tableview: tableView, indexPath: indexPath)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 1:
            self.cellActionForUserSetting(sender: self);
        case 2:
            let vc = AboutViewController()
            navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    }
    
    func cellActionForUserSetting(sender:AnyObject){
        if haveChange {
            return
        }
        let indexPath = self.tableView .indexPathForSelectedRow;
        let cell = self.tableView .cellForRow(at: indexPath!) as! MineTableViewCell
        let state = UserDefaults.standard.bool(forKey: "wantMore")
        if state {
            theSureNumber = 4
        }
        switch theSureNumber {
        case 0:
            cell.titleLabel.text = "看更多漫画的话可能会有点问题喔~"
        case 1:
            cell.titleLabel.text = "即使这样也要看吗"
        case 2:
            cell.titleLabel.text = "确定吗"
        case 3:
            cell.titleLabel.text = "好的，明白了，再点一次？"

        default:
            cell.titleLabel.text = "切换好了，重启APP生效喔~"
            //把当前状态保存起来
            UserDefaults.standard.set(!state, forKey: "wantMore")
            haveChange = true
        }
        theSureNumber = theSureNumber + 1
    }
}
