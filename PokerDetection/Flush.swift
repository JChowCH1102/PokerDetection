//
//  Flush.swift
//  PokerDetection
//
//  Created by Jason Chow on 11/4/2020.
//  Copyright © 2020 Jason Chow. All rights reserved.
//

import Foundation

var pokers:[Poker] = []

func addPoker(pokerNumber: Poker.PokerNumber, pokerSuit: Poker.PokerSuit) {
    
    let newPoker = Poker(pokerNumber: pokerNumber, pokerSuit: pokerSuit)
    var didInsertPoker = true
    
    for p in pokers {
        if p.pokerNumber == newPoker.pokerNumber, p.pokerSuit == newPoker.pokerSuit {
            didInsertPoker = false
            break
        }
    }
    if didInsertPoker {
        pokers.append(newPoker)
        pokers.sort { $0.pokerNumber.rawValue < $1.pokerNumber.rawValue }
    }
}

func pokerFlush() -> String {
    guard pokers.count == 5 else {
        return "Not 5 cards in here"
    }
    
    if pokers[0].pokerSuit == pokers[1].pokerSuit, pokers[0].pokerSuit == pokers[2].pokerSuit, pokers[0].pokerSuit == pokers[3].pokerSuit, pokers[0].pokerSuit == pokers[4].pokerSuit {
        
        // all suit is same case
        if isInOrder() { return "Straight Flush" } else { return "Flush" }
        
    } else {
        if isInOrder() { return "Straight" }
        if !pokerRepeatCombinations(from: pokers, size: 4).isEmpty { return "Four of a kind" }
        let threeOfAKind = pokerRepeatCombinations(from: pokers, size: 3)
        if !threeOfAKind.isEmpty {
            var remainNumber: Poker.PokerNumber?
            for poker in pokers {
                if poker.pokerNumber != threeOfAKind[0].first?.pokerNumber {
                    if remainNumber == nil {
                        remainNumber = poker.pokerNumber
                    } else {
                        if remainNumber == poker.pokerNumber { return "Full house" } else { return "Three of a kind"}
                    }
                }
            }
        }
        let pairArray = pokerRepeatCombinations(from: pokers, size: 2)
        if !pairArray.isEmpty { return "\(pairArray.count) Pair"}
    }
    return "High card"
}

func pokerRepeatCombinations(with combinationThusFar: [Poker] = [], from array: [Poker], size: Int, startingAt: Int = 0) -> [[Poker]]{
    if size == 0 {
        var didRepeat = true
        for i in 1...combinationThusFar.count - 1 {
            if combinationThusFar[0].pokerNumber != combinationThusFar[i].pokerNumber { didRepeat = false }
        }
        if didRepeat {return [combinationThusFar]} else {return []}
    }
    
    var pokerCombins:[[Poker]] = []
    for i in startingAt ... array.count - size {
        var remaining = array
        remaining.remove(at: i)
        pokerCombins = pokerCombins + pokerRepeatCombinations(with: combinationThusFar + [array[i]], from: remaining, size: size - 1, startingAt: i)
    }
    return pokerCombins
}

func isInOrder()-> Bool {
    if pokers[0].pokerNumber.rawValue - pokers[1].pokerNumber.rawValue != -1, pokers[1].pokerNumber.rawValue - pokers[2].pokerNumber.rawValue != -1, pokers[2].pokerNumber.rawValue - pokers[3].pokerNumber.rawValue != -1, pokers[3].pokerNumber.rawValue - pokers[4].pokerNumber.rawValue != -1 {
        return true
    } else {
        return false
    }
}
