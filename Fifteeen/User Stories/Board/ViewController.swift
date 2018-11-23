//
//  ViewController.swift
//  Fifteeen
//
//  Created by Alexander Filimonov on 15/11/2018.
//  Copyright © 2018 Александр Филимонов. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // MARK: - Views

    @IBOutlet weak var boardView: BoardView!

    // MARK: - IBOutlets

    @IBOutlet private weak var newGameButton: UIButton!
    @IBOutlet private weak var shuffleButton: UIButton!

    // MARK: - IBActions

    @IBAction private func newGameClicked(_ sender: UIButton) {
        model?.begin()
    }

    @IBAction private func shuffleClicked(_ sender: Any) {
        model?.shuffle()
    }

    // MARK: - Properties

    private var model: Board?

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        let model = Board()
        self.model = model
        boardView.configure(with: model, parent: self)
    }

}

