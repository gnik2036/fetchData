//
//  ViewController.swift
//  testTask
//
//  Created by Mohammed Hassan on 28/11/2021.
//

import UIKit
import Alamofire    

class HomeVC: UIViewController{
    var data : HomeModelVC?
    var sectionData : [SectionData] = []
    var sectionDataTxt: [String] = []
    var hiddenSections = Set<Int>()

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
    }

   
    
    @objc
    private func hideSection(sender: UIButton) {
        let section = sender.tag
        
        func indexPathsForSection() -> [IndexPath] {
            var indexPaths = [IndexPath]()
            guard let states = self.sectionData[section].states else { return indexPaths}
            for row in 0..<states.count {
                indexPaths.append(IndexPath(row: row,
                                            section: section))
            }
            
            
            return indexPaths
        }
        
        if self.hiddenSections.contains(section) {
            self.hiddenSections.remove(section)
            self.tableView.insertRows(at: indexPathsForSection(),
                                      with: .fade)
        } else {
            self.hiddenSections.insert(section)
            self.tableView.deleteRows(at: indexPathsForSection(),
                                      with: .fade)
        }
    }
}

// MARK: - TableView

extension HomeVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sectionDataTxt.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.hiddenSections.contains(section) {
            return 0
        }
        
        return self.sectionData[section].states?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        if let currentSectionData = self.sectionData[indexPath.section].states
        {
            if let statesTitle = currentSectionData[indexPath.row].title
            {
                cell.textLabel?.text = statesTitle
            }
            

        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionButton = UIButton()
        if sectionDataTxt.count > 0
        {
            sectionButton.setTitle(self.sectionDataTxt[section],
                                   for: .normal)
            sectionButton.backgroundColor = .systemBlue
            sectionButton.tag = section
            sectionButton.addTarget(self,
                                    action: #selector(self.hideSection(sender:)),
                                    for: .touchUpInside)
        }
      

        return sectionButton
    }
}




// MARK: - configure api data
extension HomeVC {
func handleSectionData(sectionData : [SectionData])
    {
        
        for item in sectionData {
            self.sectionDataTxt.append(item.title ?? " ")
            
        }
        
    }
    
    func handleTableData (sectionData : [SectionData])
    {
        
    }
    
}


// MARK: - Alamofire
extension HomeVC {
  func fetchData()
    {
        
     AF.request("https://app.findq8.tocaanme.com/api/areas/cities").validate().responseDecodable(of: HomeModelVC.self) { (response) in
         guard let cites = response.value else { return }

         self.data = cites
         if self.data?.success ?? false {
             guard let sections = self.data?.data else {
                 return
             }
             self.sectionData = sections
             self.handleSectionData(sectionData: self.sectionData)
             self.tableView.reloadData()
             
         }
         else
         {
             //pop up
             print ("API Fail")
         }
         
         
       self.tableView.reloadData()
     }
   }
   

  
}
