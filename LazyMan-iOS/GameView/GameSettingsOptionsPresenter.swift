//
//  GameSettingsOptionsPresenter.swift
//  LazyMan-iOS
//
//  Created by Nick Thompson on 10/31/18.
//  Copyright © 2018 Nick Thompson. All rights reserved.
//

import Foundation

protocol GameSettingsOptionsPresenterType {
    var count: Int { get }
    var selectedIndex: Int? { get }
    
    func title(for index: Int) -> String?
    func description(for index: Int) -> String?
    func isSelected(for index: Int) -> Bool
    func select(index: Int)
}

protocol GameSettingsOptionsDelegate: class {
    func didSelectCDN(option: CDN)
    func didSelectFeed(option: Feed)
    func didSelectPlaylist(option: FeedPlaylist)
}

class GameSettingsOptionsPresenter<T:GameSettingsCellType>: GameSettingsOptionsPresenterType where T: Equatable {
    
    enum OptionType {
        case cdn, feed, playlist
    }
    
    private let objects: [T]
    private var selected: T?
    private let type: OptionType
    private weak var delegate: GameSettingsOptionsDelegate?
    
    init(objects: [T], selected: T?, type: OptionType, delegate: GameSettingsOptionsDelegate) {
        self.objects = objects
        self.selected = selected
        self.type = type
        self.delegate = delegate
    }
    
    var count: Int {
        return self.objects.count
    }
    
    func title(for index: Int) -> String? {
        guard index < self.objects.count else { return nil }
        return self.objects[index].title
    }
    
    func description(for index: Int) -> String? {
        guard index < self.objects.count else { return nil }
        return self.objects[index].description
    }
    
    func isSelected(for index: Int) -> Bool {
        guard index < self.objects.count else { return false }
        return self.objects[index] == self.selected
    }
    
    var selectedIndex: Int? {
        guard let selected = self.selected else { return nil }
        return self.objects.index(of: selected)
    }
    
    func select(index: Int) {
        guard index < self.objects.count else { return }
        self.selected = self.objects[index]
        
        switch self.type {
        case .cdn:
            guard let option = self.objects[index] as? CDN else { return }
            self.delegate?.didSelectCDN(option: option)
        case .feed:
            guard let option = self.objects[index] as? Feed else { return }
            self.delegate?.didSelectFeed(option: option)
        case .playlist:
            guard let option = self.objects[index] as? FeedPlaylist else { return }
            self.delegate?.didSelectPlaylist(option: option)
        }
    }
}
