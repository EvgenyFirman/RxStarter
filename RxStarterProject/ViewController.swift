//
//  ViewController.swift
//  RxStarterProject
//
//  Created by Евгений Фирман on 13.10.2022.
//
import UIKit
import RxCocoa
import RxSwift


struct Product {
    let imageName: String
    let title: String
}

struct ProductViewModel {
    var items = PublishSubject<[Product]>()
    
    func fetchItems(){
        let products = [Product(imageName: "house", title: "Home"),
                        Product(imageName: "gear", title: "Settings"),
                        Product(imageName: "person.circle", title: "Profile"),
                        Product(imageName: "airplane", title: "Flights"),
                        Product(imageName: "bell", title: "Activity")
        ]
        items.onNext(products)
        items.onCompleted()
    }
}

class ViewController: UIViewController {

    private let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    private var bag = DisposeBag()
    
    private var viewModel = ProductViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.frame = view.bounds
        bindTable()
        
    }

    func bindTable(){
        viewModel.items.bind(to: tableView.rx.items(cellIdentifier: "cell", cellType: UITableViewCell.self)) { row, model, cell in
            cell.textLabel?.text = model.title
            cell.imageView?.image = UIImage(systemName: model.imageName)
        }.disposed(by: bag)
        
        tableView.rx.modelSelected(Product.self).bind { product in
            print(product.title)
        }.disposed(by: bag)
        
        viewModel.fetchItems()
    }

}

