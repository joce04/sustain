//
//  SustainApp.swift
//  Sustain
//
//  Created by Jocelyn Zhao on 2021-09-09.
//

import SwiftUI

@main
struct SustainApp: App {
    let persistenceController = PersistenceController.shared
    @Environment(\.scenePhase) var scenePhase

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
        .onChange(of: scenePhase) { _ in
            persistenceController.save()
        }
    }
}
