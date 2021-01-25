//
//  DetailView.swift
//  Bookworm
//
//  Created by Zaid Raza on 13/11/2020.
//  Copyright © 2020 Zaid Raza. All rights reserved.
//

import SwiftUI
import CoreData

struct DetailView: View {
    
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode
    
    @State private var showingDeleteAlert = false
    @State private var dismissView = false
    
    let book: Book
    
    var body: some View {
        
        GeometryReader{ geo in
            VStack{
                ZStack{
                    Image((self.book.genre == "" ? "Fantasy" : self.book.genre) ?? "Fantasy")
                        .frame(maxWidth: geo.size.width)
                    
                    Text((self.book.genre == "" ? "FANTASY" : self.book.genre) ?? "FANTASY")
                        .font(.caption)
                        .fontWeight(.black)
                        .padding(8)
                        .foregroundColor(.white)
                        .background(Color.black.opacity(0.75))
                        .clipShape(Capsule())
                        .offset(x: -5, y: -5)
                }
                
                Text(self.book.author ?? "Unknown Author")
                    .font(.title)
                    .foregroundColor(.secondary)
                
                Text(self.book.review ?? "No review")
                    .padding()
                
                Text(self.dateConvert())
                    .font(.title)
                    .foregroundColor(.secondary)
                
                Text(self.timeConvert())
                    .font(.title)
                    .foregroundColor(.secondary)
                
                RatingView(rating: .constant(Int(self.book.rating)))
                    .font(.largeTitle)
                
                Spacer()
            }
        }
        .alert(isPresented: $showingDeleteAlert){
            Alert(title: Text("Delete Book"), message: Text("Are you sure?"), primaryButton: .destructive(Text("Delete")){
                self.deleteBook()
                }, secondaryButton: .cancel())
        }
        .navigationBarTitle(Text(book.title ?? "Unknown Book"), displayMode: .inline)
        .navigationBarItems(trailing: Button(action: {
            self.showingDeleteAlert = true
        }){
            Image(systemName: "trash")
        })
    }
    
    func dateConvert() -> String {
        guard dismissView == false else { return "" }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        let date = dateFormatter.string(from: book.date!)
        return date
    }
    
    func timeConvert() -> String {
        guard dismissView == false else { return "" }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        let time = dateFormatter.string(from: book.date!)
        return time
    }
    
    func deleteBook() {
        moc.delete(book)
        try? self.moc.save()
        self.dismissView = true
        presentationMode.wrappedValue.dismiss()
    }
}
