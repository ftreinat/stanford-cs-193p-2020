//
//  FilterFlights.swift
//  Enroute
//
//  Created by Florian Treinat on 19.08.20.
//  Copyright © 2020 Stanford University. All rights reserved.
//

import SwiftUI
import MapKit

struct FilterFlights: View {
    @FetchRequest(fetchRequest: Airport.fetchRequest(.all)) var airports: FetchedResults<Airport>
    @FetchRequest(fetchRequest: Airline.fetchRequest(.all)) var airlines: FetchedResults<Airline>
    
    @Binding var flightSearch: FlightSearch
    @Binding var isPresented: Bool
    
    @State private var draft: FlightSearch
    
    init(flightSearch: Binding<FlightSearch>, isPresented: Binding<Bool>) {
        _flightSearch = flightSearch
        _isPresented = isPresented
        _draft = State(wrappedValue: flightSearch.wrappedValue)
    }
    
    var destination: Binding<MKAnnotation?> {
        return Binding<MKAnnotation?>(
            get: { return self.draft.destination },
            set: { annotation in
                if let airport = annotation as? Airport {
                    self.draft.destination = airport
                }
            }
        )
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Picker("Destination", selection: $draft.destination) {
                        ForEach(airports.sorted(), id: \.self) { airport in
                            Text("\(airport.friendlyName)").tag(airport)
                            //Picker puts the value inside of tag into the selection Binding
                        }
                    }
                    MapView(annotations: airports.sorted(), selection: destination)
                        .frame(minHeight: 400)
                }
                Picker("Origin", selection: $draft.origin) {
                    Text("Any").tag(Airport?.none)
                    ForEach(airports.sorted(), id: \.self) { (airport: Airport?)  in
                        Text("\(airport?.friendlyName ?? "Any")").tag(airport)
                        //Picker puts the value inside of tag into the selection Binding
                    }
                }
                Picker("Airline", selection: $draft.airline) {
                    Text("Any").tag(Airline?.none)
                    ForEach(airlines.sorted(), id: \.self) { (airline: Airline?) in
                        Text("\(airline?.friendlyName ?? "Any")").tag(airline)
                        //Picker puts the value inside of tag into the selection Binding
                    }
                }
                Toggle(isOn: $draft.inTheAir) {
                    Text("Enroute Only")
                }
            }
                .navigationBarTitle("Filter Flights")
                .navigationBarItems(leading: cancel, trailing: done)
        }
    }
    
    var cancel: some View {
        Button("Cancel") {
            self.isPresented = false
        }
    }
    
    var done: some View {
        Button("Done") {
            if self.draft.destination != self.flightSearch.destination {
                self.draft.destination.fetchIncomingFlights()
            }
            //make the actual changes
            self.flightSearch = self.draft
            self.isPresented = false
        }
    }
}


//struct FilterFlights_Previews: PreviewProvider {
//    static var previews: some View {
//        FilterFlights()
//    }
//}
