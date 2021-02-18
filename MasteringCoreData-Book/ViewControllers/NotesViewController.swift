//
//  ViewController.swift
//  MasteringCoreData-Book
//
//  Created by Hossam on 15/02/2021.
//

import UIKit
import Combine
import CoreData
let context = CoreDataManager.context
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
    lazy var  fetchedResultController  : NSFetchedResultsController<Note>  =  {
        let request : NSFetchRequest<Note> = Note.fetchRequest()
        request.sortDescriptors = [.init(key: "title", ascending: true)]
        let controller = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context , sectionNameKeyPath: nil, cacheName: nil)
        
        return controller
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        navigationItem.leftBarButtonItem = .init(image: .add, style: .done, target: self, action: #selector(onAddNote))
        
        navigationItem.rightBarButtonItems = [self.editButtonItem , .init(image: UIImage.init(systemName: "pencil"), style: UIBarButtonItem.Style.done, target: self, action: #selector(onEdit))]
        
        tableViewNotes.register(NoteCellView.self, forCellReuseIdentifier: "NoteCell")
        view.addSubview(tableViewNotes)
        NSLayoutConstraint.activate([
            tableViewNotes.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableViewNotes.topAnchor.constraint(equalTo: view.topAnchor),
            tableViewNotes.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableViewNotes.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        
        ])
        
       try?  fetchedResultController.performFetch()
        
        fetchedResultController.delegate = self
       
            
    }

    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        tableViewNotes.setEditing(editing, animated: animated)
    }
    


    //Actions
    
    @objc func onAddNote (){
        let noteViewController = AddNoteViewController()
        noteViewController.addNotesPublisher = self.addNotesPublisher
        self.navigationController?.pushViewController(noteViewController, animated: true)
        
        
//        let r = UndoRedoViewController()
//        r.note = notes.first
//        self.navigationController?.pushViewController(r, animated: true)
    }
    
    @objc func onEdit(){
        let object = fetchedResultController.object(at: .init(row: 0, section: 0))
        object.title = "Love Me BRRORORORo"
        try? context.save()
        
        
    }
    
    
    
    

}

//Delegate
extension NotesViewController : UITableViewDelegate{
    
}
//DATASource
extension NotesViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        fetchedResultController.fetchedObjects?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell") as! NoteCellView
        let note = fetchedResultController.object(at: indexPath)
        let title = note.title ?? ""
        let date = note.createdAt?.description ?? ""
        let content = note.contents ?? ""
        cell.configCellWith(title: title, date: date, subtitle: "some subTitle", content: content)
        return cell
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            let object = fetchedResultController.object(at: indexPath)
            context.delete(object)
            try? context.save()
        default:
            break
        }
    }

    
}

extension NotesViewController : NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
    }
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert: tableViewNotes.insertRows(at: [newIndexPath!], with: .bottom)
        case .delete : tableViewNotes.deleteRows(at: [indexPath!], with: .left)
        case .update : tableViewNotes.reloadRows(at: [indexPath!], with: .automatic)
        default:
            break
        }
    }
    
}
