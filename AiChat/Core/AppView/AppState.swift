//
//  AppState.swift
//  AiChat
//
//  Created by Sathya Kumar on 15/06/26.
//

import Foundation

@Observable
class AppState {
    
    private(set) var showTabBar: Bool {
        didSet {
            UserDefaults.showTabBarView = showTabBar
        }
    }
    
    init(showTabBar: Bool = false) {
        self.showTabBar = showTabBar
    }
    
    func updateViewState(showTabBarView: Bool) {
        self.showTabBar = showTabBarView
    }
}

extension UserDefaults {
    private struct Keys {
        static let showTabBarView = "showTabBarView"
    }
    
    static var showTabBarView: Bool {
        get {
            standard.bool(forKey: "showTabBarView")
        }
        set {
            standard.set(newValue, forKey: "showTabBarView")
        }
    }
}
