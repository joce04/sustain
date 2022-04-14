//
//  HomeView.swift
//  Sustain
//
//  Created by Jocelyn Zhao on 2022-01-21.
//

import SwiftUI
import UIKit
import CoreData

struct HomeView: View {
    @State private var goalCompleted = false
    
    @Binding var showingGoals: Bool
    
    @Environment(\.managedObjectContext) var moc
    
    //These fetch data from Core Data and store it in a variable to be modified in this struct.
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(key: "name", ascending: true)], predicate: NSPredicate(format: "special == true")) var favouriteHabits: FetchedResults<Habit>
    
    @FetchRequest(sortDescriptors: []) var data: FetchedResults<CollectedData>
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(key: "name", ascending: true)]) var allHabits: FetchedResults<Habit>
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color(.black)
                    .edgesIgnoringSafeArea(.all)
                
                //holds main components
                ScrollView(.vertical) {
                    VStack {
                        //HOME title
                        Text("HOME")
                            .frame(maxWidth: geometry.size.width - 20, maxHeight: 90, alignment: .bottom)
                            .font(.custom("Arial Rounded MT Bold", size: 60))
                            .foregroundColor(.white)
                            .padding(.top, 30)
                        
                        //line separater
                        Rectangle()
                            .opacity(0.0)
                            .frame(width: geometry.size.width * 0.7, height: 5)
                            .darkYellow()
                            .padding(.bottom, 5)
                        
                        //progress circle
                        ZStack {
                            //is the SET OVERALL GOAL box
                            if (data[0].needGoals == true) {
                                Button {
                                    self.showingGoals = true
                                } label: {
                                    OverallGoal()
                                        .frame(width: geometry.size.width * 0.9, height: geometry.size.width * 0.8)
                                        .background(Color("LightBlue"))
                                        .cornerRadius(20)
                                        .padding([.top, .bottom])
                                }
                            } else {
                                //progress circle and goal start date
                                CircularProgressBar(width: geometry.size.width/1.7, height: geometry.size.width/1.7)
                                    .frame(width: geometry.size.width * 0.9, height: geometry.size.width * 0.7)
                                    .padding([.top, .bottom])
                                    .padding(.bottom)
                            }
                        }
                        .animation(.default)
                        
                        //This the the spotlight habit
                        SpotlightHabit(habit: allHabits[Int(data[0].spotlightHabit)], width: geometry.size.width)
                        
                        //list of favourite habits
                        Text("Favourite Habits")
                            .font(.custom("Arial Rounded MT Bold", size: 25))
                            .foregroundColor(.white)
                            .frame(width: geometry.size.width * 0.9, alignment: .leading)
                        
                        //This holds a horizontal scroll view of all the favourited habits. If there are no favourite habits, this area displays the message "Add some favourites in the Habits tab.
                        ScrollView (.horizontal) {
                            HStack{
                                if favouriteHabits.count == 0 {
                                    Text("Add some favourites in the Habits tab")
                                        .foregroundColor(.gray)
                                        .fontWeight(.bold)
                                    
                                } else {
                                    ForEach(0..<favouriteHabits.count, id: \.self) { index in
                                        FavouriteHabits(habit: favouriteHabits[index], width: geometry.size.width * 0.3, index: index)
                                    }
                                }
                            }
                        }
                        .frame(width: geometry.size.width * 0.9)
                        
                        Spacer (minLength: 25.0)
                    }
                }
            }
            .onAppear {
                checkDate(currentDate: Date())
            }
        }
    }
    
    //this function runs to determine if a full day has passed and if the spotlight habits needs to be refreshed or not.
    //Upon determining the a disrepancy, the current date replaces the previous date in the Data entity.
    func checkDate(currentDate: Date) {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        let firstDate = formatter.string(from: currentDate)
        let secondDate = formatter.string(from: data[0].currentDate ?? Date())
        
        if firstDate != secondDate {
            data[0].spotlightHabit = Int16(Int.random(in: 0..<allHabits.count))
            self.data[0].currentDate = currentDate
            do {
                try self.moc.save()
            } catch {
                print ("the startdate couldn't save for some reason")
            }
        }
    }
}

//this view is shown if there is no goal set yet
struct OverallGoal: View {
    var body: some View {
        Text("Set an overall goal")
            .font(.custom("Arial Rounded MT Bold", size: 20))
            .foregroundColor(.black)
    }
}

/*struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(showingGoals: .constant(false))
    }
}*/



