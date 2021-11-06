//
//  SignInView.swift
//  SupabaseAuth
//
//  Created by Muhammad Osama Naeem on 11/5/21.
//

import Foundation
import SwiftUI
import Supabase

struct SignInView: View {
    @State var presentHomeView: Bool = false
    @State var email = ""
    @State var password = ""
    
    @State var user = User()
    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                Text("Log In")
                    .font(.largeTitle)
                    .bold()
                    .padding(.bottom, 24)
                TextField("Email", text: $email)
                SecureField("Password", text: $password)
                Button {
                    self.signIn(email: self.email, password: self.password)
                } label: {
                  
                    Text("Log In")
                        .padding()
                        .background(Color.blue.opacity(0.3))
                        .cornerRadius(5)
                }.padding(.top, 20)
            Spacer()
            }
            .padding(.horizontal)
            .padding(.top, 64)
           
        }
        .fullScreenCover(isPresented: self.$presentHomeView) {
            HomeView(user: $user)
        }
    }
    
    func signIn(email: String, password: String) {
        API.supabase.auth.signIn(email: email, password: password) { result in
            switch result {
            case let .success(session):
                print(session)
                guard let safeUser = session.user else { return }
                self.fetchUserDetails(userID: safeUser.id) { user in
                    self.user = user
                    self.presentHomeView = true
                }
               
                self.email = ""
                self.password = ""
            case let .failure(error):
                print(error.localizedDescription)
            }
        }
    }
    
    func fetchUserDetails(userID: String, completion: @escaping (_ user: User) -> ())  {
        API.supabase.database.from("User").select().eq(column: "userID", value: userID).execute { result in
            switch result {
            case let .success(response):
                print(response)
                    do {
                        let user = try response.decoded(to: [User].self)
                        completion(user[0])
                        print(user[0])
                    } catch {
                        print(String(describing: error))
                    }
            case let .failure(error):
                print(error.localizedDescription)
            }
        }
    }
}
