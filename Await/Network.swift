//
//  Network.swift
//  Await
//
//  Created by Julio-Ernest Costache on 11.08.2022.
//

import Foundation
struct Network {
    enum FoodFetchError: Error {
        case invalidURL
        case missingData
        case statusCodeNot200
    }
    func getRandomFoodWithCompletionHandles(url: String, completionHandler: @escaping (Result<Food, Error>) -> Void) {
        guard let url =  URL(string: url) else {
            completionHandler(.failure(FoodFetchError.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completionHandler(.failure(error))
                return
            }
            guard(response as? HTTPURLResponse)?.statusCode == 200 else {
                completionHandler(.failure(FoodFetchError.statusCodeNot200))
                return
            }
            guard let data = data else {
                completionHandler(.failure(FoodFetchError.missingData))
                return
            }
            do {
                let decodedFood = try JSONDecoder().decode(Food.self, from: data)
                completionHandler(.success(decodedFood))
            } catch {
                completionHandler(.failure(error))
            }
            
        }.resume()
    }
    func getRandomFood(url: String) async throws -> Food {
        guard let url = URL(string: url) else {
            throw FoodFetchError.invalidURL
        }
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard(response as? HTTPURLResponse)?.statusCode == 200 else {
            throw FoodFetchError.statusCodeNot200
        }
        let decodedFood = try JSONDecoder().decode(Food.self, from: data)
        return decodedFood
    }
}

