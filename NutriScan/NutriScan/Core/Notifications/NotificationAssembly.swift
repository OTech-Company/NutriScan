//
//  NotificationAssembly.swift
//  NutriScan
//
//  Created by Ahmed Nageh on 01/08/2026.
//

import Foundation

struct NotificationAssembly: Assembly {
    func assemble(container: DIContainer) {
        
        let muteStore = NotificationMuteStore()
        container.register(
            type: NotificationMuteStoreProtocol.self,
            component: muteStore
        )

        container.register(
            type: NotificationServiceProtocol.self,
            component: NotificationService(
                muteStore: container.resolve(type: NotificationMuteStoreProtocol.self),
                historySaver: container.resolve(type: NotificationHistorySaving.self)
            )
        )
    }
}
