//
//  HomeView.swift
//  SupabaseAuth
//
//  Created by Muhammad Osama Naeem on 11/5/21.
//

import SwiftUI
import Supabase

struct HomeView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var user: User
    
    var body: some View {
        VStack {
            Text("Hello,\(user.name ?? "")")
            Button {
                self.signOut()
            } label: {
              
                Text("Sign Out")
                    .padding()
                    .background(Color.blue.opacity(0.3))
                    .cornerRadius(5)
            }.padding(.top, 20)
        }
    }
    
    func signOut(){
        API.supabase.auth.signOut { result in
            print("Signed Out")
            presentationMode.wrappedValue.dismiss()
        }
    }
}
