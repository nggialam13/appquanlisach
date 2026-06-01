import Foundation

class FavoriteManager {

    static let shared = FavoriteManager()

    private init() {}

    var favoriteBooks: [Book] = []
}
