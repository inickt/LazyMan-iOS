//
//  GameViewController.swift
//  LazyMan-iOS
//
//  Created by Nick Thompson on 2/23/18.
//  Copyright © 2018 Nick Thompson. All rights reserved.
//

import UIKit
import WebKit
import AVKit

protocol GameViewControllerType: class
{
    var gameTitle: String { get set }
    
    func playURL(url: URL)
    func showError(message: String)
}

class GameViewController: UIViewController, GameViewControllerType
{
    // MARK: - IBOutlets
    
    @IBOutlet private weak var navigation: UINavigationItem!
    @IBOutlet private weak var refreshButton: UIBarButtonItem!
    private var playerVC: AVPlayerViewController?
    
    // MARK: - Properties
    
    var presenter: GamePresenterType!
    var gameTitle: String = ""
    {
        didSet
        {
            self.navigation.title = gameTitle
        }
    }
    private var hidden = false
    
    // MARK: - IBActions
    
    @IBAction func refreshPressed(_ sender: Any)
    {
        self.presenter.reloadPressed()
    }
    
    // MARK: - Lifecycle
    
    override func loadView()
    {
        super.loadView()
        self.presenter.gameView = self
        NotificationCenter.default.addObserver(self, selector: #selector(pause), name: pauseNotification, object: nil)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.presenter.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        self.presenter.viewWillAppear()
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        self.hidden = false
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "gameOptions", let gameSettings = segue.destination as? GameSettingsViewController
        {
            gameSettings.presenter = self.presenter
            self.presenter.gameSettingsView = gameSettings
        }
        else if segue.identifier == "player", let playerVC = segue.destination as? AVPlayerViewController
        {
            self.playerVC = playerVC
        }
    }
    
    func playURL(url: URL)
    {
        let asset = AVURLAsset(url: url)
        asset.resourceLoader.setDelegate(self.presenter, queue: DispatchQueue(label: "Loader"))
        let playerItem = AVPlayerItem(asset: asset)
        let player = AVPlayer(playerItem: playerItem)
        self.playerVC?.player = player
        if !self.hidden
        {
            try? AVAudioSession.sharedInstance().setCategory(convertFromAVAudioSessionCategory(AVAudioSession.Category.playback))
            player.play()
        }
    }
    
    func showError(message: String)
    {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(okAction)
        
        let atrributedMessage = NSAttributedString(string: message, attributes: [.foregroundColor : UIColor.white])
        alert.setValue(atrributedMessage, forKey: "attributedMessage")
        
        self.present(alert, animated: true, completion: nil)
        
        alert.view.searchVisualEffectsSubview()?.effect = UIBlurEffect(style: .dark)
    }
    
    // MARK: - Private
    
    @objc private func pause()
    {
        self.playerVC?.player?.pause()
        self.hidden = true
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromAVAudioSessionCategory(_ input: AVAudioSession.Category) -> String {
	return input.rawValue
}
