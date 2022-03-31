//
//  MusicDetailViewController.swift
//  SoundBase
//
//  Created by Russell Heppell on 5/1/21.
//

import UIKit
import CoreData

class MusicDetailViewController: UIViewController {
    
    var musicItem: MusicSearchResult!
    var managedObjectContext: NSManagedObjectContext!
    var appDelegate: AppDelegate!

    @IBOutlet weak var formatLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var albumImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if let item = musicItem{
            titleLabel.text = "Title: \(item.title!)"
            
            if let y = item.year{
                yearLabel.text = "Year: \(y)"
            }
            else{
                yearLabel.text = "Year: undefined"
            }
            
            formatLabel.text = "Format: \(item.format!)"
            albumImageView.image = item.albumImage
        }
        
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        managedObjectContext = appDelegate.persistentContainer.viewContext
    }
    
    @IBAction func addToSoundBaseTapped(_ sender: UIButton) {
        addMusicToSoundBase()
        
        let alert = UIAlertController(title: "Added to your SoundBase!", message: "Be sure to go add a rating and show your musical appreciation.", preferredStyle: .alert)
        let action = UIAlertAction(title: "Okay", style: .default,
            handler: { (action) in
            })
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func addToWishlistTapped(_ sender: UIButton) {
        addMusicToWishlist()
        
        let alert = UIAlertController(title: "Added to your Wishlist!", message: "Go check it out!", preferredStyle: .alert)
        let action = UIAlertAction(title: "Okay", style: .default,
            handler: { (action) in
            })
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func addMusicToSoundBase(){
        
        let soundBaseData = NSEntityDescription.insertNewObject(forEntityName:
                             "SoundBase", into: self.managedObjectContext)
        
        soundBaseData.setValue(musicItem.title, forKey: "title")
        soundBaseData.setValue(musicItem.year, forKey: "year")
        soundBaseData.setValue(musicItem.format, forKey: "format")
        
        // image is weird, convert to binary data first
        let imageData = musicItem.albumImage!.pngData()
        soundBaseData.setValue(imageData, forKey: "albumImage")
        
        appDelegate.saveContext() // In AppDelegate.swift
    }
    
    
    func addMusicToWishlist(){
        
        let soundBaseData = NSEntityDescription.insertNewObject(forEntityName:
                             "Wishlist", into: self.managedObjectContext)
        
        soundBaseData.setValue(musicItem.title, forKey: "title")
        soundBaseData.setValue(musicItem.year, forKey: "year")
        soundBaseData.setValue(musicItem.format, forKey: "format")
        
        // image is weird, convert to binary data first
        let imageData = musicItem.albumImage!.pngData()
        soundBaseData.setValue(imageData, forKey: "albumImage")
        
        appDelegate.saveContext() // In AppDelegate.swift
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
