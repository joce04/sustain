//
//  ContentView.swift
//  Sustain
//
//  Created by Jocelyn Zhao on 2022-01-20.
//

import SwiftUI
import CoreData

//A struct that modifiees the Tab Button style
struct TabButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .opacity(configuration.isPressed ? 0.9 : 1)
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
    }
}

//directs the communication between the Login view (the view that the user sees upon the app launch) and the MainView (which houses the rest
//of the app
struct ContentView: View {
    @State private var push = false
    
    var body: some View {
        if push {
            MainView()
                .transition(.iris)
                //.transition(.asymmetric(insertion: .move(edge: .leading), removal: .move(edge: .leading)))
        } else {
            LoginView(push: $push)
        }
    }
}

//Custom Tab View
struct CustomTabView: View {
    //two binding variables that are shared with MainView as communication
    @Binding var selectedTab: Tab
    @Binding  var showingSheet: Bool
    
    var body: some View {
        ZStack (alignment: .top) {
            Color.black
                .edgesIgnoringSafeArea(.bottom)
            
            Rectangle()
                .frame(height: 5)
                .foregroundColor(.white)
            
            
            HStack {
                Spacer()
                
                //HOME BUTTON: clicking this will open the main home screen, or the most recent child home screen the user was on
                Button (action: {
                    selectedTab = .first
                }, label: {
                    VStack {
                        Image(systemName: "house")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25, height: 25)
                        Text("Home")
                            .foregroundColor(.white)
                            .font(.caption2)
                    }
                    .foregroundColor(selectedTab == .first ? Color("DarkYellow") : .white)
                })
                
                Spacer()
                
                //Adding new habits button; clicking this opens the AddHabit sheet and allows user to create their own habit
                Button  {
                    self.showingSheet.toggle()
                } label: {
                    ZStack {
                        Circle()
                            .foregroundColor(.white)
                            .frame(width: 80, height: 80)
                            .shadow(radius: 2)
                        Circle()
                            .foregroundColor(.black)
                            .frame(width: 70, height: 70)
                        
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .foregroundColor(Color("DarkBlue"))
                            .frame(width: 72, height: 72)
                    }
                    .offset(y: -22)
                }
                .buttonStyle(TabButtonStyle())
                
                Spacer()
                
                //HABIT BUTTON: clicking this will open the main habit screen, or the most recent childhabit screen the user was on
                Button (action: {
                    selectedTab = .second
                }, label: {
                    VStack {
                        Image(systemName: "link")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25, height: 25)
                        Text("Habits")
                            .foregroundColor(.white)
                            .font(.caption2)
                    }
                    .foregroundColor(selectedTab == .second ? Color("DarkYellow") : .white)
                })
                
                Spacer()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
