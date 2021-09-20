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
        Analytics.logEvent("app_open", parameters: ["load_timer": endTimer()])
    }
    
    public func logDiveInPressed(activity: Activity) {
        Analytics.logEvent("dive_in_pressed", parameters: ["screen_view_time": endTimer(),
                                                           "activity": activity.name])
    }
    
    public func logViewedActivity(activity: Activity) {
        Analytics.logEvent("activity_viewed", parameters: ["load_time": endTimer(),
                                                           "activity": activity.name])
    }
    
    public func logViewedFinalStep(activity: Activity) {
        Analytics.logEvent("viewed_final_step", parameters: ["screen_view_time": endTimer(),
                                                           "activity": activity.name])
    }
    
    public func resetTimer() {
        startTimer = CFAbsoluteTimeGetCurrent()
    }
}
