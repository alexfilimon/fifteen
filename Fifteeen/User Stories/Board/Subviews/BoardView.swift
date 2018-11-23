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
        static let buttonMargin: CGFloat = 5
        static let animationDuration: Double = 0.3
    }

    // MARK: - Properties

    private var buttons: [UIButton] = []
    private var model: Board?
    private weak var parent: UIViewController?
    private var rect: CGRect = .zero

    // MARK: - Life cycle

    override func layoutSubviews() {
        super.layoutSubviews()
        rect = getRect()

        setupLayout()
    }

    // MARK: - Public methods

    public func configure(with model: Board, parent: UIViewController) {
        self.model = model
        self.parent = parent

        model.delegate = self
        model.begin()

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
        model?.makeStep(at: sender.tag)
    }

    private func addButtons() {
        guard let model = model else { return }
        for stateLine in model.state {
            for card in stateLine {
                let button = UIButton()
                button.tag = card

                if card == 0 {
                    button.backgroundColor = UIColor.clear
                } else {
                    button.layer.cornerRadius = 5
                    button.clipsToBounds = true

                    button.backgroundColor = UIColor(red: 252, green: 189, blue: 156)
                    button.setTitle(String(card), for: .normal)
                    button.setTitleColor(UIColor(red: 231, green: 79, blue: 23), for: .normal)
                    button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
                }


                addSubview(button)

                button.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)

                buttons.append(button)
            }
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

    /// without animating
    private func setupButtonsLayout() {
        guard let model = model else { return }
        let buttonSize = rect.width / CGFloat(Constants.boardDefaultSize) - ViewConstants.buttonMargin * 2
        for button in buttons {
            guard let coord = model.getCoordinate(by: button.tag) else { continue }
            button.frame = CGRect(
                x: rect.origin.x + (buttonSize + ViewConstants.buttonMargin * 2) * CGFloat(coord.x) + ViewConstants.buttonMargin ,
                y: rect.origin.y + (buttonSize + ViewConstants.buttonMargin * 2) * CGFloat(coord.y) + ViewConstants.buttonMargin,
                width: buttonSize,
                height: buttonSize
            )
        }
    }

    private func updateButtonsLayout() {
        guard let model = model else { return }
        let buttonSize = rect.width / CGFloat(Constants.boardDefaultSize) - ViewConstants.buttonMargin * 2
        for button in buttons {
            guard let coord = model.getCoordinate(by: button.tag) else { continue }
            UIView.animate(withDuration: ViewConstants.animationDuration) { [weak self] in
                guard let `self` = self else { return }
                button.frame = CGRect(
                    x: self.rect.origin.x + (buttonSize + ViewConstants.buttonMargin * 2) * CGFloat(coord.x) + ViewConstants.buttonMargin,
                    y: self.rect.origin.y + (buttonSize + ViewConstants.buttonMargin * 2) * CGFloat(coord.y) + ViewConstants.buttonMargin,
                    width: buttonSize,
                    height: buttonSize
                )
            }
        }
    }

}

// MARK: - BoardDelegate

extension BoardView: BoardDelegate {

    func setupLayout() {
        setupButtonsLayout()
    }

    func updateLayout() {
        updateButtonsLayout()
    }

    func gameFinished(with steps: Int) {
        print("!!! game finished")
        let alertController = UIAlertController(title: "Game finished", message: "You made \(steps) steps", preferredStyle: .alert)
        alertController.addAction(
            UIAlertAction(
                title: "Start new",
                style: .default,
                handler: { [weak self] (_) in
                    self?.model?.begin()
                }
            )
        )
        alertController.addAction(
            UIAlertAction(
                title: "Cancel",
                style: .cancel,
                handler: nil
            )
        )
        parent?.present(alertController, animated: true, completion: nil)
    }

    func swap(at: Int, with: Int) {
        swapButtons(firstButtonId: at, secondButtonId: with)
    }

    func statisticsChanged() {
        
    }

}
