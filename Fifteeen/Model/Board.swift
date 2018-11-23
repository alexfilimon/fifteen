//
//  Board.swift
//  Fifteeen
//
//  Created by Alexander Filimonov on 15/11/2018.
//  Copyright © 2018 Александр Филимонов. All rights reserved.
//

import Foundation

class Board {

    // MARK: - Properties

    var state: [[Card]]
    var size: Int

    // MARK: - Initialization and deinitialization

    init(with state: [[Card]]) {
        self.state = state
        size = state.count
    }

    init(with state: [[Int]]) {
        size = state.count

        self.state = []
        for line in state {
            var stateLine: [Card] = []
            for item in line {
                stateLine.append(Card(id: item, coordinate: Coordinate(x: -1, y: -1)))
            }
            self.state.append(stateLine)
        }
        updateCardCoordinates()
    }

    init(with size: Int) {
        // create list of lists
        var counter = 1
        var cards: [[Card]] = []
        for i in 0..<size {
            var cardRow: [Card] = []
            for j in 0..<size {
                cardRow.append(
                    Card(
                        id: counter,
                        coordinate: Coordinate(x: j, y: i)
                    )
                )
                counter += 1
            }
            cards.append(cardRow)
        }

        // make last element as empty
        cards[size - 1][size - 1].id = 0

        // initialize
        self.state = cards
        self.size = size
    }

    // MARK: - Public methods

    public func swap(firstCardId: Int, secondCardId: Int) {
        guard let firstCardCoord = getCardFromState(by: firstCardId),
            let secondCardCoord = getCardFromState(by: secondCardId)
            else { return }
        swap(at: firstCardCoord, with: secondCardCoord)
        updateCardCoordinates()
    }

    public func swap(at coordinate: Coordinate, with: Coordinate) {
        let temp = state[coordinate.y][coordinate.x]
        state[coordinate.y][coordinate.x] = state[with.y][with.x]
        state[with.y][with.x] = temp
        updateCardCoordinates()
    }

    public func getCard(by id: Int) -> Card? {
        for i in 0..<size {
            for j in 0..<size {
                if state[i][j].id == id {
                    return state[i][j]
                }
            }
        }
        return nil
    }

    // можно ли переместить карточку card, если надо - возвращается карточка с которой надо поменяться
    public func shouldSwap(card: Card) -> Card? {
        let coord = card.coordinate
        // check left
        if coord.x > 0 {
            if state[coord.y][coord.x - 1].id == 0 {
                return state[coord.y][coord.x - 1]
            }
        }

        // check right
        if coord.x + 1 < size {
            if state[coord.y][coord.x + 1].id == 0 {
                return state[coord.y][coord.x + 1]
            }
        }

        // check top
        if coord.y > 0 {
            if state[coord.y - 1][coord.x].id == 0 {
                return state[coord.y - 1][coord.x]
            }
        }

        // check bottom
        if coord.y + 1 < size {
            if state[coord.y + 1][coord.x].id == 0 {
                return state[coord.y + 1][coord.x]
            }
        }

        return nil
    }

    public func isSolvable() -> Bool {
        var puzzle: [Int] = []
        for stateLine in state {
            puzzle.append(contentsOf: stateLine.map { $0.id } )
        }

        var parity = 0
        var row = 0 // the current row we are on
        var blankRow = 0 // the row with the blank tile

        for i in 0..<puzzle.count {
            if i % size == 0 { // advance to next row
                row += 1
            }
            if puzzle[i] == 0 { // the blank tile
                blankRow = row // save the row on which encountered
                continue
            }
            for j in (i+1)..<puzzle.count {
                if puzzle[i] > puzzle[j] && puzzle[j] != 0 {
                    parity += 1
                }
            }
        }

        if (size % 2 == 0) { // even grid
            if (blankRow % 2 == 0) { // blank on odd row; counting from bottom
                return parity % 2 == 0
            } else { // blank on even row; counting from bottom
                return parity % 2 != 0
            }
        } else { // odd grid
            return parity % 2 == 0
        }
    }

    public func moveZeroTop() {
        guard let card = getCard(by: 0) else { return }
        swap(firstCardId: 0, secondCardId: state[card.coordinate.y - 1][card.coordinate.x].id)
    }

    public func moveZeroBottom() {
        guard let card = getCard(by: 0) else { return }
        swap(firstCardId: 0, secondCardId: state[card.coordinate.y + 1][card.coordinate.x].id)
    }

    public func getCardFromState(by coordinate: Coordinate) -> Card {
        return state[coordinate.y][coordinate.x]
    }

    // MARK: - Private methodsё

    private func getCardFromState(by id: Int) -> Coordinate? {
        for i in 0..<size {
            for j in 0..<size {
                if state[i][j].id == id {
                    return Coordinate(x: j, y: i)
                }
            }
        }
        return nil
    }

    private func updateCardCoordinates() {
        for i in 0..<size {
            for j in 0..<size {
                state[i][j].coordinate = Coordinate(x: j, y: i)
            }
        }
    }

}
