//
//  VKLoginScene.swift
//  
//
//  Created by Ivan Konishchev on 14.12.2022.
//


import WebKit
import SwiftUI
import Combine


@available(iOS 13.0, *)
struct VKLoginScene: UIViewRepresentable {
    
    fileprivate let navigationDelegate = WebViewNavigationDelegate()
    
    func makeUIView(context: Context) -> WKWebView {
     
        let webView = WKWebView()
        webView.navigationDelegate = navigationDelegate
        
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        
        if let request = buildAuthRequest() {
            
            uiView.load(request)
                
        }
    }
    
    private func buildAuthRequest() -> URLRequest? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "oauth.vk.com"
        components.path = "/authorize"
        components.queryItems = [
            URLQueryItem(name: "client_id", value: "8146635"), // ID приложения 8140649, 8142951, 8134649, 8146635
            URLQueryItem(name: "redirect_uri", value: "https://oauth.vk.com/blank.html"),
            URLQueryItem(name: "display", value: "mobile"),
            URLQueryItem(name: "scope", value: "offline, friends, groups, photos, wall, status, video"),
            URLQueryItem(name: "response_type", value: "token"),
            URLQueryItem(name: "revoke", value: "0")
        ]
        
        return components.url.map { URLRequest(url: $0) }
    }
    
}

class WebViewNavigationDelegate: NSObject, WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        guard let url = navigationResponse.response.url,
              url.path == "/blank.html",
              let fragment = url.fragment else {
            decisionHandler(.allow)
            return
        }
        
        let params = fragment
            .components(separatedBy: "&")
            .map { $0.components(separatedBy: "=") }
            .reduce([String: String]()) { result, param in
                var dict = result
                let key = param[0]
                let value = param[1]
                dict[key] = value
                
                return dict
            }
        
        guard let token = params["access_token"],
              let userIdString = params["user_id"],
              let _ = Int(userIdString)
        else {
            decisionHandler(.allow)
            return
        }
        
        UserDefaults.standard.set(token, forKey: "token")
        UserDefaults.standard.set(userIdString, forKey: "userId")        
        decisionHandler(.cancel)
        
        
    }
}
