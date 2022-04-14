//
//  AddHabit.swift
//  Sustain
//
//  Created by Jocelyn Zhao on 2022-01-20.
//

import SwiftUI
import CoreData

//This is a sheet that allows the user to create their own sustainable habit.
struct AddHabit: View {
    @Environment(\.managedObjectContext) var moc
    @Binding var addHabit: Bool
    
    @State private var name = ""
    @State private var section = ""
    @State private var information = ""
    @State private var points = 1
    
    //this is the sections that the user can categorize their new habit into
    let sections = ["Waste", "Home", "Water", "Fashion", "Habitats", "Learning", "Transport", "Food", "Activism"]
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                
                //allows user to exit the screen in case they do not want to add a new habit
                Button {
                    self.addHabit = false
                } label: {
                    Text("X")
                        .font(.custom("Arial Rounded MT Bold", size: 25))
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .padding(.trailing, 5)
                }
            }

            
            //ADD HABIT title
            Text("ADD NEW HABIT")
                .font(.custom("Arial Rounded MT Bold", size: 30))
                .foregroundColor(.black)
            
            //line separater
            Rectangle()
                .opacity(0.0)
                .frame(width: UIScreen.main.bounds.width - 50, height: 3)
                .darkYellow()
                .padding(.bottom, 5)
            
            //Collects an input of the habit title from the user
            TextField ("Habit Title", text: $name)
            
            //Collects an input of a description or details of the habit from the user
            TextField("Description", text: $information)
            
            //allows user to select which category their new habits belongs to
            Picker("Section", selection: $section) {
                ForEach(sections, id: \.self) {
                    Text($0)
                }
            }.pickerStyle(WheelPickerStyle())
            
            //Allows user to determine how many points their habit is worth.
            Stepper("Points: \(points)", value: $points, in: 1...15, step: 1)
            
            //Saves the new habit into the Core Data entity. User can now see their habit in the respective section.
            Button {
                let newHabit = Habit(context: self.moc)
                newHabit.id = UUID()
                newHabit.name = self.name
                newHabit.section = self.section
                newHabit.points = Int16(self.points)
                newHabit.information = self.information
                
                try? self.moc.save()
                
                self.addHabit.toggle()
                
            } label: {
                Text("ADD HABIT")
                    .fontWeight(.bold)
                    .font(.custom("Trebuchet MS", size: 18))
                    .padding()
                    .background(Color("DarkYellow"))
                    .cornerRadius(25)
                    .foregroundColor(.black)
                    .padding(7)
                    .overlay(
                    RoundedRectangle(cornerRadius: 33)
                    .stroke(Color("LightYellow"), lineWidth: 4)
                    )
            }
        }
        .padding(.bottom, ((UIApplication.shared.windows.last?.safeAreaInsets.bottom ?? 10) + 10))
        .padding(.horizontal)
        .padding(.top, 20)
        .background(Color.white)
        .cornerRadius(25)
        .edgesIgnoringSafeArea(.bottom)
    }
}

/*struct AddHabit_Previews: PreviewProvider {
    static var previews: some View {
        AddHabit(addHabit: .constant(false))
    }
}*/
