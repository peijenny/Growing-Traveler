//
//  UserManager.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/21.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

class UserManager {
    
    let database = Firestore.firestore().collection("user")
    
    func fetchUsersInfo(completion: @escaping (Result<[UserInfo]>) -> Void) {
        
        var usersInfo: [UserInfo] = []
        
        database.getDocuments { snapshot, error in
            
            guard let snapshot = snapshot else {
                
                completion(Result.failure(error!))
                
                return
                
            }
            
            for document in snapshot.documents {
                
                do {
                    
                    if let userInfo = try document.data(as: UserInfo.self, decoder: Firestore.Decoder()) {
                        
                        usersInfo.append(userInfo)
                        
                    }
                    
                } catch {
                    
                    completion(Result.failure(error))

                }
                
            }
            
            completion(Result.success(usersInfo))
            
        }
        
    }
    
    func fetchUserInfo(fetchUserID: String, completion: @escaping (Result<UserInfo>) -> Void) {
        
        database.document(fetchUserID).getDocument { snapshot, error in
            
            guard let snapshot = snapshot else {
                
                completion(Result.failure(error!))
                
                return
                
            }

            do {
                
                if let user = try snapshot.data(as: UserInfo.self, decoder: Firestore.Decoder()) {
                    
                    completion(Result.success(user))
                    
                }
                
            } catch {
                
                completion(Result.failure(error))
                
            }
            
        }
        
    }
    
    func listenUserInfo(completion: @escaping (Result<UserInfo>) -> Void) {
        
        if !KeyToken().userID.isEmpty {
            
            database.document(KeyToken().userID).addSnapshotListener { snapshot, error in
                
                guard let snapshot = snapshot else {
                    
                    completion(Result.failure(error!))
                    
                    return
                    
                }
  
                do {
                    
                    if let user = try snapshot.data(as: UserInfo.self, decoder: Firestore.Decoder()) {
                        
                        completion(Result.success(user))
                        
                    }
                    
                } catch {
                    
                    completion(Result.failure(error))
                    
                }
                
            }
            
        }
        
    }
    
    func updateUserInfo(user: UserInfo) {
        
        do {
            
            if !KeyToken().userID.isEmpty {
                
                try database.document(KeyToken().userID).setData(from: user, merge: true)
                
            }
            
        } catch {
            
            HandleResult.updateDataFailed.messageHUD
            
        }
        
    }
    
    func addUserInfo(user: UserInfo) {
        
        do {
            
            try database.document(user.userID).setData(from: user, merge: true)
            
        } catch {
            
            HandleResult.addDataFailed.messageHUD
            
        }
        
    }
    
    func fetchshareFriendNote(shareUserID: String, noteID: String, completion: @escaping (Result<Note>) -> Void) {
        
        database.document(shareUserID).collection("note")
            .whereField("noteID", isEqualTo: noteID)
            .getDocuments { snapshot, error in
            
            guard let snapshot = snapshot else {
                
                completion(Result.failure(error!))
                
                return
                
            }

            do {
                
                if let note = try snapshot.documents[0].data(as: Note.self, decoder: Firestore.Decoder()) {
                    
                    completion(Result.success(note))
                    
                }
                
            } catch {
                
                completion(Result.failure(error))
                
            }
            
        }
        
    }
    
    func fetchUserNote(completion: @escaping (Result<[Note]>) -> Void) {
        
        database.document(KeyToken().userID).collection("note")
            .getDocuments { snapshot, error in
            
            var notes: [Note] = []
            
            guard let snapshot = snapshot else {
                
                return
                
            }
            
            for document in snapshot.documents {
                
                do {
                    
                    if let note = try document.data(as: Note.self, decoder: Firestore.Decoder()) {
                        
                        notes.append(note)
                        
                    }
                    
                } catch {
                    
                    completion(Result.failure(error))

                }
                
            }
            
            completion(Result.success(notes))
            
        }
        
    }
    
    func updateUserNote(note: Note) {
     
        do {
            
            try database.document(KeyToken().userID).collection("note")
                .document(note.noteID).setData(from: note, merge: true)
            
        } catch {
            
            HandleResult.updateDataFailed.messageHUD
            
        }
        
    }
    
    func deleteUserNote(note: Note) {
        
        database.document(KeyToken().userID).collection("note").document(note.noteID).delete { error in
            
            if error != nil {
                
                HandleResult.deleteDataFailed.messageHUD
                
            } else {
                
                HandleResult.deleteDataSuccessed.messageHUD
                
            }
            
        }
    }
    
}
