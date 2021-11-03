//
//  ContentView.swift
//  CoreDataBootcamp
//
//  Created by Luka Vujnovac on 02.11.2021..
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var textFieldText: String = ""
    
    @FetchRequest(entity: FruitEntity.entity(),
                  sortDescriptors: [NSSortDescriptor(keyPath: \FruitEntity.name, ascending: true)]) 
    var fruits: FetchedResults<FruitEntity>
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                
                TextField("Add fruit here ...", text: $textFieldText)
                    .font(.headline)
                    .padding(.leading)
                    .frame(maxWidth: .infinity)
                    .frame(height: 55)
                    .background(Color("lightGray"))
                    .cornerRadius(10)
                    .padding(.horizontal)
                
                Button { 
                    addItem()
                    textFieldText = ""
                } label: { 
                    Text("Submit")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 55)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                
                List {
                    ForEach(fruits) { fruit in
                        Text(fruit.name ?? "")
                            .onTapGesture {
                                updateItem(fruit: fruit)
                            }
                    }
                    .onDelete(perform: deleteItems)
                }
                .listStyle(.plain)
            }
            .navigationTitle("Fruits")
        }
    }
    
    private func addItem() {
        withAnimation {
            
            let newFruit = FruitEntity(context: viewContext)
            newFruit.name = textFieldText
//            let newItem = Item(context: viewContext)
//            newItem.timestamp = Date()
            
            saveItems()
        }
    }
    
    private func updateItem(fruit: FruitEntity) {
        withAnimation {
            let currentName = fruit.name ?? ""
            let newName = currentName + "!"
            fruit.name = newName
            
            saveItems()
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            guard let index = offsets.first else {return}
            let fruitEntity = fruits[index]
            viewContext.delete(fruitEntity)
            
            saveItems()
        }
    }
    
    private func saveItems() {
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
