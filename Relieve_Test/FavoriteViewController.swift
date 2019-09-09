//
//  FavoriteViewController.swift
//  Relieve_Test
//
//  Created by Chinh on 1/23/19.
//

import UIKit
import Pastel
import SQLite3

class FavoriteViewController: UIViewController {

    let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("favoriteDatabase.sqlite")
    var db:OpaquePointer? = nil
    let insertStatementString = "INSERT INTO FavoriteCombos(audioArray) VALUES"
    
    @IBOutlet weak var combo1: RoundedButton!
    @IBOutlet weak var combo2: RoundedButton!
    @IBOutlet weak var combo3: RoundedButton!
    @IBOutlet weak var combo4: RoundedButton!
    @IBOutlet weak var combo5: RoundedButton!
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setGradient()
        createTable()
        openDatabase()

    }
    
    
    @IBAction func btnHome() {
        let home = storyboard?.instantiateViewController(withIdentifier: "Home") as! HomeViewController
        self.present(home, animated: true, completion: nil)

    }
    
    @IBAction func pressOnCombo(_ sender: RoundedButton!) {
//        sender.isSelected = !sender.isSelected
        
        
    }

    
    
    func createTable(){
        if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS FavoriteCombos(id INT PRIMARY KEY, audioArray VARCHAR(255))", nil, nil, nil) == SQLITE_OK {
            print("Create table successfull")
        } else {
            print("Unable to create table OR table exists")
        }
    }
    
    func openDatabase() {
        
        if sqlite3_open(fileURL.path, &db) == SQLITE_OK {
            print("Open database successfull \(fileURL.path)")
        } else {
            print("Unable to open database")
        }
    }
    func insert(){
        var insertStatement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            
            print("insert successfull");
            
        } else {
            print("Unable to insert");
        }
        
    }


}
