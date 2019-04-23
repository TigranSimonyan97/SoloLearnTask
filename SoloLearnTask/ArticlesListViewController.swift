//
//  ArticleCell.swift
//  SoloLearnTask
//
//  Created by Tigran  Simonyan on 4/23/19.
//  Copyright © 2019 Tigran  Simonyan. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import Alamofire
import AlamofireImage

class ArticlesListViewController: UIViewController {

    @IBOutlet weak var articlesTableView: UITableView!
    @IBOutlet weak var refreshControl: UIActivityIndicatorView!
    
    let cellIdentifier = "articleCell"

    var articles = BehaviorRelay<[ArticleModel]>(value: [])
    var selectedArticle: ArticleModel!
    
    var articlesImages = [UIImage]()
    
    var isLoading = false
    
    var currentPageIndex = BehaviorRelay<Int>(value: 1)

    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureArticlesTableView()
        configureReactiveBinding()
    }
    
    fileprivate func configureArticlesTableView() {
        articlesTableView.delegate = self
        articlesTableView.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 10.0, right: 0.0)
        articlesTableView.tableFooterView?.isHidden = true
        articlesTableView.estimatedRowHeight = 150
        articlesTableView.rowHeight = UITableView.automaticDimension
    }
    
    private func configureReactiveBinding() {
        currentPageIndex.subscribe(onNext: { (page) in
            NetworkManager.instance.retrieveData(for: page, completion: { (newArticles) in
                self.articles.accept(self.articles.value + newArticles)
            })
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        .disposed(by: disposeBag)
        
        
        articles.bind(to: articlesTableView.rx.items(cellIdentifier: cellIdentifier)) { index, model, cell in
                guard let articleCell = cell as? ArticleCell else { return }
                articleCell.articleTitleLabel.text = model.webTitle
                articleCell.articlePhotoImageView.image = UIImage(named: "photoalbum")
                if let imagePath = model.fields["thumbnail"], let imageURL = URL(string: imagePath) {
                    articleCell.articlePhotoImageView.af_setImage(withURL: imageURL)
                }
            }
            .disposed(by: disposeBag)
        
        articlesTableView.rx.modelSelected(ArticleModel.self)
            .map { let articleDetailsViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "articleDetailsViewController") as! ArticleDetailsViewController
                    articleDetailsViewController.article = $0
                return articleDetailsViewController
            }
            .subscribe(onNext: { [weak self] articleDetailsViewController in
                self?.navigationController?.pushViewController(articleDetailsViewController, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
        
        if segue.identifier == "showArticleDetails" {
            let destination = segue.destination as! ArticleDetailsViewController
            destination.article = self.selectedArticle
        }
    }
}

extension ArticlesListViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.item == (currentPageIndex.value - 1) * 20 + 10 {
            currentPageIndex.accept(currentPageIndex.value + 1)
        }
    }
}
