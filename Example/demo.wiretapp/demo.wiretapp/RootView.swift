import Combine
import Foundation
import SwiftUI

struct Todo: Decodable {
    let title: String
    let completed: Bool
}

struct User: Decodable {
    let id: Int
    let name: String
    let username: String
    let email: String
    let phone: String
}

struct RootView: View {
    @State var cancellable: AnyCancellable!
    @State var users: [User] = []
    let networkService: NetworkService

    var body: some View {
        TabView {
            if users.count == 0 {
                Text("Loading Users..")
            } else {
                PostsView(networkService: networkService, users: users)
                    .tabItem {
                        Label("Posts", systemImage: "list.bullet.circle")
                    }

                UsersView()
                    .tabItem {
                        Label("Users", systemImage: "person.3.fill")
                    }
            }
            
        }.onAppear {
            self.cancellable = networkService.get(
                url: URL(string: "https://jsonplaceholder.typicode.com/users")!,
                modelType: [User].self
            )
            .receive(on: DispatchQueue.main)
            .sink {
                print($0)
            } receiveValue: {
                users = $0
            }
        }
    }
}

