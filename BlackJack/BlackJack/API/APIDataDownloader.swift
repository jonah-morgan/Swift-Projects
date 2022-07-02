//
//  APICommunicator.swift
//  BlackJack
//
//  Created by Jonah Morgan on 6/30/22.
//

import SwiftUI


struct APIDataDownloader<T: Codable> {
    let url: String
    init(withUrl url: String) {
        self.url = url
    }

    func getData(completionBlock: @escaping (T) -> Void) {

        let task = URLSession.shared.dataTask(with: URL(string: url)!) { data, response, error in
            guard let data = data, error == nil else {
                print("Error fetching data from Server")
                return
            }

            var result: T?
            do {
                try result = JSONDecoder().decode(T.self, from: data)
                completionBlock(result!)
            } catch {
                print("Failed to convert \(error.localizedDescription)")
            }
        }
        task.resume()
    }
}


struct APIImageDownloader{
    let url: String
    init(withUrl url: String) {
        self.url = url
    }

    func getData(completionBlock: @escaping (UIImage) -> Void) {

        let task = URLSession.shared.dataTask(with: URL(string: url)!) { data, response, error in
            guard let data = data, error == nil else {
                print("Error fetching data from Server")
                return
            }
            let result = UIImage(data: data)
            completionBlock(result!)
        }
        task.resume()
    }

}
