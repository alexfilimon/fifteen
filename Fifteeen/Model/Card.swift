//
//  Card.swift
//  Fifteeen
//
//  Created by Alexander Filimonov on 15/11/2018.
//  Copyright © 2018 Александр Филимонов. All rights reserved.
//

import Foundation

class Card {
    var id: Int
    var coordinate: Coordinate

    init(id: Int, coordinate: Coordinate) {
        self.id = id
        self.coordinate = coordinate
    }
}

extension Card: Equatable {

    static func == (lhs: Card, rhs: Card) -> Bool {
        return lhs.id == rhs.id
    }

}
