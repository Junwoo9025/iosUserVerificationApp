import SwiftUI
import UIKit

struct ActivityIndicator: UIViewRepresentable {

    @Binding var isAnimating: Bool
    let style: UIActivityIndicatorView.Style

    func makeUIView(context: UIViewRepresentableContext<ActivityIndicator>) -> UIActivityIndicatorView {
        return UIActivityIndicatorView(style: style)
    }

    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<ActivityIndicator>) {
        isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
    }
}


struct ContentView: View {
    @State private var username = ""
    @State private var userpassword = ""
    @State private var wrongUsername = false
    @State private var wrongPassword = false
    @State private var showingLoginScreen = false
    @State private var isLoggedOut = false
    @State private var showingPasswordResetView = false
    @State private var rememberMe = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(red: 0.33, green: 0.56, blue: 0.89)
                    .ignoresSafeArea()
                Circle()
                    .scale(1.7)
                    .foregroundColor(.white.opacity(0.15))
                Circle()
                    .scale(1.35)
                    .foregroundColor(.white)
                VStack {
                    Text("Login")
                        .font(.largeTitle)
                        .bold()
                        .padding()
                    TextField("Username", text: $username)
                        .padding()
                        .frame(width: 300, height: 50)
                        .background(Color.black.opacity(0.05))
                        .cornerRadius(10)
                        .border(wrongUsername ? Color.red : Color.clear, width: 2)
                    SecureField("Password", text: $userpassword)
                        .padding()
                        .frame(width: 300, height: 50)
                        .background(Color.black.opacity(0.05))
                        .cornerRadius(10)
                        .border(wrongPassword ? Color.red : Color.clear, width: 2)
                    Button("Login") {
                               self.authenticateUser(username: self.username, password: self.userpassword)
                           }
                           .foregroundColor(.white)
                           .frame(width: 150, height: 25)
                           .background(Color(red: 0.33, green: 0.56, blue: 0.89))
                           .cornerRadius(10)
                    
                    if showingLoginScreen {
                        NavigationLink(destination: Text("You are logged in @\(username)"), isActive: $showingLoginScreen) {
                            EmptyView()
                        }
                    }
                    Button("Logout") {
                        print("logged out")
                        self.username = ""
                        self.userpassword = ""
                        self.isLoggedOut = true
                        if rememberMe {
                            UserDefaults.standard.removeObject(forKey: "username")
                            UserDefaults.standard.removeObject(forKey: "password")
                        }
                    }
                    .foregroundColor(.white)
                    .frame(width: 150, height: 25)
                    .background(Color(red: 0.33, green: 0.56, blue: 0.89))
                    .cornerRadius(10)

                    if isLoggedOut {
                        NavigationLink(destination: Text("You are succeffuly logout @\(username)"), isActive: $isLoggedOut) {
                            EmptyView()
                        }
                    }
                           
                           if (wrongUsername || wrongPassword) && !showingLoginScreen {
                               Text(wrongUsername ? "Wrong username" : "Wrong password")
                                   .foregroundColor(.red)
                               Button("Forgot Password") {
                                   self.showingPasswordResetView = true
                               }
                               .foregroundColor(.white)
                               .frame(width: 200, height: 50)
                               .background(Color(red: 0.33, green: 0.56, blue: 0.89))
                               .cornerRadius(10)
                               .sheet(isPresented: $showingPasswordResetView) {
                                   PasswordResetView()
                               }
                           }
                       }
                       .navigationBarHidden(true)
                   }
               }
           }
           
           func authenticateUser(username: String, password: String) {
               if username.lowercased() == "junwoo9025" {
                   wrongUsername = false
                   if password.lowercased() == "jkl456" {
                       wrongPassword = false
                       showingLoginScreen = true
                   } else {
                       wrongPassword = true
                   }
               } else {
                   wrongUsername = true
               }
           }
       }
        
struct PasswordResetView: View {
    @State private var email = ""
    @State private var errorMessage = ""
    @State private var successMessage = ""
    @State private var isLoading = false
    var body: some View {
        VStack {
            TextField("Email", text: $email)
                .padding()
                .frame(width: 300, height: 50)
            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }
            if !successMessage.isEmpty {
                Text(successMessage)
                    .foregroundColor(.green)
                    .padding()
            }
            if isLoading {
                HStack {
                    Spacer()
                    ActivityIndicator(isAnimating: $isLoading, style: .medium)
                    Spacer()
                }
            }
            else{
                Button("Reset Password") {
                    self.resetPassword()
                }
                .foregroundColor(.white)
                .frame(width: 300, height: 50)
                .background(Color(red: 0.33, green: 0.56, blue: 0.89))
                .cornerRadius(10)
            }
        }
    }
    func resetPassword() {
        guard !email.isEmpty else {
            errorMessage = "Email is required"
            return
        }
        guard email.contains("@") && email.contains(".") else {
            errorMessage = "Invalid email address"
            return
        }
        // Call API to reset password using the provided email
        // You can add some code to make the request to the server,
        // handle the response and update the state variables accordingly
        self.isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.isLoading = false
            self.successMessage = "A password reset link has been sent to your email."
        }
    }
}
