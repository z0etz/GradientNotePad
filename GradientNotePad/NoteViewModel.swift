//
//  NoteViewModel.swift
//  GradientNotePad
//
//  Created by Katja Klahr on 2024-02-14.
//

import Foundation
import CoreData

class NoteViewModel: ObservableObject {
    
    @Published var notes: [Note] = []
    
    var container = Persistence.shared.container
    
    init() {
        self.fetchNotes()
    }
    
    func fetchNotes() {
        let request = NSFetchRequest<Note>(entityName: "Note")
        
        do {
            notes = try container.viewContext.fetch(request)
        } catch let error {
            print("Error fetching: \(error)")
        }
    }
    
    func addNote(name: String, text: String) {
        guard !name.isEmpty else {
               print("Title is empty")
               return
           }
        let newTask = Note(context: container.viewContext)
        newTask.name = name
        newTask.text = text
        newTask.id = UUID()
        newTask.style = Int16(0)
        saveData()
        print("Note added")
    }
    
//    func updateTask(task: Task, newName: String) {
//        if newName != "" {
//            task.name = newName
//            do {
//                try container.viewContext.save()
//                print("task updated")
//            } catch let error {
//                print("Error saving task: \(error)")
//            }
//            saveData()
//        }
//    }
    
    func deleteNote(at indices: IndexSet) {
            indices.forEach { index in
                let noteToDelete = notes[index]
                container.viewContext.delete(noteToDelete)
            }
            saveData()
        }
    
    func saveData() {
        do {
            try container.viewContext.save()
        } catch let error {
            print("Error saving data \(error)")
        }
        fetchNotes()
    }
    
}

