import Foundation

enum NetworkError: Error {
    case noInternet
    case serverError
}

class NetworkManager {
    static let shared = NetworkManager()

    func fetchData(completion: @escaping (Result<Data, NetworkError>) -> Void) {
        guard let url = URL(string: "https://example.com/api") else { return }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let _ = error {
                completion(.failure(.noInternet))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode),
                  let data = data else {
                completion(.failure(.serverError))
                return
            }

            completion(.success(data))
        }
        task.resume()
    }
}
