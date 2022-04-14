//
//  GoalSetting.swift
//  Sustain
//
//  Created by Jocelyn Zhao on 2022-01-21.
//

import SwiftUI

//Opens this sheet for the user to set a goal of points they want to reach
struct GoalSetting: View {
    //connects with parent view
    @Binding var showingGoals: Bool
    
    //retrieves data from Core Data Data entity to modify with goal
    @FetchRequest(sortDescriptors: []) var data: FetchedResults<CollectedData>
    @Environment (\.managedObjectContext) var moc
    
    @State private var tempOverallGoal = 1.0
    
    
    var body: some View {
        VStack (spacing: 15) {
            HStack {
                Spacer()
                
                //Allows user to dismiss the screen
                Button {
                    self.showingGoals = false
                } label: {
                    Text("X")
                        .font(.custom("Arial Rounded MT Bold", size: 25))
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .padding(.trailing, 5)
                }
            }
            
            //ADD NEW GOAL title
            Text("ADD NEW GOAL")
                .font(.custom("Arial Rounded MT Bold", size: 30))
                .foregroundColor(.black)
            
            //line separater
            Rectangle()
                .opacity(0.0)
                .frame(width: UIScreen.main.bounds.width - 50, height: 3)
                .padding(5)
                .background(Color("DarkBlue"))
                .cornerRadius(10)
                .padding(.bottom, 5)
            
            //User uses this slider to set their goals
            Slider(value: $tempOverallGoal, in: 1...200)
            
            //Displays the users goal choice,
            Text("TOTAL POINTS GOAL: \(String(format: "%1.0f", tempOverallGoal))")
                .font(.custom("Trebuchet MS", size: 18))
            
            //Saves the goal into the Core Data data entity.
            Button {
                self.showingGoals = false
                self.data[0].needGoals = false
                self.data[0].startDate = Date()
                self.data[0].overallGoals = Int16(tempOverallGoal)
                self.data[0].progress = 0
                
                try? self.moc.save()
            } label: {
                Text("LET'S BEGIN")
                    .fontWeight(.bold)
                    .font(.custom("Trebuchet MS", size: 18))
                    .padding()
                    .background(Color("DarkBlue"))
                    .cornerRadius(25)
                    .foregroundColor(.black)
                    .padding(7)
                    .overlay(
                    RoundedRectangle(cornerRadius: 33)
                    .stroke(Color("LightBlue"), lineWidth: 4)
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

/*struct GoalSetting_Previews: PreviewProvider {
    static var previews: some View {
        GoalSetting(showingGoals: .constant(true))
    }
}
*/
