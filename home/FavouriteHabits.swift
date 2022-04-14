//
//  FavouriteHabits.swift
//  Sustain
//
//  Created by Jocelyn Zhao on 2022-01-30.
//

import SwiftUI
import CoreData

struct FavouriteHabits: View {
    @FetchRequest (sortDescriptors: []) var data: FetchedResults<CollectedData>
    @Environment (\.managedObjectContext) var moc
    
    @State private var moreDetails: Bool = false
    @State private var heart: Bool = true
    
    //variables passed in from the parent view
    var habit: Habit
    var width: Double
    var index: Int
    
    //button for favourites
    var heartButton: some View {
        Button {
            self.habit.special.toggle()
            
            withAnimation {
                self.heart.toggle()
            }
            
            do {
                try self.moc.save()
            } catch {
                print ("Oh no! You messed up :(")
            }
        } label: {
            Image(systemName: heart ? "heart.fill" : "heart")
                .font(.headline)
                .foregroundColor(Color(UIColor.systemTeal))
                .padding([.trailing, .bottom], 5)
        }
    }
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                //allows the user to "unlike" a habit directly from the favourite habits screen
                heartButton
                    .onAppear {
                        self.heart = self.habit.special
                    }
            }
            
            //habit name
            Text(habit.name ?? "Unknown name")
                .font(.custom("Trebuchet MS", size: 16))
            
            Spacer()
            
            //Add points for the habit
            HStack {
                Text("Points: \(habit.points)")
                    .font(.custom("Trebuchet MS", size: 16))
                    .fontWeight(.bold)
                
                Spacer()
            
                Button {
                    //add points
                    let pointsAdded = Double(habit.points)/Double(data[0].overallGoals)
                    self.data[0].progress += pointsAdded
                    
                    try? self.moc.save()
                } label: {
                    HStack {
                        Image(systemName: "plus")
                            .font(.title2)
                            .padding(5)
                            .background(index % 2 == 0 ? Color("DarkYellow") : Color("DarkBlue"))
                            .cornerRadius(10)
                    }
                }
                .buttonStyle(.plain)
            }
            .frame(width: width)
        }
        .frame(width: (moreDetails ? width * 2 : width + 20), height: width + 10)
        .padding(10)
        //allows the backgrounds of the habits to have alternating colours
        .background(index % 2 == 0 ? Color("LightYellow") : Color("LightBlue"))
        .cornerRadius(20)
        .padding(.bottom)
        //on tap, if the text cannot fit into the small box, the user can tap the favourite habits and it will expand to accomodate the long title
        .onTapGesture {
            withAnimation {
                self.moreDetails.toggle()
            }
        }
    }
}

/*struct FavouriteHabits_Previews: PreviewProvider {
    static var previews: some View {
        FavouriteHabits()
    }
}
*/
