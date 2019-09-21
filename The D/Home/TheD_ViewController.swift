//
//  ViewController.swift
//  The D
//
//  Created by FangRongJie on 2018/8/7.
//  Copyright © 2018年 TQMAX-Lemon. All rights reserved.
//

import UIKit
import HandyJSON
import Alamofire

class TheD_ViewController: BaseViewController {

    private var page: Int = 1
    
    private var models = [NovelData]()

    private var Parameters = [String:String]()
    
    private lazy var tableView: UITableView = {
        let tw = UITableView(frame: CGRect(x: 0, y: 64, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 64 - 40), style: .plain)
        tw.backgroundColor = UIColor.background
        tw.tableFooterView = bgView
        tw.delegate = self
        tw.dataSource = self
        tw.register(TheD_TableViewCell.classForCoder(), forCellReuseIdentifier: "cell")
        return tw
    }()
    
    private lazy var bgImgVive : UIImageView = {
        let bgiv = UIImageView(frame: CGRect(x: (screenWidth - 200)/2, y: 90, width: 200, height: 200/1024*885))
        bgiv.image = UIImage (named: "TDbg")
        bgiv.alpha = 0.5
        return bgiv
    }()
    
    private lazy var bgView : UIView = {
        let bgiv = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 300))
        bgiv .addSubview(bgImgVive)
        return bgiv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData(more: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.fd_prefersNavigationBarHidden = false

        animateTable()
        
    }
    
    func animateTable() {
        
        self.tableView.reloadData()
        
        let cells = tableView.visibleCells
        let tableHeight: CGFloat = tableView.bounds.size.height
        
        for (index, cell) in cells.enumerated() {
            cell.transform = CGAffineTransform(translationX: 0, y: tableHeight)
            UIView.animate(withDuration: 1.0, delay: 0.05 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [], animations: {
                cell.transform = CGAffineTransform(translationX: 0, y: 0);
            }, completion: nil)
        }
    }
    
    @objc private func loadData(more: Bool) {
//        let wantMore = UserDefaults.standard.bool(forKey: "wantMore")
//        var title = ""
//        if !wantMore {
//            title = "海贼王"
//        }
//        page = (more ? ( page + 1) : 1)
//        let parameters: Parameters = ["Title":title]
        
        var model = NovelData()
        model.Img = "https://cdn2.jianshu.io/assets/default_avatar/8-a356878e44b45ab268a3b0bbaaadeeb7.jpg"
        model.Name = "titleLabel"
        model.Author = "subTitleLabel"
        model.Desc = "descLabel"
        model.LastTime = "lastTime"
        
        models .append(model)
        
        
        Alamofire.request("https://shuapi.jiaston.com/info/176504.html", method: .post, parameters: nil ).responseJSON { (response) in // http://www.ishuhui.net/ComicBooks/GetAllBook
            guard response.result.value != nil else {return}

            let dic = (response.result.value as! NSDictionary)
            if let baseModel = JSONDeserializer<BasicTypes>.deserializeFrom(dict: dic){
                let model = baseModel.data!
//                self.models = (baseModel.Return?.List)!
                self.models .append(model)
                
                self.tableView .reloadData()

            }
        }
//        self.searchTxt()
        
        self.tableView .reloadData()
        
    }

    override func configUI() {
        view.addSubview(tableView)
    }
    
}

extension TheD_ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:TheD_TableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TheD_TableViewCell
        cell.model = models[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = models[indexPath.row]
//        let vc = ChaptersViewController(bookID : model.Id , model:model)
//        navigationController?.pushViewController(vc, animated: true)
        if model.Img?.contains("http") ?? false {
            self .fastRead()
        }else{
            self.readNetwork(bookID: String( model.Id), firstChapterID: String(model.FirstChapterId),lastChapterID: String(model.LastChapterId))
        }

    }
    
    //扫描本地txt文件
    func searchTxt() -> [NovelData] {
        let fileManager = FileManager.default
        
        let documents = NSHomeDirectory() + "/Documents"
        let dirPath = documents + "/txt"
        print(dirPath)

        do {
              try  fileManager.createDirectory(atPath: dirPath, withIntermediateDirectories: true, attributes: nil)
            // 注：withIntermediateDirectories表示当创建的目录完整路径不满足时，是否递归创建完整路径文件
        } catch  {
        }

        let msg = "需要写入的信息"
        let fileName = "学习笔记.text"
        let path = dirPath + "/" + fileName
        //创建文件
        fileManager.createFile(atPath: path, contents:nil, attributes:nil)
        //写入信息
        let handle = FileHandle(forWritingAtPath:path)
        handle?.write(msg.data(using: String.Encoding.utf8)!)
        
        do {
            let recursivelyResult = try fileManager.subpathsOfDirectory(atPath: dirPath)
            print(recursivelyResult)
            let contentResult = try fileManager.contentsOfDirectory(atPath: dirPath)
            print(contentResult)

        } catch  {
        }
        
        //加载本地字txt资源
        let text = try! String(contentsOfFile:path, encoding: String.Encoding.utf8)
        print(text)
        
        return [NovelData]()
    }
    
    
    // 全本解析阅读
    @objc private func fullRead() {
        
        print("缓存文件地址:", DZM_READ_DOCUMENT_DIRECTORY_PATH)
        
//        MBProgressHUD.showLoading("全本解析(第一次进入)速度慢", to: view)
        
        let url = Bundle.main.url(forResource: "求魔", withExtension: "txt")
        
        print("全本解析开始时间:",TimerString("YYYY-MM-dd-HH-mm-ss"), Date().timeIntervalSince1970)
        
        DZMReadTextParser.parser(url: url) { [weak self] (readModel) in
            
            print("全本解析结束时间:",TimerString("YYYY-MM-dd-HH-mm-ss"), Date().timeIntervalSince1970)
            
//            MBProgressHUD.hide(self?.view)
            
            if readModel == nil {
                
//                MBProgressHUD.showMessage("全本解析失败")
                
                return
            }
            
            let vc  = DZMReadController()
            
            vc.readModel = readModel
            
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    // 快速解析阅读
    @objc private func fastRead() {
        
        print("缓存文件地址:", DZM_READ_DOCUMENT_DIRECTORY_PATH)
        
//        MBProgressHUD.showLoading("正在快速解析全文...", to: view)
        
        let url = Bundle.main.url(forResource: "求魔", withExtension: "txt")
        
        print("快速解析开始时间:",TimerString("YYYY-MM-dd-HH-mm-ss"), Date().timeIntervalSince1970)
        
        DZMReadTextFastParser.parser(url: url) { [weak self] (readModel) in
            
            print("快速解析结束时间:",TimerString("YYYY-MM-dd-HH-mm-ss"), Date().timeIntervalSince1970)
            
//            MBProgressHUD.hide(self?.view)
            
            if readModel == nil {
                
//                MBProgressHUD.showMessage("快速解析失败")
                
                return
            }
            
            let vc  = DZMReadController()
            
            vc.readModel = readModel
//            self?.navigationController?.pushViewController(vc, animated: true)
            self?.present(vc, animated: true, completion: nil)
        }
    }

    // 跳转网络小说初次进入使用例子(按照这样进入阅读页之后,只需要全局搜索 "搜索网络小说" 的地方加入请求章节就好了)
    @objc private func readNetwork(bookID:String,firstChapterID:String,lastChapterID:String) {
        
//        MBProgressHUD.showLoading(view)
        
        // 获得阅读模型
        // 网络小说的话, readModel 里面有个 chapterListModels 字段,这个是章节列表,我里面有数据是因为我是全本解析本地需要有个地方存储,网络小说可能一开始没有
        // 运行会在章节列表UI定位的地方崩溃,直接注释就可以了,网络小说的章节列表可以直接在章节列表UI里面单独请求在定位处理。
        let readModel = DZMReadModel.model(bookID: bookID)
        readModel.bookSourceType = .network
        let recordChapterID = readModel.recordModel.chapterModel?.id
        let recordNextChapterID = readModel.recordModel.chapterModel?.nextChapterID

        // 检查是否当前将要阅读的章节是否等于阅读记录
        if   (recordChapterID != nil) { // 如果不一致则需要检查本地是否有没有,没有则下载,并修改阅读记录为该章节。
            
            // 检查马上要阅读章节是否本地存在
            if DZMReadChapterModel.isExist(bookID: bookID, chapterID:  recordChapterID) { // 存在
                
//                MBProgressHUD.hide(view)
                
                // 如果存在则修改阅读记录
                readModel.recordModel.modify(chapterID:   recordChapterID, location: 0)
                                
                let vc  = DZMReadController()
                
                vc.readModel = readModel
                vc.readModel.lastChapterID = lastChapterID.integer as NSNumber
                
//                navigationController?.pushViewController(vc, animated: true)
                self.present(vc, animated: true, completion: nil)

            }else{ // 如果不存在则需要加载网络数据
                
                var chapterID = firstChapterID
                if recordNextChapterID == -1 {
                    chapterID = lastChapterID
                }
                
                // 获取当前需要阅读的章节
                let url = "https://shuapi.jiaston.com/book/" + bookID + "/" + chapterID + ".html"
                
                Alamofire.request(url, method: .post, parameters: nil ).responseJSON { (response) in
                    let dic = (response.result.value as! NSDictionary)
                    if let baseModel = JSONDeserializer<BasicTypes>.deserializeFrom(dict: dic){

                        // 获取章节数据
                        let data = baseModel.data?.content
                        
                        // 解析章节数据
                        let chapterModel = DZMReadChapterModel()
                        
                        chapterModel.bookID = baseModel.data?.id
                        
                        chapterModel.id =  baseModel.data?.cid
                        
                        chapterModel.previousChapterID =  baseModel.data?.pid
                        
                        chapterModel.nextChapterID = baseModel.data?.nid
                        
                        chapterModel.name = baseModel.data?.cname
                        
                        // 章节类容需要进行排版一篇
                        chapterModel.content = DZMReadParser.contentTypesetting(content: data ?? "")
                        
                        // 保存
                        chapterModel.save()
                        if readModel.recordModel != nil {
                            // 如果存在则修改阅读记录
                            readModel.recordModel.modify(chapterID: chapterModel.id, location: 0)
                        }
                        
                        let vc  = DZMReadController()
                        
                        readModel.bookName = baseModel.data?.name
                        vc.readModel = readModel
                        
//                        self?.navigationController?.pushViewController(vc, animated: true)
                        self.present(vc, animated: true, completion: nil)
                        
                    }
                }

            }
            
        }else{ // 如果是一致的就继续阅读。也可以在下面使用 readModel.recordModel.modify(xxx) 进行修改更新阅读页面或者位置
            
//            MBProgressHUD.hide(view)
            
            let vc  = DZMReadController()
            
            vc.readModel = readModel
            vc.readModel.lastChapterID = lastChapterID.integer as NSNumber

//            navigationController?.pushViewController(vc, animated: true)
            self.present(vc, animated: true, completion: nil)

        }
    }
}
