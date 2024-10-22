//
//  User.swift
//  AetherFlow
//
//  Created by Christina Tu on 2024/9/27.
//

import JWTDecode

/// Represents a user with basic details such as ID, name, email, and profile picture.
///
/// The `User` struct is designed to store user information decoded from a JWT (JSON Web Token).
/// It includes fields such as the user's ID, name, email, and profile picture, as well as details like whether the email is verified
/// and the last update timestamp.
struct User {
    let id: String
    let name: String
    let email: String
    let emailVerified: String
    let picture: String
    let updatedAt: String
}

extension User {
    /// Provides an empty `User` object with default empty values for all properties.
    ///
    /// This is useful as a fallback when user data is unavailable or could not be decoded.
    static var empty: Self {
        return User(
            id: "",
            name: "",
            email: "",
            emailVerified: "",
            picture: "",
            updatedAt: ""
        )
    }

    /// Provides a preview `User` object with mock data for UI previews.
    static var preview: Self {
        return User(
            id: "luke",
            name: "Luke",
            email: "luke@gmail.com",
            emailVerified: "",
            picture: "",
            updatedAt: ""
        )
    }

    /// Creates a `User` object from a given ID token by decoding the token and extracting relevant claims.
    ///
    /// The function decodes the JWT token and extracts claims such as:
    /// - `sub` (subject) for user ID
    /// - `name` for the user's full name
    /// - `email` for the user's email address
    /// - `email_verified` for whether the email is verified
    /// - `picture` for the user's profile picture URL
    /// - `updated_at` for the timestamp of the last user data update
    ///
    /// If decoding fails or any required claims are missing, it returns an empty `User` object.
    ///
    /// - Parameter idToken: A JWT string containing the user's authentication information.
    /// - Returns: A `User` object populated with the data from the token, or an empty `User` object if decoding fails.
    static func from(_ idToken: String) -> Self {
        guard
            let jwt = try? decode(jwt: idToken),
            let id = jwt.subject,
            let name = jwt.claim(name: "name").string,
            let email = jwt.claim(name: "email").string,
            let emailVerified = jwt.claim(name: "email_verified").boolean,
            let picture = jwt.claim(name: "picture").string,
            let updatedAt = jwt.claim(name: "updated_at").string
        else {
            return .empty
        }
        
        return User(
            id: id,
            name: name,
            email: email,
            emailVerified: String(describing: emailVerified),
            picture: picture,
            updatedAt: updatedAt
        )
    }
}
