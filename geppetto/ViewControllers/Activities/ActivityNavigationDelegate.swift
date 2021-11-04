//
//  ActivityNavigationDelegate.swift
//  geppetto
//
//  Created by Renato Noronha Máximo on 26/10/21.
//

import Foundation

protocol ActivityNavigationDelegate: AnyObject {
    func navigate(to activity: Activity)
}
