//
//  TopicFrame.swift
//  Sustain
//
//  Created by Jocelyn Zhao on 2022-01-30.
//

import SwiftUI

struct TopicFrame: View {
    var topic: Topic
    var width: CGFloat
    var progress: Double
    
    var body: some View {
        ZStack {
            //image
            HStack {
                Spacer()
                
                Image(topic.symbol ?? "Wildlife")
                    .resizable()
                    .scaledToFit()
                    .frame(width: width * 0.7, height: width * 0.4)
                    .padding(.trailing, 20)
            }
            
            //border
            RoundedRectangle(cornerRadius: 20)
                .strokeBorder(lineWidth: 4)
                .foregroundColor(Color("DarkBlue"))
                .frame(width: width)
            
            //title and arrow
            HStack {
                //title
                Text(topic.name?.uppercased() ?? "Unknown Name")
                    .font(.custom("Gill Sans", size: 25))
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    
                Spacer()
                
                //arrow
                Image(systemName: "chevron.right")
                    .foregroundColor(.white)
            }
            .padding([.leading, .trailing], 10)
            .frame(width: width * 0.9)
        }
    }
}

/*struct TopicFrame_Previews: PreviewProvider {
    @Environment (\.managedObjectContext) var moc
    
    static var previews: some View {
        TopicFrame(topic: Topic().example(), width: 100, progress: 0.2)
    }
}
*/
