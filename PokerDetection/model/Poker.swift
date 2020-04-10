//
//  Poker.swift
//  PokerDetection
//
//  Created by Jason Chow on 11/4/2020.
//  Copyright © 2020 Jason Chow. All rights reserved.
//

import Foundation

struct Poker {
    
    var pokerNumber: PokerNumber
    var pokerSuit: PokerSuit
    
    enum PokerSuit{
        case diamond
        case club
        case heart
        case spade
    }
    
    enum PokerNumber: Int{
        case A = 13
        case Two = 1
        case Three = 2
        case Four = 3
        case Five = 4
        case Six = 5
        case Seven = 6
        case Eight = 7
        case Nine = 8
        case Ten = 9
        case J = 10
        case Q = 11
        case K = 12
    }
}
