//
//  UIView+searcVisualEffectsSubview.swift
//  LazyMan-iOS
//
//  Created by Nick Thompson on 4/20/18.
//  Copyright © 2018 Nick Thompson. All rights reserved.
//

import UIKit

extension UIView {
    func searchVisualEffectsSubview() -> UIVisualEffectView? {
        if let visualEffectView = self as? UIVisualEffectView {
            return visualEffectView
        }
        else {
            for subview in subviews {
                if let found = subview.searchVisualEffectsSubview() {
                    return found
                }
            }
        }
        
        return nil
    }
}
