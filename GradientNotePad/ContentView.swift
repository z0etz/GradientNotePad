//
//  ContentView.swift
//  GradientNotePad
//
//  Created by Katja Klahr on 2024-02-14.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var viewModel = NoteViewModel()
    
    var body: some View {
            VStack{
                Text("Gradient Notepad")
                    .bold()
                    .padding(.top)
                    .font(.title)
                    .foregroundColor(.gray)
                NavigationView {
                    VStack {
                        MainView(viewModel: viewModel)
                    }
                }
            }
            .background(LinearGradient(gradient: Gradient(colors: [.white, .gray]), startPoint: .top, endPoint: .bottom))
    }
                        
}


struct MainView: View {
    
    @StateObject var viewModel = NoteViewModel()
    var buttonColor = Color(red: 0.6196, green: 0.7647, blue: 1.0)
    
    var body: some View {
        VStack {
        List {
            ForEach(viewModel.notes) { item in
                NavigationLink(destination: EditView(viewModel: viewModel, note: item)) {
                    Text(item.name ?? "")
                }
                .padding()
                .background(
                    LinearGradient(gradient: Gradient(colors: viewModel.gradientColorsForStyle(item.style)), startPoint: .topLeading, endPoint: .bottomTrailing)
                        .cornerRadius(10)
                        .foregroundColor(.white))
            }
            .onDelete(perform: { indexSet in
                viewModel.deleteNote(at: indexSet)
            })
        }
        
        Spacer()
        NavigationLink(destination: EditView(viewModel: viewModel)) {
            Text("Lägg till anteckning")
        }
        .padding()
        .background(buttonColor)
        .foregroundColor(.white)
        .cornerRadius(20)
        .bold()
        .navigationBarBackButtonHidden(true)
    }
    }
}


struct EditView: View {
    
    @ObservedObject var viewModel: NoteViewModel
    @State var title = ""
    @State var text = ""
    @State var selectedStyleId: Int16
    var buttonColor = Color(red: 0.6196, green: 0.7647, blue: 1.0)
    var note: Note?
    
    init(viewModel: NoteViewModel, note: Note? = nil) {
        self.viewModel = viewModel
        self._title = State(initialValue: note?.name ?? "") // Initialize title with note's name if not nil
        self._text = State(initialValue: note?.text ?? "") // Initialize text with note's text if not nil
        self._selectedStyleId = State(initialValue: note?.style ?? 0)
        self.note = note
        print(note ?? "note is nil")
    }
    
    var body: some View {
        TextField("Titel", text: $title)
            .padding()
        TextField("Text", text: $text, axis: .vertical)
            .padding()
        Spacer()
        
        // Create buttons for each style ID
        HStack {
            ForEach(viewModel.gradientColors.indices, id: \.self) { index in
                Button(action: {
                    selectedStyleId = Int16(index)
                }) {
                    Text("    ")
                        .padding()
                        .background(
                            LinearGradient(gradient: Gradient(colors: viewModel.gradientColors[index]), startPoint: .topLeading, endPoint: .bottomTrailing)
                                .cornerRadius(10)
                                .foregroundColor(.white)
                        )
                        .overlay(
                                                    RoundedRectangle(cornerRadius: 10)
                                                        .stroke(selectedStyleId == Int16(index) ? Color.black : Color.clear, lineWidth: 2) // Add border if selected
                                                )
                }
            }
        }
        .padding()
        
        HStack {
            NavigationLink(destination: MainView(viewModel: viewModel)) {
                Text("Avbryt")
            }
            .padding()
            .background(buttonColor)
            .foregroundColor(.white)
            .cornerRadius(20)
            .bold()
            NavigationLink(destination: MainView()) {
                Text(" Spara ")
            }
            .navigationBarBackButtonHidden(true)
            .padding()
            .background(buttonColor)
            .foregroundColor(.white)
            .cornerRadius(20)
            .disabled(title.isEmpty)
            .bold()
            .simultaneousGesture(TapGesture().onEnded {
                if let newNote = note {
                    viewModel.updateNote(newNote, name: title, text: text, style: selectedStyleId) // Update the existing note
                    print("update note")
                } else {
                    viewModel.addNote(name: title, text: text, style: selectedStyleId) // Otherwise, add a new note
                    print("add note")
                }
            }
            )}
    }
}

#Preview {
    ContentView()
}
