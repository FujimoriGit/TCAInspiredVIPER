//
//  LoginFeature.swift
//  TCAInspiredVIPER
//  
//  Created by Daiki Fujimori on 2025/06/01
//  

struct LoginFeature {

    // MARK: - private property
    
    private let context: LoginContext
    private let router: LoginWireframe
    
    // MARK: - initialize
    
    init(context: LoginContext, router: LoginWireframe) {
        
        self.context = context
        self.router = router
    }
}

// MARK: - extension (for implements Reducer)

extension LoginFeature: Reducer {
    
    // MARK: - State definition
    
    struct State: Equatable {
        
        var email = ""
        var password = ""
        var isLoading = false
        var error: String?
    }
    
    // MARK: - Action definition
    
    enum Action {
        
        case emailChanged(String)
        case passwordChanged(String)
        case loginButtonTapped
        case loginSucceeded(User)
        case loginFailed(Error)
        case signUpTapped
        case forgotPasswordTapped
    }
    
    // MARK: - reduce definition
    
    func reduce(state: inout State, action: Action) -> Effect<Action> {
        
        switch action {
            
        case .emailChanged(let email):
            state.email = email
            return .none

        case .passwordChanged(let password):
            state.password = password
            return .none

        case .loginButtonTapped:
            state.isLoading = true
            return executeLoginTask(state: state)
            
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

// MARK: - private method

private extension LoginFeature {
    
    func executeLoginTask(state: State) -> Effect<Action> {
        
        .task { [email = state.email, password = state.password] in
            
            do {
                
                let user = try await LoginInteractor.login(context: context,
                                                           email: email,
                                                           password: password)
                return .loginSucceeded(user)
            } catch {
                
                return .loginFailed(error)
            }
        }
    }
}
