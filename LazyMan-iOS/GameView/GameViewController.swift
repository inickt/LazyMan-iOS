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
    func updatePlay(enabled: Bool?)
}

class GameViewController: UIViewController, GameViewControllerType
{
    // MARK: - IBOutlets
    
    @IBOutlet weak var navigation: UINavigationItem!
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var webViewContainer: UIView!
    
    private var webView: WKWebView!
    
    var presenter: GamePresenterType!
    
    @IBAction func playPressed(_ sender: Any)
    {
        self.presenter.playPressed()
    }
    
    @IBAction func refreshPressed(_ sender: Any)
    {
        
    }
    
    override func loadView()
    {
        super.loadView()
        self.presenter.gameView = self
        
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
            self.presenter.gameSettingsView = gameSettings
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
    
    func updatePlay(enabled: Bool?)
    {
        guard let enabled = enabled else
        {
            UIView.animate(withDuration: 0.2, animations: {
                self.playButton.alpha = 0.0
            }) { (_) in
                self.playButton.isHidden = true
            }
            return
        }
        
        self.playButton.isHidden = false
        self.playButton.isEnabled = enabled
        UIView.animate(withDuration: 0.2, animations: {
            self.playButton.alpha = 1.0
        })
    }
}

extension GameViewController: WKNavigationDelegate
{
    // MARK: - WKNavigationDelegate
    
    /**
     * Allows iOS to play the nonsecure stream from broken https certificates
     */
    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void)
    {
        let cred = URLCredential(trust: challenge.protectionSpace.serverTrust!)
        completionHandler(.useCredential, cred)
    }
}
