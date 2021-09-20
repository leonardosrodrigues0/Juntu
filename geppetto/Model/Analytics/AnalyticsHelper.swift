//
//  AnalyticsEvents.swift
//  geppetto
//
//  Created by Erick Manaroulas Felipe on 20/09/21.
//

import Foundation
import Firebase

public class AnalyticsHelper {
    var startTimer : Double
    init() {
        startTimer = CFAbsoluteTimeGetCurrent()
    }
    
    private func endTimer() -> Double{
        return CFAbsoluteTimeGetCurrent() - startTimer

    }
    
    public func logAppOpen(){
        let timeElapsed = endTimer()
        Analytics.logEvent("app_open", parameters: ["load_timer" : timeElapsed])
        startTimer = 0
    }
    
    private func printTimeElapsedWhenRunningCode(title:String, operation:()->()) {
        let startTime = CFAbsoluteTimeGetCurrent()
        operation()
        let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
        print("Time elapsed for \(title): \(timeElapsed) s.")
    }

    private func timeElapsedInSecondsWhenRunningCode(operation: ()->()) -> Double {
        let startTime = CFAbsoluteTimeGetCurrent()
        operation()
        let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
        return Double(timeElapsed)
    }
}
