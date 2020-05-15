//
//  DetectedResults2Pokers.swift
//  PokerDetection
//
//  Created by Jason Chow on 15/5/2020.
//  Copyright © 2020 Jason Chow. All rights reserved.
//

import Foundation
import CoreGraphics

struct reusltCombination {
    let i: Int
    let j: Int
    let distance: Double
}

func toPokers(_ detectedPokers: [detectedPoker]) {
    var resultCombinations: [reusltCombination] = []
    
    for i in 0...detectedPokers.count - 1 {
        for j in i...detectedPokers.count - 1 {
            
            let objA = detectedPokers[i].objectIdentifier
            let objB = detectedPokers[j].objectIdentifier
            
            if let _ = Poker.PokerSuit(rawValue: objA), let _: Poker.PokerSuit = Poker.PokerSuit(rawValue: objB) {
                continue
            } else if let _ = Poker.PokerNumber(rawValue: objB), let _ = Poker.PokerNumber(rawValue: objA) {
                continue
            }
            
            let coordinateI = CGPoint(x: detectedPokers[i].objectBoundingBox.minX, y: detectedPokers[i].objectBoundingBox.minY)
            let coordinateJ = CGPoint(x: detectedPokers[j].objectBoundingBox.minX, y: detectedPokers[j].objectBoundingBox.minY)
            let distance = coordinateI.distanceTo(coordinateJ)
            if distance > 0 {
                resultCombinations.append(reusltCombination(i: i, j: j, distance: distance))
                resultCombinations.sort { $0.distance < $1.distance }
            }
        }
    }
    
    guard resultCombinations.count > 0 else {
        return
    }
    
    var newDetectedPokers = detectedPokers
    
    if resultCombinations.count == 1, !addPoker(a: detectedPokers[resultCombinations[0].i].objectIdentifier, b: detectedPokers[resultCombinations[0].j].objectIdentifier) {
        return
    }
    
    for combin in resultCombinations {
        if addPoker(a: detectedPokers[combin.i].objectIdentifier, b: detectedPokers[combin.j].objectIdentifier) {
            newDetectedPokers.remove(at: combin.j)
            newDetectedPokers.remove(at: combin.i)
            break
        }
    }
    
    
    if newDetectedPokers.count > 1 { toPokers(newDetectedPokers) }
}

