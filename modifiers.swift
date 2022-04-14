//
//  modifiers.swift
//  Sustain
//
//  Created by Jocelyn Zhao on 2021-12-27.
//

import SwiftUI

struct Background: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding([.top, .bottom])
            .background(Color("LightYellow"))
            .cornerRadius(20)
            .padding(.bottom)
    }
}

struct YellowColor: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(5)
            .background(Color("DarkYellow"))
            .cornerRadius(10)
    }
}

extension View {
    func background() -> some View {
        modifier(Background())
    }
    func darkYellow() -> some View {
        modifier(YellowColor())
    }
}

class MyNavigationController: UINavigationController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
}
