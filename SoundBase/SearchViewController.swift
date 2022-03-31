//
//  SearchViewController.swift
//  SoundBase
//
//  Created by Russell Heppell on 4/26/21.
//

import UIKit
import Alamofire
import SwiftyJSON

// the view controller where the user enters their search for Discogs.

// things the user can search on:
// format (Vinyl, CD, cassette) - format parameter
// Artist - artist parameter
// Album - release_title parameter

class SearchViewController: UIViewController {
    
    // url and keys for the url
    let DISCOGS_AUTH_URL = "https://api.discogs.com/database/search?"
    let DISCOGS_KEY = "wXZypVXVOdaCmaKKeZXk"
    let DISCOGS_SECRET = "mscemKwmHBQmlhacyXNZGslaAXfEDakg"
    
    // array for the search results
    var searchResults: [String: Any]?

    // outlets for the text fields
    @IBOutlet weak var artistTextField: UITextField!
    @IBOutlet weak var albumTextField: UITextField!
    @IBOutlet weak var formatTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func searchButtonClicked(_ sender: UIButton) {
        // need to make sure at least one of the text boxes has search criteria
        var artistQuery = ""
        var albumQuery = ""
        var formatQuery = ""
        var discogsURL = ""
        
        // all 3 text fields
        if(artistTextField.hasText && albumTextField.hasText && formatTextField.hasText){
            artistQuery = artistTextField.text!
            albumQuery = albumTextField.text!
            formatQuery = formatTextField.text!
            
            discogsURL = "\(DISCOGS_AUTH_URL)artist=\(artistQuery)&release_title=\(albumQuery)&format=\(formatQuery)&key=\(DISCOGS_KEY)&secret=\(DISCOGS_SECRET)"
            
            searchDiscogs(url: discogsURL)
        }
        // artist and album
        else if (artistTextField.hasText && albumTextField.hasText){
            artistQuery = artistTextField.text!
            albumQuery = albumTextField.text!
            
            discogsURL = "\(DISCOGS_AUTH_URL)artist=\(artistQuery)&release_title=\(albumQuery)&key=\(DISCOGS_KEY)&secret=\(DISCOGS_SECRET)"
            
            searchDiscogs(url: discogsURL)
        }
        // artist and format
        else if (artistTextField.hasText && formatTextField.hasText){
            artistQuery = artistTextField.text!
            formatQuery = formatTextField.text!
            
            discogsURL = "\(DISCOGS_AUTH_URL)artist=\(artistQuery)&format=\(formatQuery)&key=\(DISCOGS_KEY)&secret=\(DISCOGS_SECRET)"
            
            searchDiscogs(url: discogsURL)
        }
        // album and format
        else if(albumTextField.hasText && formatTextField.hasText){
            albumQuery = albumTextField.text!
            formatQuery = formatTextField.text!
            
            discogsURL = "\(DISCOGS_AUTH_URL)release_title=\(albumQuery)&format=\(formatQuery)&key=\(DISCOGS_KEY)&secret=\(DISCOGS_SECRET)"
            
            searchDiscogs(url: discogsURL)
        }
        // artist only
        else if(artistTextField.hasText){
            artistQuery = artistTextField.text!
            
            discogsURL = "\(DISCOGS_AUTH_URL)artist=\(artistQuery)&key=\(DISCOGS_KEY)&secret=\(DISCOGS_SECRET)"
            
            searchDiscogs(url: discogsURL)
        }
        // album only
        else if(albumTextField.hasText){
            albumQuery = albumTextField.text!
            
            discogsURL = "\(DISCOGS_AUTH_URL)release_title=\(albumQuery)&key=\(DISCOGS_KEY)&secret=\(DISCOGS_SECRET)"
            
            searchDiscogs(url: discogsURL)
        }
        // format only
        else if (formatTextField.hasText){
            formatQuery = formatTextField.text!

            discogsURL = "\(DISCOGS_AUTH_URL)format=\(formatQuery)&key=\(DISCOGS_KEY)&secret=\(DISCOGS_SECRET)"
            
            searchDiscogs(url: discogsURL)
        }
        
        // if we fall out, all text fields were empty when search was pressed, so do nothing.
    }
    
    // function to perform the search in discogs
    func searchDiscogs(url: String){
        
        if let encodedURL = url.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed), let newUrl = URL(string: encodedURL){
            AF.request(newUrl).responseJSON { response in
                
                switch response.result{
                case .success(let value):
                    if let json = value as? [String:Any]{
                        
                        self.searchResults = json
                        self.performSegue(withIdentifier: "ShowSearchResults", sender: nil)
                    }
                    else{
                        print("not the correct type to cast JSON to.")
                    }
                case .failure(let failure):
                    print(failure)
                }
            }
        }
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if(segue.identifier == "ShowSearchResults"){
            
            let nextVC = segue.destination as! SearchResultsTableViewController
            nextVC.searchResults = self.searchResults
        }
    }
}
