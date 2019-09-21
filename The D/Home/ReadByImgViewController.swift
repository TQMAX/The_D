//
//  ReadByImgViewController.swift
//  The D
//
//  Created by FangRongJie on 2018/8/10.
//  Copyright © 2018年 TQMAX-Lemon. All rights reserved.
//

import UIKit
import Kingfisher

class ReadByImgViewController: BaseViewController {

    var urlStr:String?  // 供外部接入的url

    private var dataArray : NSMutableArray = []  //存储图片地址
    private var content : String?  //html内容
    private var selectIndex: Int = 0
    private var previousIndex: Int = 0
    private var nextIndex: Int = 0
    private let browseState = UserDefaults.standard.bool(forKey: "browseMode")

    var edgeInsets: UIEdgeInsets {
        if #available(iOS 11.0, *) {
            return view.safeAreaInsets
        } else {
            return .zero
        }
    }
    
    private var isLandscapeRight: Bool! {
        didSet {
            UIApplication.changeOrientationTo(landscapeRight: isLandscapeRight)
            collectionView.reloadData()
        }
    }
    
    private var isBarHidden: Bool = false {
        didSet {
            UIView.animate(withDuration: 0.5) {
                self.topBar.snp.updateConstraints {
                    $0.top.equalTo(self.backScrollView).offset(self.isBarHidden ? -(self.edgeInsets.top + 44) : 0)
                }
                self.bottomBar.snp.updateConstraints {
                    $0.bottom.equalTo(self.backScrollView).offset(self.isBarHidden ? (self.edgeInsets.bottom + 120) : 0)
                }
                self.view.layoutIfNeeded()
            }
        }
    }
    
    lazy var backScrollView: UIScrollView = {
        let sw = UIScrollView()
        sw.delegate = self
        sw.minimumZoomScale = 1.0
        sw.maximumZoomScale = 2.0
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        tap.numberOfTapsRequired = 1
        sw.addGestureRecognizer(tap)
        
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(doubleTapAction))
        doubleTap.numberOfTapsRequired = 2
        sw.addGestureRecognizer(doubleTap)
        tap.require(toFail: doubleTap)
        return sw
    }()
    
    private lazy var collectionView: UICollectionView = {
        let lt = UICollectionViewFlowLayout()
        lt.sectionInset = .zero
        lt.minimumLineSpacing = 10
        lt.minimumInteritemSpacing = 10
//        lt.estimatedItemSize = CGSize(width: screenWidth, height: screenHeight);

        if browseState{
            //设置滚动方向
            lt.scrollDirection = .horizontal
        }

        let cw = UICollectionView(frame: .zero, collectionViewLayout: lt)
        cw.backgroundColor = UIColor.background
        cw.delegate = self
        cw.dataSource = self
        cw.register(ReadingCollectionViewCell .classForCoder(), forCellWithReuseIdentifier: "ReadingCollectionViewCell")
//        cw.uHead = URefreshAutoHeader { [weak self] in
//            let previousIndex = self?.previousIndex ?? 0
//            self?.loadData(with: previousIndex, isPreious: true, needClear: false, finished: { [weak self]  (finish) in
//                self?.previousIndex = previousIndex - 1
//            })
//        }
//        cw.uFoot = URefreshAutoFooter { [weak self] in
//            let nextIndex = self?.nextIndex ?? 0
//            self?.loadData(with: nextIndex, isPreious: false, needClear: false, finished: { [weak self]  (finish) in
//                self?.nextIndex = nextIndex + 1
//            })
//        }
        return cw
    }()
    
    lazy var topBar: ReadingTopBar = {
        let tr = ReadingTopBar()
        tr.backgroundColor = UIColor.white
        tr.titleLabel.text = self.title
        tr.backButton.addTarget(self, action: #selector(pressBack), for: .touchUpInside)
        return tr
    }()
    
    lazy var bottomBar: ReadingBottomBar = {
        let br = ReadingBottomBar()
        br.backgroundColor = UIColor.white
        br.deviceDirectionButton.addTarget(self, action: #selector(changeDeviceDirection(_:)), for: .touchUpInside)
        br.chapterButton.addTarget(self, action: #selector(changeChapter(_:)), for: .touchUpInside)
        return br
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        getUrlContents()
    }
    
    /// 获取html内容
    func getUrlContents() {
        do {
            self.content = try String(contentsOf:URL(string: self.urlStr!)!)
            URLRegex(text: self.content!)
        }
        catch _ {
            // Error handling
        }
    }
    
    
    /// 筛选图片
    ///
    /// - Parameter text: htnml内容
    func URLRegex(text: String)
    {
        do{
//            let pattern = "\\bhttp?://.*?(jpg|png)"
            let pattern = "(http[^\\s]+(jpg|jpeg|png|tiff)\\b)"
            let dataDetector = try NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options.caseInsensitive)
            let res = dataDetector.matches(in: text, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, text.count))
            for checkingRes in res
            {
                let str = (text as NSString).substring(with: checkingRes.range)
                if !str .contains("sp.jpg"){
                    self.dataArray .add(str)
                }
            }
//            print(self.dataArray)
            let count = self.dataArray.count
            self.collectionView.reloadData()
            backScrollView.contentSize = CGSize(width: floor(screenWidth * CGFloat( count)) , height: screenHeight)
        }catch
        {
            print(error)
        }
    }
    
//    func loadData(with index: Int, isPreious: Bool, needClear: Bool, finished: ((_ finished: Bool) -> Void)? = nil) {
//        guard let detailStatic = detailStatic else { return }
//        topBar.titleLabel.text = detailStatic.comic?.name
//
//        if index <= -1 {
//            collectionView.uHead.endRefreshing()
//            UNoticeBar(config: UNoticeBarConfig(title: "亲,这已经是第一页了")).show(duration: 2)
//        } else if index >= detailStatic.chapter_list?.count ?? 0 {
//            collectionView.uFoot.endRefreshingWithNoMoreData()
//            UNoticeBar(config: UNoticeBarConfig(title: "亲,已经木有了")).show(duration: 2)
//        } else {
//            guard let chapterId = detailStatic.chapter_list?[index].chapter_id else { return }
//            ApiLoadingProvider.request(UApi.chapter(chapter_id: chapterId), model: ChapterModel.self) { (returnData) in
//
//                self.collectionView.uHead.endRefreshing()
//                self.collectionView.uFoot.endRefreshing()
//
//                guard let chapter = returnData else { return }
//                if needClear { self.chapterList.removeAll() }
//                if isPreious {
//                    self.chapterList.insert(chapter, at: 0)
//                } else {
//                    self.chapterList.append(chapter)
//                }
//                self.collectionView.reloadData()
//                guard let finished = finished else { return }
//                finished(true)
//            }
//        }
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isLandscapeRight = false
    }
    
    @objc func tapAction() {
        isBarHidden = !isBarHidden
    }
    
    @objc func doubleTapAction() {
        var zoomScale = backScrollView.zoomScale
        zoomScale = 2.5 - zoomScale
        let width = view.frame.width / zoomScale
        let height = view.frame.height / zoomScale
        let zoomRect = CGRect(x: backScrollView.center.x - width / 2 , y: backScrollView.center.y - height / 2, width: width, height: height)
        backScrollView.zoom(to: zoomRect, animated: true)
    }
    
    @objc func changeDeviceDirection(_ button: UIButton) {
        isLandscapeRight = !isLandscapeRight
        if isLandscapeRight {
            button.setImage(UIImage(named: "readerMenu_changeScreen_vertical")?.withRenderingMode(.alwaysOriginal), for: .normal)
        } else {
            button.setImage(UIImage(named: "readerMenu_changeScreen_horizontal")?.withRenderingMode(.alwaysOriginal), for: .normal)
        }
    }
    
    @objc func changeChapter(_ button: UIButton) {
    }
    
    override func configUI() {
        view.backgroundColor = UIColor.white
        view.addSubview(backScrollView)
        backScrollView.snp.makeConstraints {
            $0.edges.equalTo(self.view.snp.edges)
            $0.height.equalTo(screenHeight)
        }
        
        backScrollView.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.height.equalTo(backScrollView)
        }
        
        view.addSubview(topBar)
        topBar.snp.makeConstraints {
            $0.top.left.right.equalTo(backScrollView)
            $0.height.equalTo(44)
        }
        
        view.addSubview(bottomBar)
        bottomBar.snp.makeConstraints {
            $0.left.right.bottom.equalTo(backScrollView)
            $0.height.equalTo(0)
        }
    }
    
    override func configNavigationBar() {
        super.configNavigationBar()
//        navigationController?.barStyle(.white)
        navigationController?.setNavigationBarHidden(true, animated: true)
        let backImage = UIImage (named: "nav_back")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: backImage , style: UIBarButtonItem.Style.plain, target: self, action: #selector(pressBack))
        navigationController?.disablePopGesture = true
    }
    
    override var prefersStatusBarHidden: Bool {
        return UIScreen.main.bounds.height == 812 ? false : true
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
}

extension ReadByImgViewController:UICollectionViewDelegateFlowLayout, UICollectionViewDataSource ,UICollectionViewDelegate{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return chapterList[section].image_list?.count ?? 0
        return dataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        guard let image = chapterList[indexPath.section].image_list?[indexPath.row] else { return CGSize.zero }
//        let imageStr = dataArray[indexPath.row]
//        let lhhImageView = UIImageView()
//        let width = backScrollView.frame.width
        let width = screenWidth - 10
        let height = screenHeight - 64

//        lhhImageView.kf.setImage(with:  URL (string: dataArray[indexPath.row] as! String), placeholder: nil, options: nil, progressBlock: nil) { (image, error, type, url)  in
//            print("width:" + "\(String(describing: image?.size.width))" + "height:" + "\(String(describing: image?.size.height))")
////            let height = floor(width / (image?.size.width)! * (image?.size.height)!)
////            return  CGSize(width: width, height: height)
//        }
        return  CGSize(width: width, height: height)

    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ReadingCollectionViewCell", for: indexPath) as! ReadingCollectionViewCell
        cell.image = dataArray[indexPath.row] as? String
        print([indexPath.row])
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if isBarHidden == false { isBarHidden = true }
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        if scrollView == backScrollView {
            return collectionView
        } else {
            return nil
        }
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        if scrollView == backScrollView {
            scrollView.contentSize = CGSize(width: scrollView.frame.width  * scrollView.zoomScale , height: scrollView.frame.height * scrollView.zoomScale)
        }
    }
    
//    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        let page:Int = Int(roundf(Float(scrollView.contentOffset.x) / Float(screenWidth)))
//        let targetX:CGFloat = CGFloat(screenWidth) * CGFloat(page)
//        scrollView.contentOffset = CGPoint (x: targetX, y: scrollView.contentOffset.y)
//    }
    
    func nearestTargetOffsetForOffset(offset:CGPoint)->CGPoint{
        let pageSize:CGFloat = screenWidth
        let page:Int = Int(roundf(Float(offset.x) / Float(pageSize)))
        let targetX:CGFloat = CGFloat(pageSize) * CGFloat(page)
        return CGPoint(x:targetX, y:offset.y)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if backScrollView.zoomScale != 1 {return}
        let targetOffset:CGPoint = self.nearestTargetOffsetForOffset(offset: targetContentOffset.pointee)
        targetContentOffset.pointee.x = targetOffset.x
        targetContentOffset.pointee.y = targetOffset.y
    }
    

    

}

