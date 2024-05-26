//
//  ViewController.swift
//  AvatarBuilder
//
//  Created by user on 20/05/2024.
//

import UIKit

final class MainViewController: UIViewController {
    
    lazy var mainView: UIView = UIView(frame: view.frame)
    
    lazy var chooseAvatarLabel: UILabel = UILabel.createSectionLabel(with: Constants.stepOne)
    lazy var setAttributesLabel: UILabel = UILabel.createSectionLabel(with: Constants.stepTwo)
    lazy var ageLabel: UILabel = UILabel.createAttributeLabel(with: Constants.age)
    lazy var heightLabel: UILabel = UILabel.createAttributeLabel(with: Constants.height)
    lazy var weightLabel: UILabel = UILabel.createAttributeLabel(with: Constants.weight)
    lazy var ageTF: UITextField = UITextField.borderedTextField(with: Constants.desiredAge)
    lazy var heightTF: UITextField = UITextField.borderedTextField(with: Constants.desiredHeight)
    lazy var weightTF: UITextField = UITextField.borderedTextField(with: Constants.desiredWeight)
    
    lazy var avatarButton: UIButton = UIButton.createButton(with: Constants.createAvatar)
    
    lazy var imageCollectionView: HorizontalCollectionView = {
        HorizontalCollectionView(view: mainView, numberOfItems: 2)
    }()
    // Presenter is assigned inside commonInit(), it's safe to make it implicitly unwrapped optional.
    var presenter: PresenterOutputProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        commonInit()
    }
    
    private func commonInit() {
        // Dependecy injection
        presenter = Presenter(viewController: self)
        setupCollectionView()
        setupSubviews()
        createTapGesture()
        avatarButton.addTarget(self, action: #selector(avatarButtonDidTapped), for: .touchUpInside)
    }
}

private extension MainViewController {
    /// Hide the keyboard after the user tap on the screen
    func createTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        mainView.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func avatarButtonDidTapped() {
        let imageIdx = imageCollectionView.findCentralCellIndexPath()
        presenter.createAvatar(imageIdx: imageIdx?.item, age: ageTF.text,
                               height: heightTF.text, weight: weightTF.text)
        dismissKeyboard()
    }
}

//MARK: - ViewInputProtocol Extension
extension MainViewController: ViewInputProtocol {
    func updateUIWith(age: String, weight: String, height: String) {
        ageTF.text = age
        weightTF.text = weight
        heightTF.text = height
    }
    
    func showAlert(with title: String, and message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}






