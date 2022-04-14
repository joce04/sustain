//
//  SpotlightHabit.swift
//  Sustain
//
//  Created by Jocelyn Zhao on 2022-03-16.
//

import SwiftUI

struct SpotlightHabit: View {
    @FetchRequest (sortDescriptors: []) var data: FetchedResults<CollectedData>
    @Environment (\.managedObjectContext) var moc
    
    var habit: Habit
    var width: CGFloat
    
    var body: some View {
        VStack (alignment: .leading) {
            Text("Spotlight Habit")
                .font(.custom("Arial Rounded MT Bold", size: 25))
                .foregroundColor(.white)
            
            VStack (alignment: .leading){
                Text(habit.name ?? "Unknown name")
                    .font(.custom("Trebuchet MS", size: 17))
                    .fontWeight(.bold)
                    .frame(width: width * 0.8, alignment: .center)
                    .darkYellow()
                
                Text(habit.information ?? "No further information provided.")
                    .font(.custom("Trebuchet MS", size: 15))
                
                HStack {
                    Text("YAY! Double points: \(habit.points * 2) pts")
                        .font(.custom("Trebuchet MS", size: 16))
                        .fontWeight(.bold)
                        .padding(.trailing, 5)
                    
                    Button {
                        
                        let pointsAdded = Double(habit.points * 2)/Double(data[0].overallGoals)
                        self.data[0].progress += pointsAdded
                        
                        try? self.moc.save()
                    } label: {
                        HStack {
                            Image(systemName: "plus")
                                .font(.title)
                                .darkYellow()
                        }
                    }
                    .buttonStyle(.plain)
                }
                .frame(width: width * 0.8, alignment: .trailing)
            }
            .padding([.leading, .trailing])
            .frame(width: width * 0.9)
            .background()
        }
    }
}
/*
struct SpotlightHabit_Previews: PreviewProvider {
    static var previews: some View {
        SpotlightHabit(habit: //, width: //)
    }
}*/
