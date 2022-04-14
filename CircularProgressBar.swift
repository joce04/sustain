//
//  CircularProgressBar.swift
//  Sustain
//
//  Created by Jocelyn Zhao on 2021-09-11.
//

import SwiftUI

struct CircularProgressBar: View {
    @Environment(\.managedObjectContext) var moc
    
    @FetchRequest (sortDescriptors: []) var allData: FetchedResults <CollectedData>
    
    @State private var alert = false
    
    var width: CGFloat
    
    var height: CGFloat
    
    var body: some View {
            ZStack {
                //bottom circle
                Circle()
                    .stroke(style: StrokeStyle(lineWidth: 30, lineCap: .round))
                    .foregroundColor(Color("DarkBlue").opacity(0.5))
                    .frame(width: width, height: height)
                
                //how much it's loaded
                Circle()
                    .trim(from: 0.0, to: allData[0].progress)
                    .stroke(style: StrokeStyle(lineWidth: 30, lineCap: .round))
                    .foregroundColor(Color("DarkBlue"))
                    .frame(width: width, height: height)
                    .rotationEffect(Angle(degrees: -90))
                    .animation(.linear)
                    .onChange(of: allData[0].progress) { _ in
                        checkGoalComplete()
                    }
                    .onAppear {
                        checkGoalComplete()
                    }
                
                //text showing percentage
                VStack {
                    Text("Start Date")
                        .foregroundColor(Color.gray)
                    Text("\(allData[0].startDate ?? Date(), style: .date)")
                        .fontWeight(.bold)
                        .padding(.bottom, 5)
                        .font(.custom("HelveticaNeue", size: 20.0))

                    
                    Text("Progress")
                        .foregroundColor(Color.gray)
                    
                    //Progress so far in percentage
                    Text("\(Int(allData[0].progress * 100))%")
                        .fontWeight(.bold)
                        .font(.custom("HelveticaNeue", size: 25.0))
                    
                    //displays how many points user wants to reach
                    Text("Goal")
                        .foregroundColor(Color.gray)
                    Text("\(allData[0].overallGoals) pts")
                        .fontWeight(.bold)
                        .font(.custom("HelveticaNeue", size: 20.0))
                }
                .foregroundColor(.white)
            }
            .frame(width: width, height: height)
        
        //an alert for when the goal is completed
            .alert(isPresented: $alert, content: {
                Alert(title: Text("OH MY GOODNESS"), message: Text("This amazing person just completed a HUGE goal of \(allData[0].overallGoals) points! You deserve to celebrate your hard work and contribution to the climate crisis. Future updates will start providing rewards, but for now, go treat yourself!"), dismissButton: .default(Text("Ya, I'm awesome")){
                    allData[0].needGoals = true
                    allData[0].progress = 0
                    allData[0].overallGoals = 1
                    
                    try? self.moc.save()
                })
            })
    }
    
    func checkGoalComplete() {
        if allData[0].progress >= 1 && allData[0].needGoals == false {
            self.alert.toggle()
        }
    }
}



//struct CircularProgressBar_Previews: PreviewProvider {
  //  static let example = collectedData()
    //
    //static var previews: some View {
    //    CircularProgressBar(width: 200, height: 200)
    //        .environmentObject(example)
    //}
//}

