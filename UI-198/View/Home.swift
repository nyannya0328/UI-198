//
//  Home.swift
//  UI-198
//
//  Created by にゃんにゃん丸 on 2021/05/20.
//

import SwiftUI

struct Home: View {
    @State var selected = "INCOMINGS"
    @Namespace var animation
    
    @State var weeks : [Week] = []
    
    @State var currentday : Week = Week(day: "", date: "", amountspent: 0)
    var body: some View {
        VStack{
            
            
            HStack{
                
                
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                    Image("m1")
                        .resizable()
                        .renderingMode(.template)
                        .frame(width: 30, height: 30)
                        .foregroundColor(.primary)
                })
                
                Spacer(minLength: 0)
                
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                    Image("menu")
                        .resizable()
                        .renderingMode(.template)
                        .frame(width: 30, height: 30)
                        .foregroundColor(.primary)
                })
                
                
            }
            .padding()
            
            
            Text("STATICS")
                .font(.title)
                .fontWeight(.heavy)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading,10)
            
            
            HStack{
                
                Text("INCOMINGS")
                    .fontWeight(.bold)
                    .padding(.vertical,10)
                    .padding(.horizontal,20)
                    .foregroundColor(selected == "INCOMINGS" ? .black : .white)
                    .background(
                    
                    
                        ZStack{
                            
                            if selected == "INCOMINGS"{
                                
                                Color.white
                                    .matchedGeometryEffect(id: "TAB", in: animation)
                                
                            }
                            
                        }
                    )
                    .cornerRadius(10)
                    .onTapGesture {
                        selected = "INCOMINGS"
                    }
                
                
                Text("OUTCOMINGS")
                    .fontWeight(.bold)
                    .padding(.vertical,10)
                    .padding(.horizontal,20)
                    .foregroundColor(selected == "OUTCOMINGS" ? .black : .white)
                    .background(
                    
                    
                        ZStack{
                            
                            if selected == "OUTCOMINGS"{
                                
                                Color.white
                                    .matchedGeometryEffect(id: "TAB", in: animation)
                                
                            }
                            
                        }
                    )
                    .cornerRadius(10)
                    .onTapGesture {
                        selected = "OUTCOMINGS"
                    }
                
                
            }
            .padding(.vertical,5)
            .padding(.horizontal,20)
            .background(Color.black.opacity(0.3))
            .cornerRadius(10)
            .padding(.top,20)
            
            
            HStack(spacing:35){
                
                let progress = currentday.amountspent / 10000
                
                ZStack{
                    
                    Circle()
                        .stroke(Color.white,lineWidth: 20)
                    
                    Circle()
                        .trim(from: 0, to: progress)
                        .stroke(Color.yellow,style: StrokeStyle(lineWidth: 20, lineCap: .round, lineJoin: .round))
                        .rotationEffect(.init(degrees: -90))
                    
                    Image(systemName: "dollarsign.circle.fill")
                        .font(.system(size: 60, weight: .bold))
                        .foregroundColor(.primary)
                    
                    
                }
                .frame(maxWidth: 180)
                
                
                VStack(alignment: .leading, spacing: 15, content: {
                    
                    let amount = String(format: "%.f", currentday.amountspent)
                    
                    Text("SPENT")
                        .font(.title)
                        .foregroundColor(Color.white.opacity(0.6))
                    
                    Text("\(amount)YEN")
                        .foregroundColor(.gray)
                    
                    
                    Text("MAXIMUM")
                        .font(.title)
                        .foregroundColor(Color.white.opacity(0.6))
                    
                    Text("10000YEN")
                        .foregroundColor(.gray)
                    
                    
                })
                .frame(maxWidth: .infinity,alignment: .leading)
            }
            .padding(.leading,30)
            
            
            ZStack{
                
                
                
                if UIScreen.main.bounds.height < 750{
                    
                    
                    ScrollView(.vertical, showsIndicators: false, content: {
                        ButtonSheet(weeks: $weeks, currentday: $currentday)
                            .padding([.horizontal,.top])
                        
                        
                    })
                }
                
                
                else{
                    
                    ButtonSheet(weeks: $weeks, currentday: $currentday)
                        .padding([.horizontal,.top])
                    
                    
                }
            }
            
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
         
            .background(Color.white.clipShape(CustomShape(radi: 30, corner: [.topLeft,.topRight]))
                            
                            .ignoresSafeArea(.all, edges: .bottom)
            )
            
            
            
            
            
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("bg").ignoresSafeArea())
        .onAppear(perform: {
            getWeeks()
        })
    }
    
    func getWeeks(){
        
        let calender = Calendar.current
        let week = calender.dateInterval(of: .weekOfMonth, for: Date())
        
        guard let startDate = week?.start else {return}
        
        for index in 0..<7{
            
            guard let date = calender.date(byAdding: .day,value: index, to: startDate) else {return}
            
            let formatter = DateFormatter()
            
            formatter.dateFormat = "EEE"
            
            var day = formatter.string(from: date)
            day.removeLast()
            
            formatter.dateFormat = "dd"
            
            let dateString = formatter.string(from: date)
            weeks.append(Week(day: day, date: dateString, amountspent: index == 0 ? 1000 : CGFloat(index) * 1500))
            
            
        }
        
        self.currentday = weeks.first!
        
        
        
        
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}

struct CustomShape : Shape {
    var radi : CGFloat
    var corner : UIRectCorner
    
    func path(in rect: CGRect) -> Path {
       let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corner, cornerRadii: CGSize(width: radi, height: radi))
        
        return Path(path.cgPath)
    }
}
struct Week : Identifiable {
    var id = UUID().uuidString
    var day : String
    var date : String
var amountspent : CGFloat
}


struct ButtonSheet: View {
    
    @Binding var weeks : [Week]
    @Binding var currentday : Week
    var body: some View {
        VStack(spacing: 15, content: {
            
            
            Capsule()
                .fill(Color.gray)
                .frame(width: 100, height: 2)
            
            
            HStack{
                
                
                VStack(alignment: .leading, spacing: 15, content: {
                    
                    Text("Youre Balance")
                        .font(.title)
                        .fontWeight(.heavy)
                        .foregroundColor(.primary)
                    
                    Text("May 20 2022")
                    
                    
                    
                    
                    
                })
                
                
                
                Spacer(minLength: 0)
                
                
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                    Image(systemName: "square.and.arrow.up.fill")
                        .font(.title2)
                        .foregroundColor(.purple)
                        .offset(y: -10)
                })
                
                
            }
            .padding(.top)
            
            HStack{
                
                Text("22,306,07")
                    .font(.title)
                    .fontWeight(.heavy)
                    .foregroundColor(.primary)
                
                Spacer()
                
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                    Image(systemName: "arrow.up")
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding(7)
                        .background(Color("bg"))
                        .clipShape(Capsule())
                })
                
            }
            .padding(.top,8)
            
            
            HStack{
                
                
                ForEach(weeks){week in
                    
                    VStack(spacing:10){
                        
                        Text(week.day)
                            .fontWeight(.bold)
                            .foregroundColor(currentday.id == week.id ? .blue : .gray)
                        
                        Text(week.date)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(currentday.id == week.id ? .blue : .gray)
                        
                        
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical)
                    .background(Color.yellow.opacity(currentday.id == week.id ?  1 : 0))
                    .clipShape(Capsule())
                    .onTapGesture {
                        withAnimation{
                            
                            currentday = week
                        }
                    }
                    
                    
                }
            }
            .padding(.top,20)
            
            
            Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                Image(uiImage: #imageLiteral(resourceName: "right-arrow"))
                    .resizable()
                    .renderingMode(.template)
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 50, height: 50)
                    .padding(.vertical,5)
                    .padding(.horizontal,50)
                    .background(Color("bg"))
                    .clipShape(Capsule())
                    .shadow(color: .black.opacity(0.3), radius: 5, x: 5, y: 5)
                    .shadow(color: .red.opacity(0.3), radius: -5, x: -5, y: -5)
            })
            
            
            
        })
        
    }
}
