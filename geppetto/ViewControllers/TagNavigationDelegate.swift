//
//  TagNavigationDelegate.swift
//  geppetto
//
//  Created by Renato Noronha Máximo on 09/11/21.
//

import Foundation

protocol TagNavigationDelegate: AnyObject {
    func navigate(to tag: Tag)
}
