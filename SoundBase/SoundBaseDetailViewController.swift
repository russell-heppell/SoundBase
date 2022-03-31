//
//  SoundBaseDetailViewController.swift
//  SoundBase
//
//  Created by Russell Heppell on 5/1/21.
//

import UIKit
import CoreData

class SoundBaseDetailViewController: UIViewController {
    
    var item: NSManagedObject?
    var managedObjectContext: NSManagedObjectContext!
    var appDelegate: AppDelegate!

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var formatLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var albumImageView: UIImageView!
    
    @IBAction func addEditTapped(_ sender: Any) {
        addEditRatingAlert()
    }
    
    func addEditRatingAlert() {
        let alert = UIAlertController(title: "Add/Edit Rating",
            message: "Enter the new rating", preferredStyle: .alert)
        alert.addTextField(configurationHandler: { (textField) in
            textField.placeholder = "rating"
        })
        alert.addAction(UIAlertAction(title: "Apply rating", style: .default,
            handler: { (action) in
                let rating = alert.textFields?[0].text
                let ratingNum = Int(rating!)
                self.saveNewRating(rating: ratingNum!)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func saveNewRating(rating: Int){
        
        item?.setValue(rating, forKey: "rating")
        appDelegate.saveContext()
        ratingLabel.text = "rating: \(rating)"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        managedObjectContext = appDelegate.persistentContainer.viewContext

        // Do any additional setup after loading the view.
        
        if let musicItem = item{
            
            let titleText = musicItem.value(forKey: "title") as? String
            let formatText = musicItem.value(forKey: "format") as? String
            let imageData = musicItem.value(forKey: "albumImage") as? NSData
            
            let image = UIImage(data: imageData! as Data)
            
            if let rating = musicItem.value(forKey: "rating") as? Int{
                ratingLabel.text = "rating: \(rating)"
            }
            else{
                ratingLabel.text = "rating: unrated"
            }
            
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
