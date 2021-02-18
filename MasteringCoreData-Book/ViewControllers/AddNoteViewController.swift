//
//  AddNoteViewController.swift
//  MasteringCoreData-Book
//
//  Created by Hossam on 17/02/2021.
//

import UIKit
import Combine
class AddNoteViewController : UIViewController {
    
    private var subscribtions = Set<AnyCancellable>.init()
    var addNotesPublisher : PassthroughSubject<Void , Never>? = nil
    
    let addNote = UIBarButtonItem.init(image: UIImage(systemName: "square.and.arrow.down"), style: .done, target: self, action: #selector(onPressDone))
    
    let titleTextField : UITextField =  {
        let textfield = UITextField()
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.backgroundColor = UIColor.white
        textfield.placeholder = "Enter Title ... "
        textfield.borderStyle = .roundedRect
        return textfield
    }()
    
    let contentTextView : UITextView  = {
        let textfield = UITextView()
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.layer.cornerRadius = 10
        return textfield
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
        self.view.addSubview(titleTextField)
        self.view.addSubview(contentTextView)
        
        NSLayoutConstraint.activate([
            titleTextField.leadingAnchor.constraint(equalTo: contentTextView.leadingAnchor),
            titleTextField.trailingAnchor.constraint(equalTo: contentTextView.trailingAnchor),
            
            titleTextField.bottomAnchor.constraint(equalTo: contentTextView.topAnchor , constant: -30),
            titleTextField.heightAnchor.constraint(equalToConstant: 80),
            
            contentTextView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            contentTextView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            contentTextView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5),
            contentTextView.widthAnchor.constraint(equalTo: view.widthAnchor , multiplier: 0.8),
        
        ])
        

        
        
        navigationItem.rightBarButtonItems = [addNote]
        addNote.isEnabled = false
        
        //Publishers
       
        
        NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: titleTextField)
            .sink(receiveValue: { [weak self ] _  in
                
                if self?.titleTextField.text?.isEmpty == true || self?.contentTextView.text.isEmpty == true {
                    self?.addNote.isEnabled = false
                }else{
                    self?.addNote.isEnabled = true
                }
            })
            .store(in: &subscribtions)
        
        NotificationCenter.default.publisher(for: UITextView.textDidChangeNotification, object: contentTextView)
            .sink(receiveValue: { [weak self ] _  in
                
                if self?.titleTextField.text?.isEmpty == true || self?.contentTextView.text.isEmpty == true {
                    self?.addNote.isEnabled = false
                }else{
                    self?.addNote.isEnabled = true
                }
            })
            .store(in: &subscribtions)
      
        
        
        
        
    }
    
    @objc func onPressDone(){
        guard let title = titleTextField.text , let content = contentTextView.text else {return}
       
    let note = Note(context: context)
        note.title = title
        note.contents = content
        note.createdAt = Date()
        
        context.insert(note)
    
        try? context.save()
    
        self.navigationController?.popViewController(animated: true)
        
        addNotesPublisher?.send()
    
    }
    
    
}

