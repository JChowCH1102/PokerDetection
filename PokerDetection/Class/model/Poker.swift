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
    
    enum PokerNumber: String{
        case ace
        case two
        case three
        case four
        case five
        case six
        case seven
        case eight
        case nine
        case ten
        case jack
        case queen
        case king
    }
}
