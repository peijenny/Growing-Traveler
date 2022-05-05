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
    
    func fetchUsersData(completion: @escaping (Result<[UserInfo]>) -> Void) {
        
        var usersInfo: [UserInfo] = []
        
        database.getDocuments { snapshot, error in
            
            guard let snapshot = snapshot else {
                
                print("Error fetching document: \(error!)")
                
                completion(Result.failure(error!))
                
                return
                
            }
            
            for document in snapshot.documents {
                
                do {
                    
                    if let userInfo = try document.data(as: UserInfo.self, decoder: Firestore.Decoder()) {
                        
                        usersInfo.append(userInfo)
                        
                    }
                    
                } catch {
                    
                    print(error)
                    
                    completion(Result.failure(error))

                }
                
            }
            
            completion(Result.success(usersInfo))
            
        }
        
    }
    
    func fetchData(fetchUserID: String, completion: @escaping (Result<UserInfo>) -> Void) {
        
        database.document(fetchUserID).getDocument { snapshot, error in
            
            guard let snapshot = snapshot else {
                
                print("Error fetching document: \(error!)")
                
                completion(Result.failure(error!))
                
                return
                
            }

            do {
                
                if let user = try snapshot.data(as: UserInfo.self, decoder: Firestore.Decoder()) {
                    
                    completion(Result.success(user))
                    
                }
                
            } catch {
                
                print(error)
                
                completion(Result.failure(error))
                
            }
            
        }
        
    }
    
    func listenData(completion: @escaping (Result<UserInfo>) -> Void) {
        
        if userID != "" {
            
            database.document(userID).addSnapshotListener { snapshot, error in
                
                guard let snapshot = snapshot else {
                    
                    print("Error fetching document: \(error!)")
                    
                    completion(Result.failure(error!))
                    
                    return
                    
                }
  
                do {
                    
                    if let user = try snapshot.data(as: UserInfo.self, decoder: Firestore.Decoder()) {
                        
                        completion(Result.success(user))
                        
                    }
                    
                } catch {
                    
                    print(error)
                    
                    completion(Result.failure(error))
                    
                }
                
            }
            
        }
        
    }
    
    func updateData(user: UserInfo) {
        
        do {
            
            if userID != "" {
                
                // 修改 使用者資料
                try database.document(userID).setData(from: user, merge: true)
                
            }
            
        } catch {

            print(error)

        }
        
    }
    
    func addData(user: UserInfo) {
        
        do {
            
            // 新增使用者帳號
            try database.document(user.userID).setData(from: user, merge: true)
            
        } catch {

            print(error)

        }
        
    }
    
    func fetchshareNoteData(shareUserID: String, noteID: String, completion: @escaping (Result<Note>) -> Void) {
        
        database.document(shareUserID).collection("note")
            .whereField("noteID", isEqualTo: noteID)
            .getDocuments { snapshot, error in
            
            guard let snapshot = snapshot else {
                
                print("Error fetching document: \(error!)")
                
                completion(Result.failure(error!))
                
                return
                
            }

            do {
                
                if let note = try snapshot.documents[0].data(as: Note.self, decoder: Firestore.Decoder()) {
                    
                    completion(Result.success(note))
                    
                }
                
            } catch {
                
                print(error)
                
                completion(Result.failure(error))
                
            }
            
        }
        
    }
    
    func fetchUserNoteData(completion: @escaping (Result<[Note]>) -> Void) {
        
        database.document(userID).collection("note")
            .getDocuments { snapshot, error in
            
            var notes: [Note] = []
            
            guard let snapshot = snapshot else {
                
                print("Error fetching document: \(error!)")
                
                return
                
            }
            
            for document in snapshot.documents {
                
                do {
                    
                    if let note = try document.data(as: Note.self, decoder: Firestore.Decoder()) {
                        
                        notes.append(note)
                        
                    }
                    
                } catch {
                    
                    print(error)
                    
                    completion(Result.failure(error))

                }
                
            }
            
            completion(Result.success(notes))
            
        }
        
    }
    
    func updateUserNoteData(note: Note) {
     
        do {
            
            try database.document(userID).collection("note")
                .document(note.noteID).setData(from: note, merge: true)
            
        } catch {

            print(error)

        }
        
    }
    
    func deleteUserNoteData(note: Note) {
        
        database.document(userID).collection("note")
        .document(note.noteID).delete { error in
            
            if let error = error {
                
                print(error)
                
            } else {
                
                print("Success")
            }
            
        }
    }
    
}
