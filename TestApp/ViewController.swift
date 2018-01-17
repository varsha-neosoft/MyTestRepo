//
//  ViewController.swift
//  TestApp
//
//  Created by varsha on 1/16/18.
//  Copyright © 2018 varsha. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate {

    var tableView = UITableView()

    fileprivate let tableCellReuseIdentifier = "MyCell"

    fileprivate let tableview = UITableView()
    
    var jsonDict = [String:Any]()
    var detailsArray = [[String:Any]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // Load Json Data
        self.getJsonFromBundle()
        // Setup navigation bar
        setNavigationBar()
        // SetUp Table view
        configureTableView()

        // Load data from URL
        // Tried with every possible request but not able to get response.
        WebserviceHelper().callFetchDataApi() { (response) in
        }
    }
    
    // MARK: - SetNavigationBar
    func setNavigationBar() {
        let screenSize: CGRect = UIScreen.main.bounds
        let navBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: 44))
        if jsonDict.count != 0 {
            if let title = jsonDict["title"] {
                self.title = title as? String
            }
        }
        self.view.addSubview(navBar)
    }

    // MARK: - GetJsonFromBundle
    func getJsonFromBundle(){
            let file = Bundle.main.path(forResource: "countryJson", ofType: "json")
            let data = try? Data(contentsOf: URL(fileURLWithPath: file!))
        do {
        
            jsonDict = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String: Any]
            detailsArray = jsonDict["rows"] as! [[String:Any]]

        } catch let error as NSError{
            print(error.debugDescription)
            fatalError("Failed to initiate top level JSON dictionary")
        }

            self.tableView.reloadData()

    }
    
    // MARK: - ConfigureTableView

    func configureTableView() {
        tableview.dataSource = self
        tableview.estimatedRowHeight = 100
        tableview.rowHeight = UITableViewAutomaticDimension
        tableview.register(MyTableViewCell.self, forCellReuseIdentifier: tableCellReuseIdentifier)

        view.addSubview(tableview)
        tableview.translatesAutoresizingMaskIntoConstraints = false
        tableview.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableview.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableview.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableview.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableview.contentInset = UIEdgeInsetsMake(64,0,0,0);

    }

    
  
}

// MARK: - Table View DataSource
extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return detailsArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = MyTableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: tableCellReuseIdentifier)
        
        if detailsArray.count > 0 {
            
            if let name = detailsArray[indexPath.row]["title"] as? String {
                
                cell.nameLabel.text = name
                
            }
            if let description = detailsArray[indexPath.row]["description"] as? String {
                
                cell.detailLabel.text = description
                
            }
            if let image = detailsArray[indexPath.row]["imageHref"] as? String {
                
                URLSession.shared.dataTask(with: NSURL(string: image)! as URL, completionHandler: { (data, response, error) -> Void in
                    
                    if error != nil {
                        return
                    }
                    // Load images asynchronuously. In this you can use third party libraries as well like SDWebImage.
                    DispatchQueue.main.async(execute: { () -> Void in
                        let image = UIImage(data: data!)
                        cell.imgView.image = image
                    })
                    
                }).resume()
            }
        }
        return cell
    }
}