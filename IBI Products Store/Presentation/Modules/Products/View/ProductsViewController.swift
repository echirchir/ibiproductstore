//
//  ProductsViewController.swift
//  IBI Products Store
//
//  Created by Elisha Chirchir on 12/03/2025.
//

import UIKit
import SDWebImage

class ProductsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var filterImageView: UIImageView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var productsUiTable: UITableView!
    private var viewModel: ProductsViewModel
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private var isFetching = false

    init() {
        self.viewModel = ProductsViewModel()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.viewModel = ProductsViewModel()
        super.init(coder: coder)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadProductsIfNeeded()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        productsUiTable.dataSource = self
        productsUiTable.delegate = self
        setupLoadingIndicator()
        fetchInitialProducts()
    }
    
    private func reloadProductsIfNeeded() {
        if viewModel.shouldRefresh {
            debugPrint("The favorited product is: refresh needed")
            viewModel.refreshProduct { complete in
                DispatchQueue.main.async {
                    self.productsUiTable?.reloadData()
                }
            }
            viewModel.shouldRefresh = false
        }
    }
    
    private func setupLoadingIndicator() {
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "productCell", for: indexPath) as! ProductTableViewCell
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
        performSegue(withIdentifier: "showProductDetails", sender: selectedProduct)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showProductDetails" {
            if let detailVC = segue.destination as? ProductDetailsViewController,
               let selectedProduct = sender as? LocalProduct {
                 detailVC.delegate = self
                 detailVC.product = selectedProduct
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        let insetBottom = scrollView.contentInset.bottom
        
        scrollView.layoutIfNeeded()
        
        if offsetY > contentHeight - (height + insetBottom) {
            if viewModel.products.count < viewModel.totalProducts && !isFetching {
                isFetching = true
                self.fetchMoreProducts()
            }
        }
    }
    
    private func fetchInitialProducts() {
        self.activityIndicator.startAnimating()
        viewModel.fetchProducts { [weak self] success in
            self?.activityIndicator.stopAnimating()
            if success {
                DispatchQueue.main.async {
                    self?.productsUiTable.reloadData()
                }
            }
        }
    }
    
    private func fetchMoreProducts() {
        self.activityIndicator.startAnimating()
        viewModel.fetchProducts { [weak self] success in
            guard let self = self else { return }
            self.isFetching = false
            self.activityIndicator.stopAnimating()
            if success {
                DispatchQueue.main.async {
                    self.productsUiTable.reloadData()
                }
            }
        }
    }
}

extension ProductsViewController: DetailsViewControllerDelegate {
    func productWasUpdated(withId productId: Int) {
        viewModel.shouldRefresh = true
        viewModel.productId = productId
    }

    func didDeleteProduct(withId productId: Int) {
        viewModel.products.removeAll { $0.id == productId }
        self.productsUiTable.reloadData()
    }
}
