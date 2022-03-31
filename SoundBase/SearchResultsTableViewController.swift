//
//  SearchResultsTableViewController.swift
//  SoundBase
//
//  Created by Russell Heppell on 4/26/21.
//

import UIKit

class SearchResultsTableViewController: UITableViewController {
    
    var searchResults: [String: Any]?
    var musicResults: [MusicSearchResult] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        if let results = searchResults{
            parseResults(results: results)
        }
        
        
        self.tableView.reloadData()
    }
    
    func parseResults(results: [String: Any]){
        // convert the json to MusicSearchResult objects and add them to the array
        
        // get to results
        let array = results["results"] as! NSArray
        
        // loop through results
        for items in array{
            
            //music item variable to be populated
            let musicItem = MusicSearchResult()
            
            // turn each result into its own array, and grab desired elements.
            let album = items as! [String: Any]
            let title = album["title"] as? String
            let format = album["format"] as? [String]
            let year = album["year"] as? String
            let imageURL = album["cover_image"] as? String
                        
            musicItem.title = title
            musicItem.format = format![0]
            musicItem.year = year
            musicItem.imageURL = imageURL
            musicItem.albumImage = UIImage(named: "default-image-620x600.jpg")
            
            musicResults.append(musicItem)
            
            if let link = musicItem.imageURL{
                loadAlbumImage(link, music: musicItem)
            }
        }
    }
    
    func loadAlbumImage(_ urlString: String, music: MusicSearchResult) {
        // URL comes from API response; definitely needs some safety checks

        if let urlStr = urlString.addingPercentEncoding(
            withAllowedCharacters: .urlQueryAllowed) {
            if let url = URL(string: urlStr) {
                let dataTask = URLSession.shared.dataTask(with: url, completionHandler: {(data, response, error) -> Void in
                     if let imageData = data {
                         let image = UIImage(data: imageData)
                        music.albumImage = image
                         DispatchQueue.main.async {
                            
                            self.tableView.reloadData()
                         }
                     }
                })
                dataTask.resume()
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return musicResults.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubtitleCell", for: indexPath)

        // Configure the cell...
        
        let musicItem = musicResults[indexPath.row]
        
        if let year = musicItem.year{
            cell.textLabel?.text = "\(musicItem.title!) - \(year)"
        }
        else{
            cell.textLabel?.text = musicItem.title
        }
        
        if let format = musicItem.format{
            cell.detailTextLabel?.text = format
            
        }
        else{
            cell.detailTextLabel?.text = "format not specified"
        }
        
        cell.imageView?.image = musicItem.albumImage

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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if(segue.identifier == "MusicDetail")
        {
            let detailVC = segue.destination as! MusicDetailViewController
            let index = self.tableView.indexPathForSelectedRow?.row

            detailVC.musicItem = musicResults[index!]
            
        }
    }
}
