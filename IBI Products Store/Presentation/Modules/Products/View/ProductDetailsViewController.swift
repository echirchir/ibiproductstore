//
//  ProductDetailsViewController.swift
//  IBI Products Store
//
//  Created by Elisha Chirchir on 12/03/2025.
//

import UIKit
import SDWebImage
import LocalAuthentication

class ProductDetailsViewController: UIViewController {
    
    @IBOutlet weak var favoriteProductImage: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productDescription: UILabel!
    @IBOutlet weak var productBrand: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    
    @IBOutlet weak var editProductButton: UIButton!
    @IBOutlet weak var deleteProductButton: UIButton!
    weak var delegate: DetailsViewControllerDelegate?
    
    var product: LocalProduct?
    
    let isBiometricsAvailable: Bool = {
        let context = LAContext()
        var error: NSError?
        
        let isAvailable = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
        
        if let error = error {
            print("Biometrics check error: \(error.localizedDescription)")
        }
        
        return isAvailable
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        productImage.sd_setImage(with: URL(string: product?.thumbnail ?? ""), placeholderImage: UIImage(named: "car.2"))
        productName.text = product?.title
        productDescription.text = product?.description
        productBrand.text = product?.brand
        productPrice.text = "₪\(product?.price ?? 0.0)"
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleFavoriteOfProduct))
        favoriteProductImage.addGestureRecognizer(tapGesture)
        
        updateFavoriteButton(isFavorited: product?.isFavorited ?? false)
        
        editProductButton.isEnabled = isBiometricsAvailable
        deleteProductButton.isEnabled = isBiometricsAvailable
    }
    
    @objc func handleFavoriteOfProduct() {
        toggleFavorite()
    }
    
    @IBAction func onDeleteProductAction(_ sender: Any) {
        authenticateWithBio { [weak self] (success: Bool) in
            guard let self = self, let productId = self.product?.id else { return }
            
            if success {
                do {
                    try CoreDataManager.shared.deleteProductFromCoreData(withId: productId)
                    self.delegate?.didDeleteProduct(withId: productId)
                    self.navigationController?.popViewController(animated: true)
                } catch {
                    self.showAlert(title: "Error", message: "Authentication failed")
                }
            } else {
                self.showAlert(title: "Error", message: "Something bad happened!")
            }
        }
    }
    
    @IBAction func onEditProductAction(_ sender: Any) {
        authenticateWithBio { [weak self] (success: Bool) in
            guard let self = self, let productId = self.product?.id else { return }
            
            if success {
                performSegue(withIdentifier: "showEditProduct", sender: product)
            } else {
                self.showAlert(title: "Error", message: "Authentication failed or something!!")
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showEditProduct" {
            if let editProductViewController = segue.destination as? EditProductViewController,
               let selectedProduct = sender as? LocalProduct {
                editProductViewController.product = selectedProduct
                editProductViewController.onUpdateComplete = { result in
                    if let updatedProduct = result {
                        self.product?.title = updatedProduct.title ?? ""
                        self.product?.price = updatedProduct.price
                        self.productName.text = self.product?.title
                        self.productPrice.text = "₪\(self.product?.price ?? 0.0)"
                        self.delegate?.productWasUpdated?(withId: Int(updatedProduct.id))
                    }
                }
            }
        }
    }
    
    func toggleFavorite() {
        guard let product = product else { return }
        do {
            let newFavoriteState = try CoreDataManager.shared.toggleFavorite(for: product.id)
            self.product?.isFavorited = newFavoriteState
            updateFavoriteButton(isFavorited: newFavoriteState)
            self.delegate?.productWasUpdated?(withId: Int(product.id))
        } catch {
            debugPrint("Toggling failed")
        }
    }
    
    private func updateFavoriteButton(isFavorited: Bool) {
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 24, weight: .bold, scale: .default)
        let starImage = isFavorited ? UIImage(systemName: "star.fill", withConfiguration: symbolConfig) : UIImage(systemName: "star", withConfiguration: symbolConfig)
        
        favoriteProductImage.image = starImage
        favoriteProductImage.tintColor = isFavorited ? .systemYellow : .systemGray
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true)
    }
}

extension ProductDetailsViewController {
    func authenticateWithBio(completion: @escaping (Bool) -> Void) {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "auth_to_proceed".localized
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        completion(true)
                    } else {
                        self.showAlert(title: "Error", message: authenticationError?.localizedDescription ?? "Failed to authenticate")
                    }
                }
            }
        } else {
            showAlert(title: "Unavailable", message: "Biometric authentication is not available on this device.")
        }
    }
}
