//
//  CoreDataService.swift
//  UkrZoloto
//
//  Created by Andrew Koshkin on 10/24/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit
import CoreData

class CoreDataService {
  
  // MARK: - Singleton
  static let shared = CoreDataService()
  
  // MARK: - Private variables
  private let storeName = "UkrZoloto"
  
  private lazy var persistentContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: storeName)
    container.loadPersistentStores(completionHandler: { (_, error) in
      if let error = error as NSError? {
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    })
    return container
  }()
  
  private var context: NSManagedObjectContext {
    return persistentContainer.viewContext
  }
  
  // MARK: - Life cycle
  private init() { }
}

// MARK: - Public
extension CoreDataService {
  // MARK: - User
  func fetchUser() -> User? {
    let fetchRequest: NSFetchRequest<UserMO> = UserMO.fetchRequest()
    guard let userMO = (try? context.fetch(fetchRequest))?.first else { return nil }
    return User(userMO: userMO)
  }
  
  func save(user: User,
            completion: @escaping (Result<Any?>) -> Void) {
    persistentContainer.performBackgroundTask { context in
      do {
        let userMO = self.fetchOrCreateUserMO(in: context)
        userMO.fill(from: user, in: context)
        try context.save()
        completion(.success(nil))
      } catch let error {
        completion(.failure(error))
      }
    }
  }
  
  func clearUserData(completion: @escaping (Bool) -> Void) {
    persistentContainer.performBackgroundTask { context in
      do {
        self.deleteAllUsers(in: context)
        try context.save()
        completion(true)
      } catch {
        completion(false)
      }
    }
  }
  
}

// MARK: - Private
private extension CoreDataService {
  private func fetchOrCreateUserMO(in context: NSManagedObjectContext) -> UserMO {
    let fetchRequest: NSFetchRequest<UserMO> = UserMO.fetchRequest()
    guard let fetchedUserMO = (try? context.fetch(fetchRequest))?.first else {
      return UserMO(context: context)
    }
    return fetchedUserMO
  }
  
  private func deleteAllUsers(in context: NSManagedObjectContext) {
    let fetchRequest: NSFetchRequest<UserMO> = UserMO.fetchRequest()
    (try? context.fetch(fetchRequest))?.forEach { context.delete($0) }
  }
}
