//
//  ContentView.swift
//  HW7
//
//  Created by Aiganym Moldagulova on 14/12/2021.
//

import SwiftUI


extension Color{
    static func rgb(r: Double, g: Double, b: Double) -> Color {
        return Color(red: r / 255, green: g / 255, blue: b / 255)
    }
    static let lightRed = Color.rgb(r: 255, g: 137, b: 131)
    static let darkRed = Color.rgb(r: 255, g: 59, b: 48)
    static let lightYellow = Color.rgb(r: 255, g: 224, b: 102)
    static let darkYellow = Color.rgb(r: 255, g: 204, b: 0)

}


struct currentTimeView: View{
    @Binding var date: Date
    @Binding var hours: Int
    @Binding var minutes: Int
    @Binding var seconds: Int
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View{
        HStack(spacing: 0){
            Text("Time is ")
                .onReceive(timer){ _ in
                    if(seconds <= 58) {
                        seconds = seconds + 1
                    }
                    else if(seconds == 59 && minutes <= 58){
                        seconds = 0
                        minutes = minutes + 1
                    } else if(seconds == 59 && minutes == 59) {
                        seconds = 0
                        minutes = 0
                        hours = hours + 1
                    } else if(seconds == 59 && minutes == 59 && hours == 23){
                        seconds = 0
                        minutes = 0
                        hours = 0
                    }
                }
            Text("\(hours):\(minutes):\(seconds)")
        }
    }
}

struct ContentView: View {
    @State private var date: Date = Date()
    
    @State var hour: Int = 0
    @State var minute: Int = 0
    @State var second: Int = 0
    
    func getHour() -> Int{
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: self.date)
        self.hour = hour
        return hour
    }
    
    func getMinute() -> Int{
        let calendar = Calendar.current
        let minute = calendar.component(.minute, from: self.date)
        self.minute = minute
        return minute
    }
    
    func getSecond() -> Int{
        let calendar = Calendar.current
        let second = calendar.component(.second, from: self.date)
        self.second = second
        return second
    }
    
    var body: some View {
        ZStack{
            Color(red: 242/255, green: 242/255, blue: 238/255)
                .ignoresSafeArea(.all)
            VStack(spacing: 10){
                currentTimeView(date: $date, hours: $hour, minutes: $minute, seconds: $second)
                BerlinClockView(hours: $hour, minutes: $minute, seconds: $second)
                pickerDate(date: $date)
                    .onAppear{
                        getHour()
                        getMinute()
                        getSecond()
                    }
                Spacer()
            }
           
        }
        .onTapGesture {
            self.getHour()
            self.getMinute()
            self.getSecond()
        }
    }
}

struct BerlinClockView: View{
    
    @Binding var hours: Int
    @Binding var minutes: Int
    @Binding var seconds: Int
    
    var body: some View{
        ZStack{
            Rectangle()
                .fill(.white)
                .frame(height: 312)
                .padding(.horizontal, 16)
            VStack(spacing: 16){
                SecondsView(second: $seconds)
                HStack(spacing: 10){
                    Hours5(hour: $hours)
                }
                HStack(spacing: 10){
                    Hours1(hour: $hours)
                }
                HStack(spacing: 10){
                    Minutes5(minutes: $minutes)
                }
                HStack(spacing: 10){
                    Minutes1(minutes: $minutes)
                }
                
            }
            .padding(.vertical, 32)
        }
    }
}

struct pickerDate: View{
    @Binding var date: Date
    var body: some View{
        ZStack{
            Rectangle()
                .fill(.white)
                .frame(height: 54)
            .padding(.horizontal, 16)
            HStack (spacing: 44){
                Text("Insert time")
                    .font(.system(size: 18, weight: .regular))
                    .frame(width: 190, height: 24, alignment: .leading)
                ZStack{
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color(red: 250/255, green: 250/255, blue: 250/255))
                        .frame(width: 74, height: 32)
                    DatePicker("", selection: $date, displayedComponents: .hourAndMinute)
                        .datePickerStyle(.compact)
                        .environment(\.locale, Locale(identifier: "ru-Ru"))
                        .frame(width: 74, height: 32)
                        
                }
            }
        }
    }
}

struct SecondsView: View{
    @Binding var second: Int

    var secondsCircle = Circle()
    
    var body: some View {
        if(second % 2 == 0){
            secondsCircle
                .fill(Color.darkYellow)
                .frame(width: 56, height: 56)
        }
        else{
            secondsCircle
                .fill(Color.lightYellow)
                .frame(width: 56, height: 56)
        }
    }
}

struct Hours5: View{
    @Binding var hour: Int
    
    func firstRowHour(number: Int) -> Int{
        return number / 5
    }
    
    var Hours5Array = Array(repeating: RoundedRectangle(cornerRadius: 4), count: 4)
    
    var body: some View {
        ForEach(0..<Hours5Array.count){ i in
            if(firstRowHour(number: hour) > i){
                Hours5Array[i]
                    .fill(Color.darkRed)
                    .frame(width: 74, height: 32)
            } else{
                Hours5Array[i]
                    .fill(Color.lightRed)
                    .frame(width: 74, height: 32)
            }
        }
    }
}

struct Hours1: View{
    @Binding var hour: Int
    
    func secondRowHour(number: Int) -> Int{
        return number % 5
    }
    
    var Hours1Array = Array(repeating: RoundedRectangle(cornerRadius: 4), count: 4)
    
    var body: some View {
        ForEach(0..<Hours1Array.count){ i in
            if(secondRowHour(number: hour) > i){
                Hours1Array[i]
                    .fill(Color.darkRed)
                    .frame(width: 74, height: 32)
            } else{
                Hours1Array[i]
                    .fill(Color.lightRed)
                    .frame(width: 74, height: 32)
            }
        }
    }
}

struct Minutes5: View{
    @Binding var minutes: Int
    
    func thirdRowMinutes(number: Int) -> Int{
        return number / 5
    }
    
    var minutes5Array = Array(repeating: RoundedRectangle(cornerRadius: 2), count: 12)
    
    var body: some View {
        ForEach(1..<minutes5Array.count){ i in
            if(thirdRowMinutes(number: minutes) + 1 > i && i % 3 == 0){
                minutes5Array[i]
                    .fill(Color.darkRed)
                    .frame(width: 21, height: 32)
            }else if (thirdRowMinutes(number: minutes) + 1 > i && i % 3 != 0){
                minutes5Array[i]
                    .fill(Color.darkYellow)
                    .frame(width: 21, height: 32)
            }else if (thirdRowMinutes(number: minutes) + 1 < minutes5Array.count - 1 && i % 3 != 0){
                minutes5Array[i]
                    .fill(Color.lightYellow)
                    .frame(width: 21, height: 32)
            }
            else{
                minutes5Array[i]
                    .fill(Color.lightRed)
                    .frame(width: 21, height: 32)
            }
        }
    }
}

struct Minutes1: View{
    @Binding var minutes: Int
    
    func fourthRowMinutes(number: Int) -> Int{
        return number % 5
    }
    
    var Minutes1Array = Array(repeating: RoundedRectangle(cornerRadius: 4), count: 4)
    
    var body: some View {
        ForEach(0..<Minutes1Array.count){ i in
            if(fourthRowMinutes(number: minutes) > i){
                Minutes1Array[i]
                    .fill(Color.darkYellow)
                    .frame(width: 74, height: 32)
            } else{
                Minutes1Array[i]
                    .fill(Color.lightYellow)
                    .frame(width: 74, height: 32)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
