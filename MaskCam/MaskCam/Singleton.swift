//
//  Singleton.swift
//  MaskCam
//
//  Created by Zifan  Yang on 2/12/18.
//  Copyright © 2018 Zifan  Yang. All rights reserved.
//

import Foundation
import UIKit
class Singleton {
    
    var photo: Data!
    var mask: Data!
    var text: String!
    
    private static let _singleton = Singleton()
    
    class func sharedInstance() ->Singleton {
        return _singleton
    }
    
    private init() {
    }
}

