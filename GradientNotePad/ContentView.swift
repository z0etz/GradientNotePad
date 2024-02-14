//
//  ContentView.swift
//  GradientNotePad
//
//  Created by Katja Klahr on 2024-02-14.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        Text("Gradient Notepad")
            .padding()
        NavigationView {
            VStack {
                MainView()
            }
        }
        .padding()
    }
}


struct MainView: View {
    
    @StateObject var viewModel = NoteViewModel()
    
    var body: some View {
        List {
            ForEach(viewModel.notes) { item in
                Text(item.name ?? "")
            }
            .onDelete(perform: { indexSet in
                viewModel.deleteNote(at: indexSet)
            })
            .onTapGesture {
//            Navigate to edit note
            }
        }
        .navigationBarBackButtonHidden(true)
        .padding()
        Spacer()
        NavigationLink(destination: EditView()) {
            Text("Lägg till anteckning")
        }
        .padding()
        .background(.blue)
        .foregroundColor(.white)
        .cornerRadius(20)
    }
}

struct EditView: View {
    
    @StateObject var viewModel = NoteViewModel()
    @State var title = ""
    @State var note = ""
    
    var body: some View {
        TextField("Titel", text: $title)
            .padding()
        TextField("Text", text: $note, axis: .vertical)
            .padding()
        Spacer()
        NavigationLink(destination: MainView()) {
            Text("Spara anteckning")
        }
        .navigationBarBackButtonHidden(true)
        .padding()
        .background(.blue)
        .foregroundColor(.white)
        .cornerRadius(20)
        .disabled(title.isEmpty)
        .simultaneousGesture(TapGesture().onEnded {
            viewModel.addNote(name: title, text: note)
        }
    )}
    
}

#Preview {
    ContentView()
}
