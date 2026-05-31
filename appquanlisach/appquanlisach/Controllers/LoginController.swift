import Foundation
import FirebaseAuth

class LoginController {

    func login(
        email: String,
        password: String,
        completion: @escaping (Result<Users, Error>) -> Void
    ) {

        Auth.auth().signIn(
            withEmail: email,
            password: password
        ) { result, error in

            if let error = error {
                completion(.failure(error))
                return
            }

            guard let firebaseUser = result?.user else {
                return
            }

            let user = Users(
                id: firebaseUser.uid,
                name: "",
                email: firebaseUser.email ?? "",
                role: "user"
            )

            completion(.success(user))
        }
    }
}
