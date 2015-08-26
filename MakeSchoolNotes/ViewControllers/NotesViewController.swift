//
//  ViewController.swift
//  MakeSchoolNotes
//
//  Created by Martin Walsh on 29/05/2015.
//  Copyright (c) 2015 MakeSchool. All rights reserved.
//

import UIKit
import RealmSwift

class NotesViewController: UIViewController {
    
    @IBAction func unwindToSegue(segue: UIStoryboardSegue) {
        // Returns the root controller to the front of the stack
        if let identifier = segue.identifier {
            let realm = Realm()
            switch identifier {
            case "Save":
                let source = segue.sourceViewController as! NewNotesViewController //1
                
                realm.write() {
                    realm.add(source.currentNote!)
                }
                
            default:
                println("No one loves \(identifier)")
            }
            
            notes = realm.objects(Note).sorted("modificationDate", ascending: false) //2
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    var notes: Results<Note>! {
        didSet {
            // Whenever notes update, update the table view
            tableView?.reloadData()
        }
    }

    override func viewDidLoad() {
        let realm = Realm()
        super.viewDidLoad()
        tableView.dataSource = self
        
        notes = realm.objects(Note).sorted("modificationDate", ascending: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension NotesViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("NoteCell", forIndexPath: indexPath) as! NoteTableViewCell //1
        
        let row = indexPath.row
        let note = notes[row] as Note
        cell.note = note
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Int(notes?.count ?? 0)
    }
    
}

