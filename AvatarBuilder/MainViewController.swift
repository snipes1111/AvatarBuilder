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
    
    lazy var imageCollectionView: UICollectionView = {
        HorizontalCollectionView(view: mainView, numberOfItems: 2)
    }()
    
    var viewModel: ViewModelProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        commonInit()
    }
    
    private func commonInit() {
        viewModel = ViewModel()
        setupCollectionView()
        setupSubviews()
        createTapGesture()
        avatarButton.addTarget(self, action: #selector(createAvatar), for: .touchUpInside)
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
    
    @objc private func createAvatar() {
        guard let age = ageTF.text, let height = heightTF.text, let weight = weightTF.text
        else { return }
        guard [age, height, weight].filter({ $0.isEmpty }).isEmpty
        else {
            showTextInvalidAlert()
            return
        }
        print("Age: \(age), Height: \(height), Weight: \(weight)")
        return
    }
    
    private func showTextInvalidAlert() {
        let alert = UIAlertController(title: "Empty fields", message: "Hey! You should fill all fields out before sending your data.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}






