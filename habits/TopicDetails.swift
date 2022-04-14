//
//  TopicDetails.swift
//  Sustain
//
//  Created by Jocelyn Zhao on 2022-01-30.
//

import SwiftUI

struct TopicDetails: View {
    
    //retrieves stored Habits from Core Data and sorts it by alphabetical order by name
    @FetchRequest(entity: Habit.entity(), sortDescriptors: [NSSortDescriptor(key: "name", ascending: true)]) var habits: FetchedResults<Habit>
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Environment(\.managedObjectContext) var moc
    
    var topic: String
    
    init(section: String) {
        //sorts fetch request on habits by topic name
        _habits = FetchRequest<Habit>(sortDescriptors: [NSSortDescriptor(key: "name", ascending: true)], predicate: NSPredicate(format: "section == %@", section))
        self.topic = section
    }
    
    var backButton : some View {
        Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }) {
            Image(systemName: "list.dash")
                .font(Font.title2.weight(.bold))
                .foregroundColor(.white)
                .shadow(color: Color("LightBlue").opacity(1.0), radius: 10, x: -1, y: -1)
        }
    }
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color.black
                    .edgesIgnoringSafeArea(.all)
                
                ScrollView {
                    ZStack (alignment: .bottomTrailing){
                        Image(topic)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: geo.size.width)
                        
                        Text(topic)
                            .font(.custom("Arial Rounded MT Bold", size: 60))
                            .foregroundColor(.white)
                            .shadow(color: .black, radius: 8, x: -1, y: -1)
                            .padding(.trailing, 5)
                    }
                    .padding([.top, .bottom], 10)
                    
                    //List of each habit
                    ForEach (habits) { habit in
                        HabitDetails(habit: habit, width: geo.size.width)
                    }
                    
                    Spacer(minLength: 30)
                }
                .edgesIgnoringSafeArea(.top)
            }
            .navigationBarBackButtonHidden(true)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                backButton
            }
        }
    }
}

struct TopicDetails_Previews: PreviewProvider {
    static var previews: some View {
        TopicDetails(section: "Waste")
    }
}
