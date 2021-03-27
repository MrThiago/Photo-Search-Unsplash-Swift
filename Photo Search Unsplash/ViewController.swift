//
//  ViewController.swift
//  Photo Search Unsplash
//
//  Created by Thiago Gouvea on 27/03/2021.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UISearchBarDelegate {
    

    let client_id = "ADD YOUR CLIENT ID HERE"
    var results: [Result] = []
    
    private var collectionView: UICollectionView?
    let searchbar = UISearchBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createSearchBar()
        createCollection()
        fetchPhotos(query: "orange")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        searchbar.frame = CGRect(x: 10, y: view.safeAreaInsets.top, width: getFrameSize().width-20, height: 50)
        collectionView?.frame = CGRect(x: 0, y: view.safeAreaInsets.top+55, width: getFrameSize().width, height: getFrameSize().height-55)
    }
    
    func getFrameSize() -> CGSize {
        return view.frame.size
    }
    
    func createSearchBar(){
        searchbar.delegate = self
        view.addSubview(searchbar)
    }
    
    func createCollection(){
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        layout.itemSize = CGSize(width: getFrameSize().width/2-1, height: getFrameSize().height/2-1)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: ImageCollectionViewCell.identifier)
        collectionView.dataSource = self
        
        view.addSubview(collectionView)
        collectionView.backgroundColor = .systemBackground
        self.collectionView = collectionView
    }
    
    func fetchPhotos(query: String) {
        let urlString = "https://api.unsplash.com/search/photos?page=1&query=\(query)&client_id=\(client_id)"
        
        guard let url = URL(string: urlString) else {
            return
        }
        let task = URLSession.shared.dataTask(with: url) { [weak self] (data, _, error) in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let jsonResponse = try JSONDecoder().decode(APIResponse.self, from: data)
                print(jsonResponse.results.count)
                DispatchQueue.main.async {
                    self?.results = jsonResponse.results
                    self?.collectionView?.reloadData()
                }
            } catch {
                print(error)
            }
            
        }
        task.resume()
    }

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return results.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let imageUrl = results[indexPath.row].urls.regular
        
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ImageCollectionViewCell.identifier, for: indexPath
        ) as? ImageCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.configure(with: imageUrl)
        return cell
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchbar.resignFirstResponder()
        if let text = searchBar.text {
            results = []
            collectionView?.reloadData()
            fetchPhotos(query: text)
        }
    }

}

