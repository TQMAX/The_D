//
//  ChaptersViewController.swift
//  The D
//
//  Created by FangRongJie on 2018/8/9.
//  Copyright © 2018年 TQMAX-Lemon. All rights reserved.
//

import UIKit
import Alamofire
import HandyJSON
import MJRefresh

class ChaptersViewController: BaseViewController {

    convenience init(bookID : Int ,model : listModel){
        self.init()
        self.bookId = bookID
        self.model = model
    }
    
    private var bookId : Int = 0
    private var page: Int = 0
    private var Parameters = [String:Int]()
    private var models = [listModel]()
    private var model = listModel()

    private let headerRefresh = MJRefreshNormalHeader()
    private let footerRefresh = MJRefreshAutoNormalFooter()
    
    private lazy var collectView:UICollectionView = {
        let customFlowLayout = ChaptersCollectionViewFlowLayout()
        customFlowLayout.headerReferenceSize = CGSize(width: screenWidth, height: 150)
        customFlowLayout.footerReferenceSize = CGSize(width: screenWidth, height: 28)
        customFlowLayout.minimumInteritemSpacing = 5
        customFlowLayout.minimumLineSpacing = 10
        customFlowLayout.itemSize = CGSize(width: floor((screenWidth - 30) / 2), height: 40)
        customFlowLayout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
        
        let homeCollectionView = UICollectionView(frame: .zero, collectionViewLayout: customFlowLayout)
        homeCollectionView.backgroundColor = UIColor.white
        homeCollectionView.alwaysBounceVertical = true
        homeCollectionView.delegate = self
        homeCollectionView.dataSource = self
        homeCollectionView.mj_header = headerRefresh
        homeCollectionView.mj_footer = footerRefresh
        homeCollectionView.register(ChaptersCollectionViewCell .classForCoder(), forCellWithReuseIdentifier: "ChaptersCollectionViewCell")
        homeCollectionView.register(ChaptersCollectionHead .classForCoder(), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "ChaptersCollectionHead")
        return homeCollectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = self.model.Title
        self.navigationController?.navigationBar.shadowImage = UIImage()

        loadData(more: false)
        self.headerRefresh.setRefreshingTarget(self, refreshingAction: #selector(loadData(more: ))) //刷新数据
        self.footerRefresh.setRefreshingTarget(self, refreshingAction: #selector(loadDataMore)) //刷新数据

    }

    override func configUI() {
        view.addSubview(collectView)
        collectView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 64, left: 0, bottom: 0, right: 0))
        }
    }
    
    @objc private func loadDataMore() {
        loadData(more: true)
    }
    
    @objc private func loadData(more: Bool) {
        page = (more ? ( page + 1) : 0)
        let parameters: Parameters = ["PageIndex":page,"id":bookId]
        Alamofire.request("http://www.ishuhui.net/ComicBooks/GetChapterList", method: .post, parameters: parameters ).responseJSON { (response) in
            
            let dic = (response.result.value as! NSDictionary)
            if let baseModel = JSONDeserializer<BasicTypes>.deserializeFrom(dict: dic){
                if !more{
                    self.models .removeAll()
                    self.models = (baseModel.Return?.List)!
                }else{
                    self.models = self.models + (baseModel.Return?.List)!
                }
                self.collectView .reloadData()
                self.headerRefresh .endRefreshing()
                self.footerRefresh .endRefreshing()

            }
            
        }
    }
}

extension ChaptersViewController : UICollectionViewDataSource,UICollectionViewDelegate{
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
//        delegate?.comicWillEndDragging(scrollView)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return models.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: screenWidth, height: 44)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let head = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "ChaptersCollectionHead", for: indexPath) as! ChaptersCollectionHead
        head.model = model
        return head
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChaptersCollectionViewCell", for: indexPath) as! ChaptersCollectionViewCell
        cell.model = models[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if model.Id == 65 {
            let vc = ReadByWebViewController()
            vc.title = models[indexPath.row].Title
            vc.urlStr = String (format: "http://www.ishuhui.net/ComicBooks/ReadComicBooksToIsoV1/%d.html", models[indexPath.row].Id)
            navigationController?.pushViewController(vc, animated: true)
        }else{
            let vc = ReadByImgViewController()
            vc.title = String( models[indexPath.row].Sort) + models[indexPath.row].Title!
            vc.urlStr = String (format: "http://www.ishuhui.net/ComicBooks/ReadComicBooksToIsoV1/%d.html", models[indexPath.row].Id)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
