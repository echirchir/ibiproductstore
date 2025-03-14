//
//  FavoritesViewController.swift
//  IBI Products Store
//
//  Created by Elisha Chirchir on 12/03/2025.
//

import UIKit

class FavoritesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private var viewModel: FavoritesViewModel
    
    @IBOutlet weak var favoritesTableView: UITableView!
    
    init() {
        self.viewModel = FavoritesViewModel()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.viewModel = FavoritesViewModel()
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        favoritesTableView.dataSource = self
        favoritesTableView.delegate = self
        viewModel.loadFavoritedProducts()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteCell", for: indexPath) as! ProductTableViewCell
        if(viewModel.products.count != 0){
            let product = viewModel.products[indexPath.row]
            
            cell.productImage.sd_setImage(with: URL(string: product.thumbnail), placeholderImage: UIImage(named: "car.2"))

            cell.productTitle.text = product.title
            cell.productDescription.text = product.description
            cell.productBrand.text = product.brand
            cell.productPrice.text = "₪\(product.price)"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedProduct = viewModel.products[indexPath.row]
        performSegue(withIdentifier: "favoriteDetails", sender: selectedProduct)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "favoriteDetails" {
            if let detailVC = segue.destination as? ProductDetailsViewController,
               let selectedProduct = sender as? LocalProduct {
                 detailVC.delegate = self
                 detailVC.product = selectedProduct
            }
        }
    }
}

extension FavoritesViewController: DetailsViewControllerDelegate {
    func didDeleteProduct(withId productId: Int) {
        viewModel.products.removeAll { $0.id == productId }
        favoritesTableView.reloadData()
    }
}
