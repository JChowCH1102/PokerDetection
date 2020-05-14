//
//  CGPoint_Extension.swift
//  PokerDetection
//
//  Created by Jason Chow on 15/5/2020.
//  Copyright © 2020 Jason Chow. All rights reserved.
//

import Foundation
import CoreGraphics

extension CGPoint {

    func distanceTo(_ point : CGPoint) -> Double {

        return Double(sqrt(pow((self.x - point.x), 2) + pow((self.y - point.y), 2)))

    }

}
