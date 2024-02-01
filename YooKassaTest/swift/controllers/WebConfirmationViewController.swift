//
//  WebConfirmationViewController.swift
//  YooKassaTest
//
//  Created by GoodDamn on 31/01/2024.
//

import Foundation
import UIKit
import WebKit

class WebConfirmationViewController
    : UIViewController {
    
    var mWeb: WKWebView!
    
    override func loadView() {
        let config = WKWebViewConfiguration()
        mWeb = WKWebView(
            frame: .zero,
            configuration: config
        )
        
        mWeb.uiDelegate = self
        mWeb.navigationDelegate = self
        view = mWeb
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = URL(
            string: "http://192.168.31.98:8080"
        )
        
        let req = URLRequest(
            url: url!
        )
        
        mWeb.load(req)
        
    }
    
}


extension WebConfirmationViewController
    : WKNavigationDelegate {
    
    func webView(
        _ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
        if navigationAction.navigationType == .other {
            
            guard let redirUrl = navigationAction.request.url else {
                decisionHandler(.allow)
                return
            }
            
            let p = redirUrl.path
            
            print(
                "WebView: REDIR_URL:",
                p
            )
            
            if p.count < 4 {
                decisionHandler(
                    .allow
                )
                return
            }
            
            decisionHandler(
                .cancel
            )
            
            return
        }
        
        decisionHandler(.allow)
    }
    
}

extension WebConfirmationViewController
    : WKUIDelegate {
    
}
