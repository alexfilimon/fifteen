//
//  CardTests.swift
//  FifteeenTests
//
//  Created by Alexander Filimonov on 15/11/2018.
//  Copyright © 2018 Александр Филимонов. All rights reserved.
//

import XCTest
@testable import Fifteeen

class BoardTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testThatBoardInitBySizeCorrectly() {
        // given
        let size = 3
        let k = Coordinate(x: 0, y: 0)
        let expectedBoardState = [
            [Card(id: 1, coordinate: k), Card(id: 2, coordinate: k), Card(id: 3, coordinate: k)],
            [Card(id: 4, coordinate: k), Card(id: 5, coordinate: k), Card(id: 6, coordinate: k)],
            [Card(id: 7, coordinate: k), Card(id: 8, coordinate: k), Card(id: 0, coordinate: k)]
        ]

        // when
        let board = Board(with: size)

        // then
        XCTAssert(board.state == expectedBoardState)
    }

    func testThatBoardSwapByIDCorrectly() {
        // given
        let size = 3
        let k = Coordinate(x: 0, y: 0)
        let expectedBoardState = [
            [Card(id: 1, coordinate: k), Card(id: 5, coordinate: k), Card(id: 3, coordinate: k)],
            [Card(id: 4, coordinate: k), Card(id: 2, coordinate: k), Card(id: 6, coordinate: k)],
            [Card(id: 7, coordinate: k), Card(id: 8, coordinate: k), Card(id: 0, coordinate: k)]
        ]

        // when
        let board = Board(with: size)
        board.swap(firstCardId: 2, secondCardId: 5)

        // then
        XCTAssert(board.state == expectedBoardState)
    }

    func testThatBoardSwapByCoordinatesCorrectly() {
        // given
        let size = 3
        let k = Coordinate(x: 0, y: 0)
        let expectedBoardState = [
            [Card(id: 1, coordinate: k), Card(id: 5, coordinate: k), Card(id: 3, coordinate: k)],
            [Card(id: 4, coordinate: k), Card(id: 2, coordinate: k), Card(id: 6, coordinate: k)],
            [Card(id: 7, coordinate: k), Card(id: 8, coordinate: k), Card(id: 0, coordinate: k)]
        ]

        // when
        let board = Board(with: size)
        board.swap(at: Coordinate(x: 1, y: 0), with: Coordinate(x: 1, y: 1))

        // then
        XCTAssert(board.state == expectedBoardState)
    }

}
