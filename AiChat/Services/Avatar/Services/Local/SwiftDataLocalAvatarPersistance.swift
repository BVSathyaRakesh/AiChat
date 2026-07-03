//
//  SwiftDataLocalAvatarPersistence.swift
//  AiChat
//
//  Created by Sathya Kumar on 02/07/26.
//
import SwiftData
import SwiftUI

struct SwiftDataLocalAvatarPersistence: LocalAvatarPersistence {
    
    let container: ModelContainer
    private var maincontext: ModelContext {
        container.mainContext
    }
    
    init() {
        // swiftlint:disable:next force_try
        self.container = try! ModelContainer(for: AvatarEntity.self)
    }
    
    func addRecentAvatar(avatarModel: AvatarModal) throws {
        let entity = AvatarEntity(from: avatarModel)
        maincontext.insert(entity)
        try maincontext.save()
    }
    
    func getRecentAvtars() throws -> [AvatarModal] {
        let fetchtrequest = FetchDescriptor<AvatarEntity>(sortBy: [SortDescriptor(\.dateAdded, order: .reverse)])
        let entities = try maincontext.fetch(fetchtrequest)
        return entities.map({$0.toModel()})
    }
    
}
