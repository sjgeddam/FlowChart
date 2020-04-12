//
//  RecentNewsViewController.swift
//  FlowChart-iOSProject
//
//  Created by Abby Krishnan on 3/31/20.
//  Copyright © 2020 Abby Krishnan. All rights reserved.
//

import UIKit
struct NewsSource: Codable {
    let status: String
    let totalResults: Int
    let articles: [Article]
}

// MARK: - Article
struct Article: Codable {
    let source: Source?
    let author: String?
    let title, articleDescription: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String?
    let content: String?

    enum CodingKeys: String, CodingKey {
        case source, author, title
        case articleDescription = "description"
        case url, urlToImage, publishedAt, content
    }
}

// MARK: - Source
struct Source: Codable {
    let id, name: String?
}

class RecentNewsViewController: UIViewController,  UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var newsTableView: UITableView!
    var articles:[Article] = []
    var cellIdentifier = "Article"
    

    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController!.setNavigationBarHidden(true,animated:false)
        newsTableView.delegate = self
        newsTableView.dataSource = self        
        getNewsHeadlines()
        // Do any additional setup after loading the view.
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = newsTableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath as IndexPath) as! ArticleTableViewCell
        
        let row = indexPath.row
        let article = articles[row]
        cell.title.text = article.title
        cell.source.text = article.source?.name
        cell.articleDescription.text = article.articleDescription
        let url = URL(string:article.url ?? "")

        cell.viewTappedAction = {(cell) in UIApplication.shared.open(url!)}
        return cell
    }
    func getNewsHeadlines()
    {
        var url = URLComponents(string: "https://newsapi.org/v2/top-headlines?")
        let topicSearch = URLQueryItem(name: "q", value: "woman")
        let apiKey = URLQueryItem(name: "apiKey", value: "e659491de2a349d1a3e24c013d0137f1")
        url?.queryItems?.append(topicSearch)
        url?.queryItems?.append(apiKey)
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        URLSession.shared.dataTask(with: (url?.url)!) { (data, response, error ) in
            guard let data = data else { return }
            
            do {
                let rawFeed = try decoder.decode(NewsSource.self, from: data)
                self.articles = rawFeed.articles
                DispatchQueue.main.async {
                    self.newsTableView.reloadData()
                }
                
            } catch let decodeError as NSError {
                print("Decoder error: \(decodeError.localizedDescription)")
            }
        }.resume()
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
