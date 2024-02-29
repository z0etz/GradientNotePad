//
//  NoteViewModel.swift
//  GradientNotePad
//
//  Created by Katja Klahr on 2024-02-14.
//

import SwiftUI
import CoreData

class NoteViewModel: ObservableObject {
    
    @Published var notes: [Note] = []
    var container = Persistence.shared.container
    
    let gradientColors: [[Color]] = [
        [Color.white, Color(red: 0.6235, green: 1, blue: 0.6196)], // Style ID 0
        [Color.white, Color(red: 0.6196, green: 0.9804, blue: 1.0)],   // Style ID 1
        [Color.white, Color(red: 0.6196, green: 0.7647, blue: 1.0)],   // Style ID 2
        [Color.white, Color(red: 0.7529, green: 0.6196, blue: 1.0)], // Style ID 3
        [Color.white, Color(red: 1.0, green: 0.6196, blue: 0.902)]  // Style ID 4
    ]
    
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
    
    func addNote(name: String, text: String, style: Int16) {
        guard !name.isEmpty else {
               print("Title is empty")
               return
           }
        let newTask = Note(context: container.viewContext)
        newTask.name = name
        newTask.text = text
        newTask.id = UUID()
        newTask.style = style
        saveData()
        print("Note added")
    }
    
    func updateNote(_ note: Note, name: String, text: String, style: Int16) {
           guard !name.isEmpty else {
               print("Title is empty")
               return
           }
           note.name = name
           note.text = text
           note.style = style
           saveData()
           print("Note updated")
       }
    
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
    
    func gradientColorsForStyle(_ style: Int16) -> [Color] {
            return gradientColors[Int(style)] // Default gradient colors
    }
    
}

