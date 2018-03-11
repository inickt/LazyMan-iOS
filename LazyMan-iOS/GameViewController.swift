//
//  GameViewController.swift
//  LazyMan-iOS
//
//  Created by Nick Thompson on 2/23/18.
//  Copyright © 2018 Nick Thompson. All rights reserved.
//

import UIKit
import WebKit

class GameViewController: UIViewController, WKNavigationDelegate {
    
    @IBOutlet weak var navigation: UINavigationItem!
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var webViewContainer: UIView!
    
    private var webView: WKWebView!
    
    var game: Game?
    
    override func loadView() {
        super.loadView()
        
        
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refreshButton.isEnabled = false
        
        if let awayShort = self.game?.awayTeam.shortName, let homeShort = self.game?.homeTeam.shortName {
            self.navigation.title = awayShort + " at " + homeShort
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func playPressed(_ sender: Any) {
        self.refreshButton.isEnabled = true
        self.playButton.isEnabled = false

        UIView.animate(withDuration: 0.2, animations: {
            self.playButton.alpha = 0.0
        }) { (true) in
            self.playButton.isHidden = true
        }
        
        
        if let validURL = self.game?.feeds[0].getURL(gameDate: (self.game?.startTime)!, cdn: CDN.Akamai)
        {
            self.webView.load(URLRequest(url: validURL))
        }
        
    }
    
    
    @IBAction func refreshPressed(_ sender: Any) {
        
    }
    
    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        let cred = URLCredential(trust: challenge.protectionSpace.serverTrust!)
        completionHandler(.useCredential, cred)
    }
}
