//
//  MineTableViewCell.swift
//  The D
//
//  Created by TQ_Lemon on 2018/8/11.
//  Copyright © 2018年 TQMAX-Lemon. All rights reserved.
//

import UIKit

class MineTableViewCell: UITableViewCell {

    static let reuseIdentifier = "MineTableViewCell"
    
    lazy var titleLabel: UILabel = {
        let tl = UILabel()
        tl.textColor = UIColor.darkGray
        return tl
    }()
    
    lazy var switchMod : UISwitch = {
        let sw = UISwitch()
        sw .addTarget(self, action: #selector(switchDidChange(_:)), for: .valueChanged)
        //获取保存的状态值
        let state = UserDefaults.standard.bool(forKey: "browseMode")
        sw.setOn(state, animated: true)
        return sw
    }()
    
    static func cell(tableview:UITableView, indexPath:IndexPath) ->MineTableViewCell{
        var cell: MineTableViewCell?
        cell = (tableview.dequeueReusableCell(withIdentifier: MineTableViewCell.reuseIdentifier) as! MineTableViewCell)
        switch indexPath.row {
        case 0:
            cell?.titleLabel.text = "水平浏览模式"
            
        case 1:
            cell?.switchMod.isHidden = true;
            //获取保存的状态值
            let state = UserDefaults.standard.bool(forKey: "wantMore")
            if state {
                cell?.titleLabel.text = "我只想专注海贼"
            }else{
                cell?.titleLabel.text = "我想看更多"
            }
            
        case 2:
            cell?.titleLabel.text = "关于"
            cell?.switchMod.isHidden = true;

        default:
            print("666")
            break
        }
        return cell!
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupContentView()
    }
    
    func setupContentView() {
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(15)
            $0.height.equalTo(30)
            $0.centerY.equalToSuperview()
        }
        
        contentView.addSubview(switchMod)
        switchMod.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-15)
            $0.centerY.equalToSuperview()
        }


    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @objc func switchDidChange(_ sender: UISwitch){
        //把当前状态保存起来
        UserDefaults.standard.set(sender.isOn, forKey: "browseMode")
        //打印当前值
        print(sender.isOn)
    }
    
}
