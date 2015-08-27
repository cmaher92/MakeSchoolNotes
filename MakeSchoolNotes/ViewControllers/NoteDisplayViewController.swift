//
//  NoteDisplayViewController.swift
//  MakeSchoolNotes
//
//  Created by Connor Maher on 8/26/15.
//  Copyright (c) 2015 MakeSchool. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift
import ConvenienceKit

class NoteDisplayViewController: UIViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentTextView: TextView!
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    @IBOutlet weak var toolbarBottomSpace: NSLayoutConstraint!
    
    var edit: Bool!
    
    var keyboardNotificationHandler: KeyboardNotificationHandler?
    
    var note: Note? {
        didSet {
            displayNote(note)
        }
    }

    override func viewWillAppear(animated: Bool) {
        keyboardNotificationHandler = KeyboardNotificationHandler()
        
        keyboardNotificationHandler!.keyboardWillBeHiddenHandler = { (height: CGFloat) in
            UIView.animateWithDuration(0.3){
                self.toolbarBottomSpace.constant = 0
                self.view.layoutIfNeeded()
            }
        }
        super.viewWillAppear(animated)
        
        displayNote(self.note)
        
        titleTextField.returnKeyType = .Next //1
        titleTextField.delegate = self //2
        
        if edit {
            deleteButton.enabled = false
        }
    }
    

    //MARK: Business Logic
    
    func displayNote(note: Note?) {
        if let note = note, titleTextField = titleTextField, contentTextView = contentTextView {
            titleTextField.text = note.title
            contentTextView.text = note.content
            
            if count(note.title)==0 && count(note.content)==0 { //1
                titleTextField.becomeFirstResponder()
            }
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
         super.viewWillDisappear(animated)
        
        saveNote()
    }
    func saveNote() {
        if let note = note {
            let realm = Realm()
            
            realm.write {
                if (note.title != self.titleTextField.text || note.content != self.contentTextView.textValue) {
                    note.title = self.titleTextField.text
                    note.content = self.contentTextView.textValue
                    note.modificationDate = NSDate()
                }
            }
        }
    }
}

extension NoteDisplayViewController: UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        if (textField == titleTextField) {
            contentTextView.returnKeyType = .Done
            contentTextView.becomeFirstResponder()
        }
        
        return false
    }
}