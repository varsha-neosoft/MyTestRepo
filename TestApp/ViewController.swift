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
    // SetUp Refresh Control
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(ViewController.handleRefresh(_:)), for: UIControlEvents.valueChanged)
        refreshControl.tintColor = UIColor.red
        
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // Load Json Data
        // self.getJsonFromBundle()
        
        // SetUp Table view
        configureTableView()

        // Call to API
        self.fetchDataFromInternet()
        
        // Setup navigation bar
        setNavigationBar()
    }
    
    // MARK: - Load data from URL
    func fetchDataFromInternet()  {
        WebserviceHelper().callFetchDataApi() { (response) in
            self.jsonDict = response!
            self.detailsArray = self.jsonDict["rows"] as! [[String:Any]]
            self.tableview.reloadData()
            // Setup Navigation Title
            if self.jsonDict.count != 0 {
                if let title = self.jsonDict["title"] {
                    self.title = title as? String
                }
            }
        }
    }
   
    
    // MARK: - SetNavigationBar
    func setNavigationBar() {
        let screenSize: CGRect = UIScreen.main.bounds
        let navBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: 44))
        self.view.addSubview(navBar)
    }

    // *************  Static fetch *********** //
    /*
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
 */
    
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
        // Add Refresh Control
        tableview.addSubview(self.refreshControl)

    }
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        // Do some reloading of data and update the table view's data source
        // Check for new Json Data
        // Call to API
        self.fetchDataFromInternet()
        refreshControl.endRefreshing()
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
            /*
             // async image with URLSession
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
             */
            // async image with NSURLConecction
            if let image = detailsArray[indexPath.row]["imageHref"] as? String {
                if let url = URL(string: image) {
                    let request = URLRequest(url: url)
                    NSURLConnection.sendAsynchronousRequest(request as URLRequest, queue: .main, completionHandler: { (response, data, error) in
                        if let imageData = data as NSData? {
                            cell.imgView.image = UIImage(data: imageData as Data)
                        }
                    })
                }
            }
                
            else{
            }
        }
        return cell
    }
}
