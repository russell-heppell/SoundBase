//
//  WishlistTableViewController.swift
//  SoundBase
//
//  Created by Russell Heppell on 5/1/21.
//

import UIKit
import CoreData

class WishlistTableViewController: UITableViewController {

    var musicWishlist: [NSManagedObject] = []
    var managedObjectContext: NSManagedObjectContext!
    var appDelegate: AppDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        appDelegate = UIApplication.shared.delegate as? AppDelegate
        managedObjectContext = appDelegate.persistentContainer.viewContext
        
        musicWishlist = fetchMusic()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        musicWishlist = fetchMusic()
        self.tableView.reloadData()
    }
    
    func fetchMusic() -> [NSManagedObject] {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Wishlist")
        var music: [NSManagedObject] = []
        do {
            music = try self.managedObjectContext.fetch(fetchRequest)
        } catch {
                 print("getWishlist error: \(error)")
        }
            return music
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return musicWishlist.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubtitleCell", for: indexPath)

        // Configure the cell...
        
        let music = musicWishlist[indexPath.row]
        let titleText = music.value(forKey: "title") as? String
        let formatText = music.value(forKey: "format") as? String
        let imageData = music.value(forKey: "albumImage") as? NSData
        
        let image = UIImage(data: imageData! as Data)
                
        if let y = music.value(forKey: "year") as? String{
            cell.textLabel?.text = "\(titleText!) - \(y)"

        }
        else{
            cell.textLabel?.text = "\(titleText!) - year undefined"

        }
        cell.detailTextLabel?.text = formatText
        cell.imageView?.image = image

        return cell
    }
    
    func deleteMusicItem(_ item: NSManagedObject) {
        managedObjectContext.delete(item)
        appDelegate.saveContext()
    }
    

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let musicItem = musicWishlist[indexPath.row]
            deleteMusicItem(musicItem)
            musicWishlist.remove(at: indexPath.row)
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
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
        
        if(segue.identifier == "WishlistDetail")
        {
            let detailVC = segue.destination as? WishlistDetailViewController
            let index = self.tableView.indexPathForSelectedRow?.row
            let music = musicWishlist[index!]
            detailVC?.item = music
        }
    }
    

}
