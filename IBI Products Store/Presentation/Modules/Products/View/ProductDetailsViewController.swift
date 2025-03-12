//
//  ProductDetailsViewController.swift
//  IBI Products Store
//
//  Created by Elisha Chirchir on 12/03/2025.
//

import UIKit
import SDWebImage

class ProductDetailsViewController: UIViewController {
    
    @IBOutlet weak var favoriteProductImage: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productDescription: UILabel!
    @IBOutlet weak var productBrand: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    
    var product: Product?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        productImage.sd_setImage(with: URL(string: product?.thumbnail ?? ""), placeholderImage: UIImage(named: "car.2"))
        productName.text = product?.title
        productDescription.text = product?.description
        productBrand.text = product?.brand
        productPrice.text = "₪\(product?.price ?? 0.0)"
        
    }
    
    @IBAction func onDeleteProductAction(_ sender: Any) {
        
    }
    
    @IBAction func onEditProductAction(_ sender: Any) {
        
    }
}
