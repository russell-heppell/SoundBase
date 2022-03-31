//
//  WishlistDetailViewController.swift
//  SoundBase
//
//  Created by Russell Heppell on 5/1/21.
//

import UIKit
import CoreData

class WishlistDetailViewController: UIViewController {
    
    var item: NSManagedObject?
    var managedObjectContext: NSManagedObjectContext!
    var appDelegate: AppDelegate!

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var formatLabel: UILabel!
    @IBOutlet weak var albumImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        managedObjectContext = appDelegate.persistentContainer.viewContext
        
        if let musicItem = item{
            
            let titleText = musicItem.value(forKey: "title") as? String
            let formatText = musicItem.value(forKey: "format") as? String
            let imageData = musicItem.value(forKey: "albumImage") as? NSData
            let image = UIImage(data: imageData! as Data)
            
            titleLabel.text = "Title: \(titleText!)"
            
            if let y = musicItem.value(forKey: "year") as? String{
                yearLabel.text = "Year: \(y)"
            }
            else{
                yearLabel.text = "Year: undefined"
            }
            formatLabel.text = "Format: \(formatText!)"
            albumImageView.image = image

        }
    }
    
    @IBAction func moveToSoundBaseTapped(_ sender: UIButton) {
        // move the object to the SoundBase and delete from wishlist
        
        addMusicToSoundBase()
        deleteMusicItem(item!)
        
        let alert = UIAlertController(title: "Item moved to your SoundBase!", message: "Be sure to go add a rating and show your musical appreciation.", preferredStyle: .alert)
        let action = UIAlertAction(title: "Okay", style: .default,
            handler: { (action) in
            })
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func addMusicToSoundBase(){
        
        let soundBaseData = NSEntityDescription.insertNewObject(forEntityName:
                             "SoundBase", into: self.managedObjectContext)
        
        let titleText = item!.value(forKey: "title") as? String
        let yearText = item!.value(forKey: "year") as? String
        let formatText = item!.value(forKey: "format") as? String
        let imageData = item!.value(forKey: "albumImage") as? NSData
        
        soundBaseData.setValue(titleText, forKey: "title")
        soundBaseData.setValue(yearText, forKey: "year")
        soundBaseData.setValue(formatText, forKey: "format")
        soundBaseData.setValue(imageData, forKey: "albumImage")
        
        appDelegate.saveContext() // In AppDelegate.swift
    }
    
    func deleteMusicItem(_ item: NSManagedObject) {
        managedObjectContext.delete(item)
        appDelegate.saveContext()
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
