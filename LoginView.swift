//
//  LoginView.swift
//  Sustain
//
//  Created by Jocelyn Zhao on 2022-01-20.
//

import SwiftUI
import UserNotifications

struct LoginView: View {
    @Binding var push: Bool
    
    //reference to manaaged object context
    @Environment(\.managedObjectContext) var moc
    
    //Fetches the required data from Core Data
    @FetchRequest(sortDescriptors: [NSSortDescriptor(key: "name", ascending: true)]) var coreDataHabits: FetchedResults<Habit>
    @FetchRequest(sortDescriptors: []) var coreDataTopics: FetchedResults<Topic>
    @FetchRequest(sortDescriptors: []) var collectedData: FetchedResults<CollectedData>
    @StateObject var jsonModel = JSONViewModel()
    
    var body: some View {
        ZStack {
            Color.black
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                WelcomeText()
                
                UserImage()
                
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.8)) {
                        self.push.toggle()
                    }
                    addData()
                    addNotification(for: coreDataHabits[Int(collectedData[0].spotlightHabit)])
                    
                }, label: {
                    LoginButton()
                })
            }
        }
    }
    
    //request to send notifications
    func addNotification(for habit: Habit) {
        let center = UNUserNotificationCenter.current()

        let addRequest = {
            let content = UNMutableNotificationContent()
            content.title = "Complete a sustainable habit!"
            content.subtitle = "Double points: \(habit.name ?? "Name not provided")"
            content.sound = UNNotificationSound.default

            var dateComponents = DateComponents()
            dateComponents.hour = 8
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            center.add(request)
        }

        center.getNotificationSettings { settings in
            if settings.authorizationStatus == .authorized {
                addRequest()
            } else {
                center.requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                    if success {
                        addRequest()
                    } else {
                        print("Oh no.. I guess you won't get notifications about cool things.")
                    }
                }
            }
        }
    }
    
    //runs the first time that the app is launched in order to populate the Core Data entities with the JSON files
    func addData() {
        if collectedData.isEmpty {
            let newData = CollectedData(context: self.moc)
            newData.needGoals = true
            newData.overallGoals = Int16(1.0)
            newData.progress = 0.0
            newData.startDate = Date()
            newData.currentDate = Date()
            newData.spotlightHabit = 0
            
            try? self.moc.save()
        }
        if coreDataHabits.isEmpty {
            for habit in jsonModel.habits {
                let newHabit = Habit(context: self.moc)
                newHabit.name = habit.name
                newHabit.information = habit.information
                newHabit.id = UUID()
                newHabit.points = Int16(habit.points)
                newHabit.section = habit.section
                newHabit.special = habit.special
                
                try? self.moc.save()
            }
            
        }
        if coreDataTopics.isEmpty {
            for topic in jsonModel.topics {
                let newTopic = Topic(context: self.moc)
                newTopic.name = topic.name
                newTopic.progress = Double(topic.progress)
                newTopic.goal = Double(topic.progress)
                newTopic.symbol = topic.symbol
                
                try? self.moc.save()
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(push: .constant(false))
    }
}

struct WelcomeText: View {
    var body: some View {
        Text("SUSTAIN")
            .foregroundColor(.white)
            .fontWeight(.bold)
            .padding(.bottom, 20)
            .font(.custom("Arial Rounded MT Bold", size: 40))
    }
}

struct UserImage: View {
    var body: some View {
        Image("HomeScreenBackground")
            .resizable()
            .aspectRatio(contentMode: .fit)
            //.edgesIgnoringSafeArea(.all)
            .frame(width: 200)
            .clipShape(Circle())
            .padding(.bottom, 75)
    }
}

struct LoginButton: View {
    var body: some View {
        Text("BEGIN")
            .font(.headline)
            .foregroundColor(.black)
            .padding()
            .frame(width: 220, height: 60)
            .background(Color(.white))
            .cornerRadius(15.0)
    }
}
