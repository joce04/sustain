//
//  HabitDetails.swift
//  Sustain
//
//  Created by Jocelyn Zhao on 2022-01-30.
//

import SwiftUI
import CoreData

struct HabitDetails: View {
    @Environment(\.managedObjectContext) var moc
    
    //variables passed in from parent view
    var habit: Habit
    var width: CGFloat
    
    //holds the core data entity of DATA
    @FetchRequest(entity: CollectedData.entity(), sortDescriptors: []) var data: FetchedResults<CollectedData>
    
    @State private var showingInformation: Bool = false
    @State private var heart: Bool = false
    
    
    var heartButton: some View {
        Button {
            self.habit.special.toggle()
            self.heart.toggle()
            
            do {
                try self.moc.save()
            } catch {
                print ("Oh no! You messed up :(")
            }
        } label: {
            Image(systemName: heart ? "heart.fill" : "heart")
                .font(.title)
                .foregroundColor(Color(UIColor.systemTeal))
                .padding(.leading, 10)
        }
    }

    var body: some View {
        VStack {
            //text of the title
            Text(habit.name ?? "Unknown name")
                .font(.custom("Trebuchet MS", size: 17))
                .fontWeight(.bold)
                .foregroundColor(showingInformation ? Color(.white) : Color(.black))
                .padding(5)
                .frame(width: width * 0.9, alignment: .center)
                .padding([.top, .bottom], 15)
                .padding(5)
                .background(showingInformation ? Color("DarkGreen") : Color("DarkYellow"))
                .cornerRadius(10)
                .overlay(RoundedRectangle(cornerRadius: 10).strokeBorder(lineWidth: 3).foregroundColor(.black))
                //button to click to show more information
                .onTapGesture {
                    withAnimation (.easeOut(duration: 0.3)){
                        self.showingInformation.toggle()
                    }
                }

            
            //description to show if information is true
            if showingInformation {
                //description
                Text(habit.information ?? "No further description provided.")
                    .font(.custom("Trebuchet MS", size: 15))
                    .padding(7)
                
                
                HStack {
                    //heart/favourite button is here
                    heartButton
                        .onAppear {
                            self.heart = self.habit.special
                        }
                    
                    Spacer()
                    
                    //add points here
                    Text("Points: \(habit.points)")
                    
                    Button {
                        let pointsAdded = Double(habit.points)/Double(data[0].overallGoals)
                        self.data[0].progress += pointsAdded
                        
                        try? self.moc.save()
                    } label: {
                        HStack {
                            Image(systemName: "plus")
                                .font(.title)
                                .foregroundColor(.black)
                                .darkYellow()
                        }
                    }
                }
                .padding([.leading, .trailing])
            }
                
        }
        .frame(width: width * 0.85)
        .padding(.bottom)
        .background(Color("LightYellow"))
        .padding([.leading, .trailing, .bottom], 8)
    }
}

/*struct HabitDetails_Previews: PreviewProvider {
    static var previews: some View {
        HabitDetails()
    }
}*/
