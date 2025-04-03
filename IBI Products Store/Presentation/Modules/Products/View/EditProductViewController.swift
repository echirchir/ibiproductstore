//
//  EditProductViewController.swift
//  IBI Products Store
//
//  Created by Elisha Chirchir on 02/04/2025.
//

import UIKit


class EditProductViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    
    private var viewModel: EditProductViewModel
    
    var onUpdateComplete: ((ProductEntity?) -> Void)?
    
    var product: LocalProduct?
    
    init() {
        self.viewModel = EditProductViewModel()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.viewModel = EditProductViewModel()
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nameTextField.text = product?.title
        priceTextField.text = product?.price.description
        
        priceTextField.keyboardType = .decimalPad
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        
        setupBindings()
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func onUpdateAction(_ sender: Any) {
        guard let name = nameTextField.text, !name.isEmpty,
              let priceText = priceTextField.text,
              let price = Double(priceText) else {
            showValidationError()
            return
        }
        
        viewModel.updateProduct(id: product?.id ?? 0, newName: name, newPrice: price)
    }
    
    private func showValidationError() {
        let alert = UIAlertController(title: "Validation Error", message: "Please enter valid name and price", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func setupBindings() {
        viewModel.onUpdateComplete = { [weak self] product in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                if let product = product {
                    debugPrint("✅ Update successful: \(product.title ?? "Untitled Product")")
                    self.onUpdateComplete?(product)
                    self.navigationController?.popViewController(animated: true)
                } else {
                    debugPrint("❌ Update failed: received nil product")
                    self.onUpdateComplete?(nil)
                }
            }
        }
    }
    
    private func showUpdateError() {
        let alert = UIAlertController(title: "Error", message: "Failed to update product", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
