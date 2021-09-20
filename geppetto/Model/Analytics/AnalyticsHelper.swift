//
//  AnalyticsEvents.swift
//  geppetto
//
//  Created by Erick Manaroulas Felipe on 20/09/21.
//

import Foundation
import Firebase

public class AnalyticsHelper {
    var startTimer: Double
    init() {
        startTimer = CFAbsoluteTimeGetCurrent()
    }
    
    private func endTimer() -> Double {
        return CFAbsoluteTimeGetCurrent() - startTimer

    }
    
    public func logAppOpen() {
        let timeElapsed = endTimer()
        Analytics.logEvent("app_open", parameters: ["load_timer": timeElapsed])
    }
    
    public func resetTimer(){
        startTimer = CFAbsoluteTimeGetCurrent()
    }
}
