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
        tableView.dataSource = self
        tableView.delegate = self
        
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

extension NotesViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var selectedNote = notes[indexPath.row]      //1
        // self.performSegueWithIdentifier("ShowExistingNote", sender: self)     //2
    }
    
    // 3
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    // 4
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let note = notes[indexPath.row] as Object
            
            let realm = Realm()
            
            realm.write() {
                realm.delete(note)
            }
            
            notes = realm.objects(Note).sorted("modificationDate", ascending: false)
        }
    }
    
}

