//
//  EditUserProfileView.swift
//  
//  Created by Manajit Halder on 04/11/23 using Swift 5.0 on MacOS 13.4
//  

import SwiftUI

struct EditUserProfile: View {
    @State private var userName: String = ""
    @State private var fullName: String = ""
    @State private var gender: String = ""
    @State private var email: String = ""
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        List {
            
            Section("User Name: ") {
                TextField("User Name", text: $userName)
            }
            
            Section("User Name: ") {
                TextField("Full Name", text: $fullName)
            }
            
            Section("User Name: ") {
                TextField("Email", text: $email)
            }
            
            HStack {
                Section("") {
                    HStack {
                        Button {
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            Text("Cancel")
                        }
                        
                        Spacer()
                        
                        Button {
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            Text("Save")
                        }
                    }
                }
            }
        }
        .presentationDetents([.fraction(0.5)])
        .presentationDragIndicator(.visible)
        .presentationCornerRadius(40.0)
        .padding()
    }
}

struct EditUserProfile_Previews: PreviewProvider {
    static var previews: some View {
        EditUserProfile()
    }
}
