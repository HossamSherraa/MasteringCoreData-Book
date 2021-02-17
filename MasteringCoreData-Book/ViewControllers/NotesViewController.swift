//
//  ViewController.swift
//  MasteringCoreData-Book
//
//  Created by Hossam on 15/02/2021.
//

import UIKit
import Combine
class NotesViewController: UIViewController {

    let addNotesPublisher = PassthroughSubject<Void , Never>()
    var subscribtions = Set<AnyCancellable>()
    var notes : [Note] = []
   lazy var tableViewNotes : UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
    return tableView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        navigationItem.leftBarButtonItem = .init(image: .add, style: .done, target: self, action: #selector(onAddNote))
        
        tableViewNotes.register(NoteCellView.self, forCellReuseIdentifier: "NoteCell")
        view.addSubview(tableViewNotes)
        NSLayoutConstraint.activate([
            tableViewNotes.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableViewNotes.topAnchor.constraint(equalTo: view.topAnchor),
            tableViewNotes.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableViewNotes.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        
        ])
        
        addNotesPublisher
            .tryCompactMap { _ -> [Note]? in
                let context = CoreDataManager.context
                return try context.fetch(Note.fetchRequest()) as? [Note]
            }
            .sink(receiveCompletion: {_ in}) { notes in
                self.notes = []
                self.notes = notes
                self.tableViewNotes.reloadData()
            }
            .store(in: &subscribtions)
        
        addNotesPublisher.send()
            
    }


    //Actions
    
    @objc func onAddNote (){
        let noteViewController = AddNoteViewController()
        noteViewController.addNotesPublisher = self.addNotesPublisher
        self.navigationController?.pushViewController(noteViewController, animated: true)
    }
    
    
    
    

}

//Delegate
extension NotesViewController : UITableViewDelegate{
    
}
//DATASource
extension NotesViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell") as! NoteCellView
        let note = notes[indexPath.row]
        let title = note.title ?? ""
        let date = note.createdAt?.description ?? ""
        let content = note.contents ?? ""
        cell.configCellWith(title: title, date: date, subtitle: "some subTitle", content: content)
        return cell
    }
    
    
}
