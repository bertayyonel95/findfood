//
//  FirebaseAuthManager.swift
//  findfood
//
//  Created by Bertay Yönel on 22.03.2023.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore

// MARK: - FirebaseAuthManagerDelegate
protocol FirebaseAuthManagerDelegate: AnyObject {
    func onSuccessfulSingUp()
    func onSuccessfulLogIn()
    func onError(errorMessage: String)
}
// MARK: - FirebaseManager
class FirebaseManager {
    // MARK: Properties
    var delegate: FirebaseAuthManagerDelegate?
    var database = Firestore.firestore()
    var user: User?
    // MARK: Private Properties
    private var likedLocations: [String] = []
    // MARK: Class init and singleton decleration
    private init() {
        if self.userExists() {
            self.getCurrentUser()
            self.getFavouritesFromUser()
        }
    }
    static let shared = FirebaseManager()
    // MARK: Class functions
    /// Creates a new user with e-mail and password information.
    ///
    /// - Parameters:
    ///    - withEmail: e-mail to be used in the creation of a user.
    ///    - withPassword: password to be used in the creation of a user.
    func userSignUp(withEmail: String, withPassword: String) {
        Auth.auth().createUser(withEmail: withEmail, password: withPassword) { authResult, error in
            if error != nil {
                let errorCode = AuthErrorCode(_nsError: error! as NSError)
                self.errorHandling(errorCode: errorCode)
            } else {
                self.addUserToDatabase(userID: authResult?.user.uid ?? "")
                self.delegate?.onSuccessfulSingUp()
                self.userSignIn(withEmail: withEmail, withPassword: withPassword)
                self.getCurrentUser()
                self.getFavouritesFromUser()
            }
        }
    }
    /// Logs in the user with the given e-mail and password
    ///
    /// - Parameters:
    ///    - withEmail: e-maill to be used for login.
    ///    - withPassword: password to be used for login.
    func userSignIn(withEmail email: String, withPassword password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { _, error in
            if error != nil {
                let nsError = error as? NSError
                let errorCode = AuthErrorCode(_nsError: nsError ?? NSError())
                self.errorHandling(errorCode: errorCode)
            } else {
                self.getCurrentUser()
                self.getFavouritesFromUser()
                self.delegate?.onSuccessfulLogIn()
            }
        }
    }
    /// Logs the user out.
    func userSignOut() {
        do {
            try Auth.auth().signOut()
            let observerValue = ObserverManager.shared.favouriteStatusChanged.value
            ObserverManager.shared.changeStatus(for: ObserverManager.shared.favouriteStatusChanged, with: !observerValue)
            self.clearData()
        } catch let signOutError as NSError {
            self.delegate?.onError(errorMessage: signOutError.localizedDescription)
        }
    }
    /// Creates a personlized error message according to the error.
    ///
    /// - Parameters:
    ///    - errorCode: contains the description of the error.
    func errorHandling(errorCode: AuthErrorCode) {
        self.delegate?.onError(errorMessage: errorCode.localizedDescription)
    }
    /// Checks if the given location is liked by the user.
    ///
    /// - Parameters:
    ///    - locationID: location to be checked whether it is liked or not.
    ///
    /// - Returns: a boolean to identify if a location is liked.
    func isLocationLiked(locationID: String) -> Bool {
        if !self.userExists() {
            return false
        } else {
            return likedLocations.contains(locationID)
        }
    }
    /// Adds the user to the database and creates an appropiate document.
    ///
    /// - Parameters:
    ///    - userID: ID of the user to be added to database.
    func addUserToDatabase(userID: String) {
        let docRef = database.collection("/users/")
        docRef.document(userID).setData(["doc_desc": "User ID"])
    }
    /// Updates the likedLocations array with the current signed in users favourites.
    func getFavouritesFromUser() {
        LoadingManager.shared.show()
        var likedLocations: [String] = []
        guard let user = Auth.auth().currentUser else {
            LoadingManager.shared.hide()
            return
        }
        let docRef = database.collection("/users/" + user.uid + "/favourites/")
        docRef.getDocuments(completion: { (querySnapshot, err) in
            LoadingManager.shared.hide()
            for document in querySnapshot!.documents {
                if !likedLocations.contains(document.documentID) {
                    likedLocations.append(document.documentID)
                }
            }
            self.likedLocations = likedLocations
            ObserverManager.shared.changeStatus(for: ObserverManager.shared.favouriteStatusChanged, with: !ObserverManager.shared.favouriteStatusChanged.value)
        })
    }
    /// Returns the liked locations by the current signed in user.
    ///
    /// - Returns: A string array that holds the favourite locations of the user.
    func returnLikedLocations() -> [String] {
        return likedLocations
    }
    /// Assigns the user to be the current user.
    func getCurrentUser() {
        guard let user = Auth.auth().currentUser else {
            return
        }
        self.user = user
    }
    /// Adds a location to user's favourites.
    ///
    /// - Parameters:
    ///    - locationID: ID of the location that the user wants to add to favourite.
    func likeLocation(locationID: String) {
        guard let user = Auth.auth().currentUser else {
            return
        }
        let userRef = database.document("/users/" + user.uid)
        userRef.collection("favourites").document(locationID).setData(["doc_desc": "fav_id"])
        self.getFavouritesFromUser()
    }
    /// Removes a location from user's favourites.
    ///
    /// - Parameters:
    ///    - locationID: ID of the location that the user wants to remove from favourites.
    func dislikeLocation(locationID: String) {
        guard let user = Auth.auth().currentUser else {
            return
        }
        let userRef = database.document("/users/" + user.uid)
        userRef.collection("favourites").document(locationID).delete()
        self.getFavouritesFromUser()
    }
    /// Checks if there is a user logged in.
    ///
    /// - Returns: A boolean according to the existence of a user.
    func userExists() -> Bool {
        if Auth.auth().currentUser != nil {
            return true
        } else {
            return false
        }
    }
    /// Clears data held in the FirebaseManager singleton to be reused.
    func clearData() {
        self.user = nil
        self.likedLocations = []
    }
}
