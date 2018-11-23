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

    private(set) var state: [[Int]]
    private(set) var size: Int
    private(set) var steps = 0
    weak var delegate: BoardDelegate?

    // MARK: - Initialization and deinitialization

    convenience init() {
        self.init(with: Constants.boardDefaultSize)
    }

    init(with state: [[Int]]) {
        self.state = state
        size = state.count
    }

    init(with size: Int) {
        // create list of lists
        var counter = 1
        var cards: [[Int]] = []
        for _ in 0..<size {
            var cardRow: [Int] = []
            for _ in 0..<size {
                cardRow.append(counter)
                counter += 1
            }
            cards.append(cardRow)
        }

        // make last element as empty
        cards[size - 1][size - 1] = 0

        // initialize
        self.state = cards
        self.size = size
    }

    // MARK: - Public methods

    public func makeStep(at id: Int) {
        // check if step is aviable (game not finished)
        guard !isFinished() || steps == 0  else { return }

        // check is swap needed
        guard let swappedCardId = getSwappedId(with: id) else { return }

        // make swap and notify delegate
        swap(at: id, with: swappedCardId)
        delegate?.swap(at: id, with: swappedCardId)

        steps += 1

        // check is game finished
        if isFinished() {
            delegate?.gameFinished(with: steps)
        }

//        // check if state solvable
//        if !isSolvable() {
//            // TODO make solvable
//            delegate?.updateLayout()
//        }
    }

    public func isFinished() -> Bool {
        var counter = 1
        var copiedState = state
        copiedState[size - 1][size - 1] = size * size
        for i in 0..<size {
            for j in 0..<size {
                if (copiedState[i][j] != counter) {
                    return false
                }
                counter += 1
            }
        }
        return true
    }

    public func isSolvable() -> Bool {
        var array: [Int] = []
        for line in state {
            array.append(contentsOf: line)
        }
        guard let zeroIndex = array.firstIndex(of: 0) else { return false }
        array.remove(at: zeroIndex)

        var countPairs = 0
        for i in 0..<array.count {
            for j in (i+1)..<array.count {
                if (array[i] > array[j]) {
                    countPairs += 1
                }
            }
        }

        guard let zeroElementCoord = getCoordinate(by: 0) else { return false }
        let solvableCoef = countPairs + zeroElementCoord.y + 1

        return solvableCoef % 2 == 0
    }

    public func shuffle() {
        // shuffle lists
        repeat {
            for i in 0..<size {
                state[i].shuffle()
            }
            state.shuffle()
        } while (!isSolvable())

        // notify delegate
        delegate?.updateLayout()
    }

    public func begin() {
        steps = 0
        shuffle()
        delegate?.updateLayout()
    }

    public func getCoordinate(by id: Int) -> Coord? {
        for i in 0..<size {
            for j in 0..<size {
                if (state[i][j] == id) {
                    return Coord(x: j, y: i)
                }
            }
        }
        return nil
    }

    // MARK: - Private methods

    private func getZeroCoordinate() -> Coord {
        return Coord(x: 0, y: 0)
    }

    private func swap(at: Int, with: Int) {
        guard let atCoord = getCoordinate(by: at),
            let withCoord = getCoordinate(by: with) else { return }
        swap(at: atCoord, with: withCoord)
    }

    private func swap(at: Coord, with: Coord) {
        let temp = state[at.y][at.x]
        state[at.y][at.x] = state[with.y][with.x]
        state[with.y][with.x] = temp
    }

    /// if swap is needed return swapped id, else return nil
    private func getSwappedId(with id: Int) -> Int? {
        guard let coord = getCoordinate(by: id) else { return nil }

        // check top
        if (coord.y > 0 && state[coord.y - 1][coord.x] == 0) {
            return state[coord.y - 1][coord.x]
        }

        // check left
        if (coord.x > 0 && state[coord.y][coord.x - 1] == 0) {
            return state[coord.y][coord.x - 1]
        }

        // check bottom
        if (coord.y < (size - 1) && state[coord.y + 1][coord.x] == 0) {
            return state[coord.y + 1][coord.x]
        }

        // check right
        if (coord.x < (size - 1) && state[coord.y][coord.x + 1] == 0) {
            return state[coord.y][coord.x + 1]
        }

        return nil
    }

}
