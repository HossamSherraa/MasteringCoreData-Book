//
//  UndoRedoViewController.swift
//  MasteringCoreData-Book
//
//  Created by Hossam on 18/02/2021.
//

import UIKit
import Combine
import CoreData
class UndoRedoViewController : UIViewController{
    var note : Note?
    @Published var titleLabelText = ""
    
    var context : NSManagedObjectContext!

    var subscribtions = Set<AnyCancellable>()
    let unDo : UIButton = {
        let label = UIButton(type: .system)
        
        label.setTitle("Undo", for: .normal)
        
        return label
    }()
    
    let redo : UIButton = {
        let label = UIButton(type: .system)
        
        label.setTitle("redo", for: .normal)
        return label
    }()
    
    let titleLabel : UIButton = {
        
        let label = UIButton(type: .system)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.context = CoreDataManager.context
        self.view.addSubview(titleLabel)
        titleLabelText = note?.title ?? ""
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
        self.view.backgroundColor = .white
        
        self.navigationItem.leftBarButtonItem = .init(customView: unDo)
        self.navigationItem.rightBarButtonItem = .init(customView: redo)
        
        self.navigationItem.leftItemsSupplementBackButton = false
        
        
        $titleLabelText
            .sink { (title) in
                self.titleLabel.setTitle(title, for: .normal)
                self.note?.title = title
            }
            .store(in: &subscribtions)
        
        
        titleLabel.addTarget(self, action: #selector(changeValue), for: .touchDown)
        unDo.addTarget(self, action: #selector(undoAction), for: .touchDown)
        
        
    }
    
    
    @objc func changeValue (){
        titleLabelText += "Z"
    }
    
    @objc func undoAction(){
        context.undo()
        print(note?.title)
    }
    
    @objc func redoAction(){
        
    }
}
