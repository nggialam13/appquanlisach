
import Foundation
import FirebaseAuth
import FirebaseFirestore

class RegisterController {

    private let db = Firestore.firestore()

    func register(
        email: String,
        password: String,
        completion: @escaping (Result<User, Error>) -> Void
    ) {

        Auth.auth().createUser(
            withEmail: email,
            password: password
        ) { [weak self] result, error in

            if let error = error {
                completion(.failure(error))
                return
            }

            guard let firebaseUser = result?.user else {
                return
            }

            self?.db.collection("UserS")
                .document(firebaseUser.uid)
                .setData([
                    "id": firebaseUser.uid,
                    "name": "",
                    "email": email,
                    "role": "user"
                ]) { error in

                    if let error = error {
                        completion(.failure(error))
                        return
                    }

                    completion(.success(firebaseUser))
                }
        }
    }
}
