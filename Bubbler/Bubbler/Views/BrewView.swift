//
//  BrewView.swift
//  Bubbler
//
//  Created by Sam Kirk on 20/04/2021.
//  With help from: https://www.vadimbulavin.com/expand-and-collapse-list-with-animation-in-swiftui/
//

// View for a brew item on the main page

import SwiftUI
import SwiftUICharts

struct BrewView: View {
    
    @State private var showAlertsSheet = false
    @State var tableNumber = ""
    
    @ObservedObject var brew: BrewEntity
    
    let isExpanded: Bool
    
    @State var offset = CGSize.zero
    @State var scale : CGFloat = 0.5
    
    @State var selectedTag: String?
    
    @State var graphOn = true
    
    var body: some View {
        ZStack{
            Color.gray.opacity(0.1)
            ZStack{
                BeerColurSwitcher(brewName: brew.name)
                VStack{
                    ZStack{
                        Color.foam
                        HStack{
                            Text(brew.name)
                                .font(.system(size: 26, weight: .bold))
                                .foregroundColor(.offBlack)
                            Spacer()
                            ZStack{
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            gradient: Gradient(colors: [.lightGold, .darkGold]),
                                            startPoint: .topTrailing,
                                            endPoint: .bottomLeading
                                        )
                                    )
                                Text("\(brew.abv ?? "0.00")%")
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(.offBlack)
                            }
                            .frame(width: 70, height: 70, alignment: .center)
                        }
                        .padding()
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 25))
                    HStack{
                        Text("Start Date: ").foregroundColor(FontColurSwitcher(brewName: brew.name)) + Text(brew.getStartDate()).bold().foregroundColor(FontColurSwitcher(brewName: brew.name)) //get from dictionary
                        Spacer()
                        Text("OG: ").foregroundColor(FontColurSwitcher(brewName: brew.name)) + Text(brew.getOG()).bold().foregroundColor(FontColurSwitcher(brewName: brew.name)) //get from dictionary
                        
                    }
                    .padding(.top)
                    .padding(.leading)
                    .padding(.trailing)
                    HStack{
                        Text("End Date: ").foregroundColor(FontColurSwitcher(brewName: brew.name)) + Text(brew.getEndDate()).bold().foregroundColor(FontColurSwitcher(brewName: brew.name)) //get from dictionary
                        Spacer()
                        Text("FG: ").foregroundColor(FontColurSwitcher(brewName: brew.name)) + Text(brew.getFG()).bold().foregroundColor(FontColurSwitcher(brewName: brew.name)) //get from dictionary
                    }
                    .padding(.leading)
                    .padding(.trailing)
                    .padding(.bottom)
                    
                    if isExpanded {
                        VStack {
                            if brew.readings.count < 2{
                                ZStack{
                                    RoundedRectangle(cornerRadius: 25)
                                        .fill(Color.foam)
                                        .frame(width: 300, height:240)
                                        
                                    VStack{
                                        Spacer()
                                        Text("Not enough data yet.").font(.system(size: 20, weight: .bold)).foregroundColor(.offBlack)
                                        Spacer()
                                        Text("Add some readings! 🚀").font(.system(size: 18, weight: .bold)).foregroundColor(.offBlack)
                                        Spacer()
                                    }
                                }
                            } else {
                                LineChartView(data: brew.graphValues(), title: "Gravity", legend: "Over time", style: ChartStyle.init(backgroundColor: Color.foam, accentColor: Color.red, gradientColor: GradientColor.init(start: Color.green, end: Color.bottleGreen), textColor: Color.offBlack, legendTextColor: Color.gray, dropShadowColor: Color.white), form: CGSize(width:300, height:240), rateValue: nil, dropShadow: false, valueSpecifier: "%.3f")
                                //Not all params work but all are required
                            }
                            HStack{
                                Button("Alerts") {
                                    showAlertsSheet = true
                                }
                                    .buttonStyle(AlertsButton())
                                    .sheet(isPresented: $showAlertsSheet) {
                                        NotificationSheetView(brew: brew)
                                        }
                                Spacer()
                                Button(action: {
                                    brew.sortReadings()
                                    self.selectedTag = "readings"
                                }, label: {
                                    Text("Readings")
                                })
                                .background(
                                    NavigationLink(
                                        destination: ReadingsView(brew: brew),
                                        tag: "readings",
                                        selection: $selectedTag,
                                        label: { EmptyView()}
                                    )
                                )
                                .buttonStyle(ReadingsButton())
                            }
                            .padding()
                        }
                    }
                }
                .padding()
            }
            .clipShape(RoundedRectangle(cornerRadius: 40))
            .padding(5)
        }
        .clipShape(RoundedRectangle(cornerRadius: 45))
    }
}
