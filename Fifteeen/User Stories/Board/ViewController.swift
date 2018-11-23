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

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        boardView.configure(with: Board(with: Constants.boardDefaultSize))
        boardView.backgroundColor = UIColor.orange

        view.backgroundColor = UIColor.gray
    }

}

