//
//  WeatherCoreDataDataSource.swift
//  WeatherAppSwiftUI
//
//  Created by Lior.Avraham on 17/02/2026.
//

import Foundation
import CoreData

// Core Data implementation of the WeatherLocalDataSource.
// Responsible for persisting and retrieving Weather domain models
final class WeatherCoreDataDataSource: WeatherLocalDataSource {

    private let persistence: PersistenceController

    init(persistence: PersistenceController = .shared) {
        self.persistence = persistence
    }

    // MARK: - Save

    func saveWeather(_ weather: Weather) async throws {
        try await saveWeathers([weather])
    }

    func saveWeathers(_ weathers: [Weather]) async throws {

        // Writes should always be done on a background context
        let context = persistence.container.newBackgroundContext()
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy

        try await context.perform {

            for weather in weathers {
                let entity = try self.upsert(weather: weather, in: context)
                entity.lastUpdated = Date()
            }

            if context.hasChanges {
                try context.save()
            }
        }
    }

    // MARK: - Fetch

    func fetchWeather(cityName: String) async throws -> Weather? {
        let results = try await fetchWeathers(cityNames: [cityName])
        return results.first
    }

    func fetchWeathers(cityNames: [String]) async throws -> [Weather] {

        // Reads can safely use viewContext
        let context = persistence.container.viewContext

        return try await context.perform {

            let request: NSFetchRequest<WeatherEntity> = WeatherEntity.fetchRequest()
            request.predicate = NSPredicate(format: "cityName IN %@", cityNames)
            request.sortDescriptors = [
                NSSortDescriptor(key: "cityName", ascending: true)
            ]

            let entities = try context.fetch(request)
            return entities.map { $0.toWeather() }
        }
    }

    // MARK: - Delete

    func deleteAll() async throws {

        let context = persistence.container.newBackgroundContext()

        try await context.perform {

            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = WeatherEntity.fetchRequest()
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            deleteRequest.resultType = .resultTypeObjectIDs

            let result = try context.execute(deleteRequest) as? NSBatchDeleteResult

            // Important: merge deletions into viewContext
            if let objectIDs = result?.result as? [NSManagedObjectID] {
                let changes: [AnyHashable: Any] = [
                    NSDeletedObjectsKey: objectIDs
                ]

                NSManagedObjectContext.mergeChanges(
                    fromRemoteContextSave: changes,
                    into: [self.persistence.container.viewContext]
                )
            }
        }
    }

    // MARK: - Upsert

    private func upsert(weather: Weather,
                        in context: NSManagedObjectContext) throws -> WeatherEntity {

        let request: NSFetchRequest<WeatherEntity> = WeatherEntity.fetchRequest()
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "cityName == %@", weather.cityName)

        if let existing = try context.fetch(request).first {
            existing.update(from: weather)
            return existing
        } else {
            let newEntity = WeatherEntity(context: context)
            newEntity.update(from: weather)
            return newEntity
        }
    }
}
