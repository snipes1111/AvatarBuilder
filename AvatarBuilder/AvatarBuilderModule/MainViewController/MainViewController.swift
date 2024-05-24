//
//  ViewController.swift
//  AvatarBuilder
//
//  Created by user on 20/05/2024.
//

import UIKit

final class MainViewController: UIViewController {
    
    lazy var mainView: UIView = UIView(frame: view.frame)
    
    lazy var chooseAvatarLabel: UILabel = UILabel.createSectionLabel(with: "Step 1: Choose your avatar")
    lazy var setAttributesLabel: UILabel = UILabel.createSectionLabel(with: "Step 2: Set attributes")
    lazy var ageLabel: UILabel = UILabel.createAttributeLabel(with: "Age:")
    lazy var heightLabel: UILabel = UILabel.createAttributeLabel(with: "Height:")
    lazy var weightLabel: UILabel = UILabel.createAttributeLabel(with: "Weight:")
    lazy var ageTF: UITextField = UITextField.borderedTextField(with: "Desired age")
    lazy var heightTF: UITextField = UITextField.borderedTextField(with: "Desired height")
    lazy var weightTF: UITextField = UITextField.borderedTextField(with: "Desired weight")
    
    lazy var avatarButton: UIButton = UIButton.createButton(with: "Create my Avatar!")
    
    lazy var imageCollectionView: HorizontalCollectionView = {
        HorizontalCollectionView(view: mainView, numberOfItems: 2)
    }()
    
    var presenter: PresenterOutputProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        commonInit()
    }
    
    private func commonInit() {
        presenter = Presenter(viewController: self)
        setupCollectionView()
        setupSubviews()
        createTapGesture()
        avatarButton.addTarget(self, action: #selector(avatarButtonDidTapped), for: .touchUpInside)
    }
}

private extension MainViewController {
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






