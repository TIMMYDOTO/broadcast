//
//  CSDetailsHeaderTranslationView.swift
//  BetBoom
//
//  Created by Alexander Khvan on 15.04.2022.
//

import UIKit
import WebKit
import YouTubePlayer
import SwiftVideoBackground

class CSDetailsHeaderTranslationView: UIView {
    
    private weak var youtubePlayer: YouTubePlayerView!
     weak var webView: WKWebView!
    
    private weak var muteButton: UIButton!
    private weak var fullScreenButton: UIButton!
    private weak var pictureInPictureButton: UIButton!
    
    private var streamType: CSStreamType?
    private var isLoaded: Bool = false
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        youtubePlayer?.layoutIfNeeded()
        webView?.layoutIfNeeded()
    }
    
    func configure(_ model: CSStream?) {
        guard let stream = model else { return }
        

        
        if !isLoaded {
            streamType = stream.name

            setupPlayer()
            configurePlayer(stream.streamURL)
        }
        isLoaded = true
    }
    
    func removePlayerView() {
        youtubePlayer?.removeFromSuperview()
        youtubePlayer = nil
        webView?.stopLoading()
        webView?.loadHTMLString("", baseURL: nil);
        webView?.removeFromSuperview()
        webView = nil
        isLoaded = false
    }
}

extension CSDetailsHeaderTranslationView: YouTubePlayerDelegate {
    func playerReady(_ videoPlayer: YouTubePlayerView) {
        youtubePlayer.play()
    }
}

extension CSDetailsHeaderTranslationView: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        let javascriptStyle = "var css = '*{-webkit-touch-callout:none;-webkit-user-select:none}'; var head = document.head || document.getElementsByTagName('head')[0]; var style = document.createElement('style'); style.type = 'text/css'; style.appendChild(document.createTextNode(css)); head.appendChild(style);"
        webView.evaluateJavaScript(javascriptStyle, completionHandler: nil)
    }
}

private extension CSDetailsHeaderTranslationView {
  
    func setup() {
//        setupAuthView()
    }
    
    func setupAuthView() {
//        let view = CSDetailsHeaderTranslationAuthView()
//        view.isHidden = true
//        
//        authView = view
//        addSubview(authView)
//        authView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    func setupWebView() {
        let configuration = WKWebViewConfiguration()
        configuration.allowsInlineMediaPlayback = true
        configuration.preferences.javaScriptEnabled = true
        configuration.allowsPictureInPictureMediaPlayback = false
        
        let view = WKWebView(frame: .zero, configuration: configuration)
        view.scrollView.isScrollEnabled = false
        view.navigationDelegate = self
       
        webView = view
//        webView.isOpaque = false
        
       
        addSubview(webView)
        webView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalToSuperview()
//            $0.width.equalTo(UIScreen.main.bounds.width)
            $0.width.equalToSuperview()
        }
        
        
    }
    
    func setupYoutubePlayer() {
        let player = YouTubePlayerView(frame: .zero)
        player.isUserInteractionEnabled = false
        player.delegate = self
        
        let playerVars: [String: AnyObject] = [
            "showinfo": 0 as AnyObject,
            "autoplay": 1 as AnyObject,
            "controls": 0 as AnyObject,
            "rel": 0 as AnyObject
        ]
        player.playerVars = playerVars
        
        youtubePlayer = player
        addSubview(youtubePlayer)
        youtubePlayer.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.bottom.equalToSuperview()
//            $0.width.equalTo(UIScreen.main.bounds.width)
            $0.width.equalToSuperview()
        }
        
    }
    
    func setupPlayer() {
        switch streamType {
        case .twitch:
            
            setupWebView()
        case .youtube:
            setupYoutubePlayer()
        default:
            break
        }
    }
    
    func configurePlayer(_ path: String) {
        switch streamType {
        case .twitch:
            let result = "\(path)&controls=false&allowfullscreen=false"
                .replacingOccurrences(of: "?muted=true&", with: "?")
            
            guard let url = URL(string: result) else { return }
            let request = URLRequest(url: url)
            webView.load(request)
        case .youtube:
            guard let url = URL(string: path) else { return }
            youtubePlayer.loadVideoURL(url)
        default:
            break
        }
    }
    
    
}
