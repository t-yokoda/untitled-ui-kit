//
//  APUntitledManager.swift
//  Untitled
//
//  Created by t-yokoda@protosolution.co.jp on 16/02/2017, using AnimaApp.com, under MIT license.
//  Copyright © 2017 Company Name. All rights reserved.
//

import UIKit


/** APUntitledManager gives an easy access to Anima code */
public class APUntitledManager : NSObject {

    public static let sharedInstance = APUntitledManager();

    public static func shared() -> APUntitledManager {
        return self.sharedInstance
    }

    /**
    Holds the theme as configured in Anima.
    On runtime, you may change its values and call APUntitledManager.sharedInstance().theme.apply()
    **/
    public var theme: ANTheme?

    override init() {
        super.init()
        self.setupTheme()
    }

    public func animaStoryboad() -> UIStoryboard {
        return UIStoryboard(name: "UntitledUIKit", bundle:Bundle(for: type(of: self).self));
    }

    public func initialVC() -> UIViewController {
        return self.animaStoryboad().instantiateInitialViewController()!;
    }

    internal func setupTheme() -> Void {
        self.theme = ANTheme()
        self.theme!.navBarColor          = UIColor(red: 0.98, green:0.98, blue:0.98, alpha:1.0);
        self.theme!.navBarButtonsColor   = UIColor(red: 0.0, green:0.42, blue:1.0, alpha:1.0);
        self.theme!.navBarTitleColor     = UIColor(red: 0.0, green:0.0, blue:0.0, alpha:1.0);
        self.theme!.navBarTitleFontSize  = 16;
        self.theme!.navBarIsTranslucent  = false;
    }

}