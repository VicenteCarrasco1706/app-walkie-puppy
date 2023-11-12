//
//  AuthenticationRepository.swift
//  app-walkie-puppy
//
//  Created by DAMII on 12/11/23.
//

import Foundation
final class AuthenticationRepository{
    private let authenticationFirebaseDataSource: AuthenticationFirebaseDataSource
    
    init(authenticationFirebaseDataSource: AuthenticationFirebaseDataSource){
        self.authenticationFirebaseDataSource = authenticationFirebaseDataSource
    }
    
    func createnewUser(email: String, password: String, completionBlock: @escaping (Result<User, Error>) -> Void){
        authenticationFirebaseDataSource.createNewUser(email: email,
                                                   password: password,
                                                   completionBlock: completionBlock)
                        }
    
}
