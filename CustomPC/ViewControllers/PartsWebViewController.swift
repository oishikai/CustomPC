//
//  PartsWebViewController.swift
//  CustomPC
//
//  Created by Kai on 2022/06/04.
//

import Foundation
import UIKit
import WebKit

class PartsWebViewController: UIViewController {
    var webView: WKWebView!

    var targetUrl = ""
    
        override func viewDidLoad() {
            super.viewDidLoad()
            // WKWebViewを生成
            webView = WKWebView(frame: view.frame)
            // WKWebViewをViewControllerのviewに追加する
            view.addSubview(webView)
            // リクエストを生成
            let request = URLRequest(url: URL(string: targetUrl)!)
            // リクエストをロードする
            webView.load(request)
        }
}
