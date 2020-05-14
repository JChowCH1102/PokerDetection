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
    
    enum PokerSuit: String{
        case diamonds, clubs, hearts, spades
    }
    
    enum PokerNumber: Int{
        case ace = 13
        case two = 1
        case three = 2
        case four = 3
        case five = 4
        case six = 5
        case seven = 6
        case eight = 7
        case nine = 8
        case ten = 9
        case jack = 10
        case queen = 11
        case king = 12
    }
}
