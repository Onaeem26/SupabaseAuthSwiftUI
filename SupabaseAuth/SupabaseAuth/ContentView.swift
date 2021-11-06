//
//  ContentView.swift
//  SupabaseAuth
//
//  Created by Muhammad Osama Naeem on 11/5/21.
//

import SwiftUI
import Supabase

struct User: Codable {
    var id: Int?
    var userID : String?
    var name: String?
    var email: String?
}

struct ContentView: View {
    @State var email: String = ""
    @State var password: String = ""
    @State var name: String = ""
    
    @State var presentHomeView: Bool = false
    @State var user = User()
    
    var body: some View {
        
        NavigationView {
            ZStack {
                VStack(spacing: 20) {
                    Text("Sign Up")
                        .font(.largeTitle)
                        .bold()
                        .padding(.bottom, 24)
                    TextField("Name", text: $name)
                    TextField("Email", text: $email)
                    SecureField("Password", text: $password)
                    Button {
                        self.signUp(email: self.email, password: self.password, name: self.name)
                    } label: {
                      
                        Text("Sign Up")
                            .padding()
                            .background(Color.blue.opacity(0.3))
                            .cornerRadius(5)
                    }.padding(.top, 20)
                    
                    
                    HStack {
                        Text("Already Registered")
                        NavigationLink("Log In", destination: SignInView())
                    }
                    
                    
                Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 64)
               
            }.fullScreenCover(isPresented: self.$presentHomeView) {
                HomeView(user: self.$user)
            }
           
        }

    }
    func signUp(email: String, password: String, name: String) {
        API.supabase.auth.signUp(email: email, password: password) { result in
            switch result {
            case let .success(session):
                print(session)
                guard let safeUser = session.user else { return }
                let user = User(userID: safeUser.id,name: name,email: safeUser.email)
                self.user = user
                self.addUserToDatabase(user: user)
                self.presentHomeView = true
                self.email = ""
                self.password = ""
            case let .failure(error):
                print(error.localizedDescription)
            }
        }
    }
    
    func addUserToDatabase(user: User) {
        do {
            let jsonData: Data = try JSONEncoder().encode(user)

            API.supabase.database.from("User").insert(values: jsonData).execute { result in
                switch result {
                case let .success(response):
                    print(response)
                    print("Success")
                case let .failure(error):
                    print(error.localizedDescription)
                }
            }

        } catch {
            print(error.localizedDescription)
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
