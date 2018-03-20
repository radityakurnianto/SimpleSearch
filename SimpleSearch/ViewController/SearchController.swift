//
//  SearchController.swift
//  SimpleSearch
//
//  Created by Raditya Kurnianto on 3/15/18.
//  Copyright © 2018 Raditya. All rights reserved.
//

import UIKit
import Alamofire
import DZNEmptyDataSet
import SVProgressHUD

class SearchController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var startValue = 0
    var arrayOfProducts: [Product]?
    var searchFilter: FilteredValue?
    var requesting: Bool?
    var isLastPage: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requesting = true
        isLastPage = true
        
        self.setupCollectionView()
        self.searchProduct()
    }
    
    func setupCollectionView() -> Void {
        arrayOfProducts = Array()
        collectionView.emptyDataSetSource = self
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: String(describing: ProductCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: ProductCell.self))
        collectionView.register(UINib(nibName: String(describing: LoadingCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: LoadingCell.self))
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: (UIScreen.main.bounds.size.width / 2) - 4, height: 280)
        flowLayout.scrollDirection = .vertical
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 2, 0, 2)
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
        collectionView.collectionViewLayout = flowLayout
    }
    
    @IBAction func filterButton(_ sender: Any) {
        let filterController = self.storyboard?.instantiateViewController(withIdentifier: "FilterController") as! FilterController
        filterController.delegate = self
        filterController.filter = searchFilter
        self.present(filterController, animated: true, completion: nil)
    }
    
    // MARK: request
    func searchProduct() -> Void {
        if !requesting! {
            return
        }
        
        SVProgressHUD.show()
        Alamofire.request(Router.Search.get(filter: searchFilter, start: startValue)).validate().responseJSON { (response) in
            self.requesting = false
            
            print("Search_URL -> " + (response.request?.url?.absoluteString)!)
            switch response.result {
            case .success:
                do {
                    guard let data = response.data else { return }
                    let products = try JSONDecoder().decode(ProductList.self, from: data)
                    
                    guard var tempArray = products.data else { return }
                    self.arrayOfProducts?.append(contentsOf: tempArray as [Product])
                    tempArray.removeAll()
                    
                    self.collectionView.reloadData()
                    
                    self.startValue += 10 // behave as pagination
                    self.isLastPage = self.startValue > (products.header?.totalProduct)!
                    
                    SVProgressHUD.dismiss()
                    print("startValue = " + String(self.startValue))
                } catch let error {
                    self.collectionView.reloadData()
                    SVProgressHUD.dismiss()
                    print(error.localizedDescription)
                }
            case .failure(let error):
                self.collectionView.reloadData()
                SVProgressHUD.dismiss()
                print("Error : " + error.localizedDescription)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension SearchController: UICollectionViewDataSource {
    // MARK: CollectionView Datasource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2;
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return (self.arrayOfProducts?.count)!
        } else {
            return isLastPage! ? 0 : 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ProductCell.self), for: indexPath) as! ProductCell
            cell.displayProduct(product: arrayOfProducts![indexPath.row])
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: LoadingCell.self), for: indexPath) as! LoadingCell
            cell.startAnimation()
            return cell
        }
    }
}

extension SearchController: UICollectionViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if velocity.y == 0 {
            for cell in collectionView.visibleCells {
                if cell.isKind(of: LoadingCell.classForCoder()) && !requesting! && !isLastPage! {
                    requesting = true
                    self.searchProduct()
                    break
                }
            }
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        for cell in collectionView.visibleCells {
            if cell.isKind(of: LoadingCell.classForCoder()) && !requesting! && !isLastPage! {
                requesting = true
                self.searchProduct()
                break
            }
        }
    }
}

extension SearchController: FilterDelegate {
    func didReceiveFilter(filter: FilteredValue) {
        searchFilter = filter
        startValue = 0
        requesting = true
        isLastPage = true
        self.arrayOfProducts?.removeAll()
        collectionView.reloadData()
        self.searchProduct()
        print(filter)
    }
}

extension SearchController: DZNEmptyDataSetSource {
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: "ic_search")
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let dictAttribute = [NSAttributedStringKey.foregroundColor: UIColor.gray,
                             NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18)]
        
        let attrText = NSAttributedString(string: "No result found for 'samsung'", attributes: dictAttribute)
        return attrText
    }
}
