//
//  ReadByWebViewController.swift
//  The D
//
//  Created by FangRongJie on 2018/8/9.
//  Copyright © 2018年 TQMAX-Lemon. All rights reserved.
//

import UIKit
import WebKit

class ReadByWebViewController: BaseViewController {

    var urlStr:String?
    
    private lazy var readingView : WKWebView = {
        let wkweb:WKWebView=WKWebView.init(frame: CGRect.init(x: 0, y: 0, width: screenWidth, height: screenHeight))
        view.addSubview(wkweb)
        wkweb.uiDelegate=self
        wkweb.navigationDelegate=self
        let url:NSURL=NSURL.init(string: urlStr!)!//"https://www.fangrongjie.com"
        let request:NSURLRequest=NSURLRequest.init(url: url as URL)
        wkweb.load(request as URLRequest)
        return wkweb
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func configUI() {
       view.addSubview(readingView)
    }
}

extension ReadByWebViewController : WKUIDelegate,WKNavigationDelegate{
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        
        
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        
        
        
    }
}
