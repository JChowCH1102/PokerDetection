//
//  Flush.swift
//  PokerDetection
//
//  Created by Jason Chow on 11/4/2020.
//  Copyright © 2020 Jason Chow. All rights reserved.
//

import Foundation

var pokers:[Poker] = []

func addPoker(pokerNumber: Poker.PokerNumber, pokerSuit: Poker.PokerSuit) -> Bool {
    
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
        pokers.sort { pokerNumber2LogicalNumber($0.pokerNumber) < pokerNumber2LogicalNumber($1.pokerNumber) }
        print("Added a poker \(newPoker.pokerNumber) \(newPoker.pokerSuit)")
    }
    return didInsertPoker
}

func addPoker(a: String, b:String) -> Bool {
    if let suit = Poker.PokerSuit(rawValue: a), let num = Poker.PokerNumber(rawValue: b) {
        return addPoker(pokerNumber: num, pokerSuit: suit)
    } else if let suit = Poker.PokerSuit(rawValue: b), let num = Poker.PokerNumber(rawValue: a) {
        return addPoker(pokerNumber: num, pokerSuit: suit)
    }
    return false
}

func pokerNumber2LogicalNumber(_ pokerNumber: Poker.PokerNumber) -> Int {
    switch pokerNumber {
    case .ace : return 13
    case .two : return 1
    case .three : return 2
    case .four : return 3
    case .five : return 4
    case .six : return 5
    case .seven : return 6
    case .eight : return 7
    case .nine : return 8
    case .ten : return 9
    case .jack : return 10
    case .queen : return 11
    case .king : return 12
    }
}

func pokerFlush() -> String {
    guard pokers.count == 5 else {
        return listPokers()
    }
    
    if pokers[0].pokerSuit == pokers[1].pokerSuit, pokers[0].pokerSuit == pokers[2].pokerSuit, pokers[0].pokerSuit == pokers[3].pokerSuit, pokers[0].pokerSuit == pokers[4].pokerSuit {
        
        // all suit is same case
        if isInOrder() { return "Straight Flush" } else { return "Flush" }
        
    } else {
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
        if isInOrder() { return "Straight" }
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
    if pokerNumber2LogicalNumber(pokers[0].pokerNumber) - pokerNumber2LogicalNumber(pokers[1].pokerNumber) != -1, pokerNumber2LogicalNumber(pokers[1].pokerNumber) - pokerNumber2LogicalNumber(pokers[2].pokerNumber) != -1, pokerNumber2LogicalNumber(pokers[2].pokerNumber) - pokerNumber2LogicalNumber(pokers[3].pokerNumber) != -1, pokerNumber2LogicalNumber(pokers[3].pokerNumber) - pokerNumber2LogicalNumber(pokers[4].pokerNumber) != -1 {
        return false
    } else {
        return true
    }
}

func listPokers()-> String {
    var pokerList: String = ""
    pokers.forEach { poker in
        pokerList += "\(poker.pokerNumber) \(poker.pokerSuit) \n"
    }
    print(pokerList)
    return pokerList
}
