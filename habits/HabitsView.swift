//
//  HabitsView.swift
//  Sustain
//
//  Created by Jocelyn Zhao on 2022-01-21.
//

import SwiftUI
import UIKit

struct HabitsView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: []) var habits: FetchedResults<Habit>
    @FetchRequest(sortDescriptors: [NSSortDescriptor(key: "name", ascending: true)]) var topics: FetchedResults<Topic>
    
    init() {
        //UINavigationBar.appearance().isUserInteractionEnabled = false
        UINavigationBar.appearance().backgroundColor = .clear
        UINavigationBar.appearance().barTintColor = .clear
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().tintColor = .clear
    }
    
    
    var body: some View {
        GeometryReader { geometry in
            NavigationView {
                ZStack {
                    //background colour
                    Color(.black)
                        .edgesIgnoringSafeArea(.all)
                    
                    //holds main components
                    ScrollView(.vertical) {
                        VStack {
                            //HABITS title
                            Text("HABITS")
                                .frame(maxWidth: geometry.size.width - 20, maxHeight: 90, alignment: .bottom)
                                .font(.custom("Arial Rounded MT Bold", size: 60))
                                .padding(.top, 30)
                                .foregroundColor(.white)
                            
                            //line separater
                            Rectangle()
                                .opacity(0.0)
                                .frame(width: geometry.size.width * 0.7, height: 5)
                                .padding(5)
                                .background(Color("DarkBlue"))
                                .cornerRadius(10)
                                .padding(.bottom, 15)
                            
                            //A list of habit sections that user can tap into to view habits
                            ForEach(topics) { topic in
                                NavigationLink {
                                    //the child topic screen
                                    TopicDetails(section: topic.name ?? "Waste")
                                } label: {
                                    //what the topic looks like on the main screen
                                    TopicFrame(topic: topic, width: geometry.size.width, progress: Double(topic.progress)).padding(.bottom, 10)
                                }
                            }
                        }
                    }
                }
                .navigationBarHidden(true)
            }
        }
    }
}

/*
struct HabitsView_Previews: PreviewProvider {
    static var previews: some View {
        HabitsView()
    }
}
*/
