//
//  LoginFeature.swift
//  TCAInspiredVIPER
//  
//  Created by Daiki Fujimori on 2025/06/01
//  

struct LoginFeature: Reducer {
    
    typealias State = LoginState
    typealias Action = LoginAction

    let context: LoginContext
    let router: LoginWireframe

    func reduce(state: inout LoginState, action: LoginAction) -> Effect<LoginAction> {
        
        switch action {
            
        case .emailChanged(let email):
            state.email = email
            return .none

        case .passwordChanged(let password):
            state.password = password
            return .none

        case .loginButtonTapped:
            state.isLoading = true
            return .task { [email = state.email, password = state.password] in
                
                do {
                    
                    let user = try await LoginInteractor.login(context: context,
                                                               email: email,
                                                               password: password)
                    return .loginSucceeded(user)
                } catch {
                    
                    return .loginFailed(error)
                }
            }
            
        case .loginSucceeded:
            state.isLoading = false
            return .navigation { router.navigate(to: .home) }
            
        case .loginFailed(let error):
            state.isLoading = false
            state.error = error.localizedDescription
            return .none

        case .signUpTapped:
            return .navigation { router.navigate(to: .signUp) }

        case .forgotPasswordTapped:
            return .navigation { router.navigate(to: .forgotPassword) }
        }
    }
}
