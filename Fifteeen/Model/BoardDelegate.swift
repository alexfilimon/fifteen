//
//  BoardDelegate.swift
//  Fifteeen
//
//  Created by Alexander Filimonov on 23/11/2018.
//  Copyright © 2018 Александр Филимонов. All rights reserved.
//

import Foundation

protocol BoardDelegate: class {
    /// Once in the begginnig of the game (without animating)
    func setupLayout()

    /// Every time, when changed position more than 2 cards (with animation)
    func updateLayout()

    /// In finish of the game
    func gameFinished(with steps: Int)

    /// When step made - need animate only 2 cards
    func swap(at: Int, with: Int)

    /// When statistics changed
    func statisticsChanged()
}
