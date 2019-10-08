//
//  Image.swift
//  LazyManCore
//
//  Created by Nick Thompson on 8/6/19.
//

#if os(macOS)
import AppKit

public typealias Image = NSImage

#else
import UIKit

public typealias Image = UIImage

#endif
