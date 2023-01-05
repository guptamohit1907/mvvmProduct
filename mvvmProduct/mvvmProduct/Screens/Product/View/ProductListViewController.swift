//
//  ProductViewController.swift
//  mvvmProduct
//
//  Created by Mohit Gupta on 05/01/23.
//

import UIKit

class ProductListViewController: UIViewController {
    
    @IBOutlet weak var productTableView : UITableView!
    private var viewModel = ProductViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        configuration()
    }
}
extension ProductListViewController {
    func configuration(){
        productTableView.register(UINib(nibName: "ProductCell", bundle: nil), forCellReuseIdentifier: "ProductCell")
        initViewModel()
        observeEvent()
    }
    func initViewModel(){
        viewModel.fetchProducts()
    }
    // data binding event observe karega - commuication
    func observeEvent(){
        viewModel.eventHandler = { [weak self] event in
            guard let self else { return }
            switch event {
            case .loading :
                // Indicator Show
                print("Product Loading")
            case .stopLoading :
                // Indicator Hide
                print("Stop Loading")
            case .dataLoaded :
                print("Data Loaded")
                DispatchQueue.main.async {
                    self.productTableView.reloadData()
                }
                print(self.viewModel.products)
            case .error(let error) :
                print(error)
            }
        }
    }
}
extension ProductListViewController :UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell") as? ProductCell else { return UITableViewCell() }
        let product = viewModel.products[indexPath.row]
        cell.product = product
        return cell
    }
}
