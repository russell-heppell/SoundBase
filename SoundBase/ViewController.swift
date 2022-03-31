//
//  ViewController.swift
//  SoundBase
//
//  Created by Russell Heppell on 4/24/21.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController {
    
    let DISCOGS_AUTH_URL = "https://api.discogs.com/database/search?"
    let DISCOGS_KEY = "wXZypVXVOdaCmaKKeZXk"
    let DISCOGS_SECRET = "mscemKwmHBQmlhacyXNZGslaAXfEDakg"

    var dataFromDiscogs = ""
    
    // things the user can search on:
    // format (Vinyl, CD, cassette) - format parameter
    // Artist - artist parameter
    // Album - release_title parameter

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    
}

