//
//  MainView.swift
//  Sustain
//
//  Created by Jocelyn Zhao on 2022-01-21.
//

import SwiftUI
import CoreData

//A main view that houses a custom tab view and directs the communication between screens through the tab view
struct MainView: View {
    @State private var selectedTab: Tab = .first
    
    @State private var showingGoals: Bool = false
    
    @State private var addHabit: Bool = false

    var body: some View {
        ZStack {
            //Houses the two main screens: Habits and Home: in a custom tab view.
            VStack {
                switch selectedTab {
                case .first:
                    HomeView(showingGoals: $showingGoals)
                case .second:
                    HabitsView()
                }
                CustomTabView(selectedTab: $selectedTab, showingSheet: $addHabit)
                    .frame(height: 50)
            }
            
            VStack {
                Spacer()
                //Keeps the two sheets hidden at the bottom of the screen
                ZStack (alignment: .bottom) {
                    GoalSetting(showingGoals: $showingGoals)
                        .offset(y: self.showingGoals ? 0.0 : UIScreen.main.bounds.height)


                    AddHabit(addHabit: $addHabit)
                        .offset(y: self.addHabit ? 0.0 : UIScreen.main.bounds.height)
                }
            }
            .background(((self.showingGoals || self.addHabit) ? Color.black.opacity(0.4) : Color.clear)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    self.showingGoals = false
                    self.addHabit = false
                })
            .edgesIgnoringSafeArea(.bottom)
            .animation(.default)
        }
    }
}

enum Tab {
    case first
    case second
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
