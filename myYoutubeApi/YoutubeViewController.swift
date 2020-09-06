//
//  YoutubeTableViewController.swift
//  myYoutubeApi
//
//  Created by Hsuan on 2020/9/5.
//  Copyright © 2020 Hsuan. All rights reserved.
//

import UIKit

class YoutubeViewController: UIViewController,UITableViewDataSource {
    
    @IBOutlet weak var tabelView: UITableView!
    
    var youtubes = YoutubeData(items: [Item]())

    
    func fetchYoutube() {
        if let urlStr = "https://www.googleapis.com/youtube/v3/playlistItems?part=snippet,contentDetails,status&playlistId=UU7ovu6a8ydIbDy0fAKmoZ9A&key=AIzaSyBUjR9A3kGPrX1ycT1X9KYMFxBvnM3jaBU&maxResults=50".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
          let url = URL(string: urlStr) {
           
           URLSession.shared.dataTask(with: url) { (data, response , error) in
               let decoder = JSONDecoder()
            
            
               if let data = data,
                  let youtubes = try? decoder.decode(YoutubeData.self, from: data) {
                //try後是外部拉回來的json資料,塞到let後的youtubes
                 
                   self.youtubes = youtubes //白色的youtubes再放回綠色youtubes給self.tabelView.reloadData()重跑 重跑會連tabelview所有方法都重新呼叫一次
                   
                   DispatchQueue.main.async {
                    self.tabelView.reloadData()

                   }
                   
               } else {
                   print("error")
               }
           }.resume()
           
        }
    }

    override func viewDidLoad() {
    
        super.viewDidLoad()
        
        fetchYoutube()
    }

    // MARK: - Table view data source

     func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        //youtubes.count會等於撈回來的資料筆數
        
        return youtubes.items.count
    }

  
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "photoCell", for: indexPath)as!YoutubeTableViewCell
        
        let items = youtubes.items[indexPath.row]
        cell.titleLabel.text = items.snippet.title
        cell.ExcerptLabel.text = items.snippet.description
        
        
        cell.photoImageview.image = nil //先把圖片清空
        
        //利用 URLSession下載圖片 讓執行畫面不會卡住 利用background thread在背景抓資料和執行我們傳入的{ }程式
        URLSession.shared.dataTask(with: items.snippet.thumbnails.medium.url) { (data, response, error) in
                if let data = data {
                    DispatchQueue.main.async { //再放回主執行緒
                        cell.photoImageview.image = UIImage(data: data)
                    }
                }
            }.resume()
           
        
        
       

        return cell
    }
  

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
