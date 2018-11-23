//
//  BoardView.swift
//  Fifteeen
//
//  Created by Alexander Filimonov on 15/11/2018.
//  Copyright © 2018 Александр Филимонов. All rights reserved.
//

import UIKit

class BoardView: UIView {

    // MARK: - Constants

    private enum ViewConstants {
        static let boardMargin: CGFloat = 0
        static let animationDuration: Double = 0.1
    }

    // MARK: - Properties

    private var buttons: [UIButton] = []
    private var model: Board?
    private var rect: CGRect = .zero

    // MARK: - Life cycle

    override func layoutSubviews() {
        super.layoutSubviews()
        rect = getRect()

        layoutButtons()
    }

    // MARK: - Public methods

    public func configure(with model: Board) {
        self.model = model

        addButtons()
    }

    /// Getting rect for placing boardView
    public func getRect() -> CGRect {
        let W = self.bounds.size.width
        let H = self.bounds.size.height
        let margin = ViewConstants.boardMargin
        let size = min(W, H) - margin

        let horizontalMargin = (W - size) / 2
        let verticalMargin = (H - size) / 2

        return CGRect(
            x: horizontalMargin,
            y: verticalMargin,
            width: size,
            height: size
        )
    }

    // MARK: - Private methods

    @objc
    private func buttonClicked(_ sender: UIButton) {
        print("button with id: \(sender.tag) clicked")
        guard let model = model, let currentCard = model.getCard(by: sender.tag) else { return }

        if let swappedCard = model.shouldSwap(card: currentCard) {
            // надо менять
            model.swap(firstCardId: currentCard.id, secondCardId: swappedCard.id)
            swapButtons(firstButtonId: currentCard.id, secondButtonId: swappedCard.id)

//            if !model.isSolvable() {
//                // нет решения
//                guard let zeroCard = model.getCard(by: 0), let zeroButton = getButton(by: 0) else { return }
//                if zeroCard.coordinate.y > 0 {
//                    // сдвинуть вверх
//                    model.moveZeroTop()
//                    swapButtons(firstButtonId: currentCard.id, secondButtonId: model.getCardFromState(by: Coordinate(x: zeroCard.coordinate.x, y: zeroCard.coordinate.y - 1)).id)
//                } else {
//                    // сдвинуть вниз
//                    model.moveZeroBottom()
//                    swapButtons(firstButtonId: currentCard.id, secondButtonId: model.getCardFromState(by: Coordinate(x: zeroCard.coordinate.x, y: zeroCard.coordinate.y + 1)).id)
//                }
//                print("error no solution")
//            }
        }
    }

    private func addButtons() {
        guard let model = model else { return }
        for stateLine in model.state {
            for card in stateLine {
                let button = UIButton()
                button.tag = card.id

                if card.id == 0 {
                    button.backgroundColor = UIColor.clear
                } else {
                    button.layer.borderColor = UIColor.black.cgColor
                    button.layer.borderWidth = 1

                    button.backgroundColor = UIColor.white
                    button.setTitle(String(card.id), for: .normal)
                    button.setTitleColor(.black, for: .normal)
                    button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
                }


                addSubview(button)

                button.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)

                buttons.append(button)
            }
        }
    }

    private func layoutButtons() {
        guard let model = model else { return }
        let buttonSize = rect.width / CGFloat(Constants.boardDefaultSize)
        for button in buttons {
            guard let card = model.getCard(by: button.tag) else { continue }
            button.frame = CGRect(
                x: rect.origin.x + buttonSize * CGFloat(card.coordinate.x),
                y: rect.origin.y + buttonSize * CGFloat(card.coordinate.y),
                width: buttonSize,
                height: buttonSize
            )
        }
    }

    private func swapButtons(firstButtonId: Int, secondButtonId: Int) {
        guard let firstButton = getButton(by: firstButtonId),
            let secondButton = getButton(by: secondButtonId) else { return }
        swapButtons(firstButton: firstButton, secondButton: secondButton)
    }

    private func swapButtons(firstButton: UIButton, secondButton: UIButton) {
        let firstFrame = firstButton.frame
        let secondFrame = secondButton.frame
        UIView.animate(withDuration: ViewConstants.animationDuration) {
            firstButton.frame = secondFrame
            secondButton.frame = firstFrame
        }
    }

    private func getButton(by id: Int) -> UIButton? {
        for button in buttons {
            if button.tag == id {
                return button
            }
        }
        return nil
    }

}
