//
//  GameViewController.swift
//  LazyMan-iOS
//
//  Created by Nick Thompson on 2/23/18.
//  Copyright © 2018 Nick Thompson. All rights reserved.
//

import UIKit
import WebKit

protocol GameViewControllerType: class
{
    func playURL(url: URL)
    func showError(message: String)
    func setTitle(title: String)
    
    
}




class GameViewController: UIViewController, WKNavigationDelegate, GameViewControllerType
{
    
    @IBOutlet weak var navigation: UINavigationItem!
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var webViewContainer: UIView!
    
    private var webView: WKWebView!
    
    var presenter: GameViewPresenterType!
    
    override func loadView()
    {
        super.loadView()
        self.presenter.setGameView(gameView: self)
        
        let config = WKWebViewConfiguration()
        config.allowsInlineMediaPlayback = true
        config.allowsAirPlayForMediaPlayback = true
        config.allowsPictureInPictureMediaPlayback = true
        
        self.webView = WKWebView(frame: self.webViewContainer.frame, configuration: config)
        self.webView.navigationDelegate = self
        self.webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.webView!.isOpaque = false
        self.webView!.backgroundColor = UIColor.clear
        self.webView!.scrollView.backgroundColor = UIColor.clear
        self.webView.scrollView.isScrollEnabled = false
        self.webView.allowsBackForwardNavigationGestures = false
        self.webView.allowsLinkPreview = false
        
        self.webViewContainer.addSubview(self.webView)
        
        self.presenter.loadView()
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.presenter.viewDidLoad()
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "gameOptions", let gameSettings = segue.destination as? GameSettingsViewController
        {
            gameSettings.presenter = self.presenter
            self.presenter.setGameSettingsView(gameSettingsView: gameSettings)
        }
    }
    
    func playURL(url: URL)
    {
        self.webView.load(URLRequest(url: url))
    }
    
    func showError(message: String)
    {
        
    }
    
    func setTitle(title: String)
    {
        self.navigation.title = title
    }

    @IBAction func playPressed(_ sender: Any) {
        self.refreshButton.isEnabled = true
        self.playButton.isEnabled = false

        UIView.animate(withDuration: 0.2, animations: {
            self.playButton.alpha = 0.0
        }) { (true) in
            self.playButton.isHidden = true
        }
        
        
        if let validURL = self.presenter.getGame().feeds[0].getMasterURL(cdn: CDN.Akamai)
        {
            self.webView.load(URLRequest(url: validURL))
        }
        
    }
    
    
    @IBAction func refreshPressed(_ sender: Any) {
        
    }
    
    // MARK: - WKNavigationDelegate
    
    /**
     Allows iOS to play the nonsecure stream from broken
     */
    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void)
    {
        let cred = URLCredential(trust: challenge.protectionSpace.serverTrust!)
        completionHandler(.useCredential, cred)
    }
    
}

