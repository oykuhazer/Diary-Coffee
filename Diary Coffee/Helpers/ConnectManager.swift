//
//  ConnectManager.swift
//  Diary Coffee
//
//  Created by Öykü Hazer Ekinci on 12.01.2025.
//

import Foundation
import Network
import UIKit

class ConnectManager {
    private let monitor: NWPathMonitor
    private let queue: DispatchQueue
    private weak var mainWindow: UIWindow?
    private var disconnectView: DisconnectView?

    init(mainWindow: UIWindow) {
        monitor = NWPathMonitor()
        queue = DispatchQueue(label: "NetworkMonitorQueue")
        self.mainWindow = mainWindow
    }

    func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                if path.status == .satisfied {
                    self?.hideDisconnectView()
                } else {
                    self?.showDisconnectView()
                }
            }
        }
        monitor.start(queue: queue)
    }

    func stopMonitoring() {
        monitor.cancel()
    }
    
    func isConnected() -> Bool {
        return monitor.currentPath.status == .satisfied
    }

    private func showDisconnectView() {
        guard disconnectView == nil, let mainWindow = mainWindow else { return }

        let disconnectView = DisconnectView(frame: mainWindow.bounds)
        disconnectView.disconnectButton.addTarget(self, action: #selector(retryConnection), for: .touchUpInside)
        disconnectView.translatesAutoresizingMaskIntoConstraints = false
        mainWindow.addSubview(disconnectView)

        NSLayoutConstraint.activate([
            disconnectView.leadingAnchor.constraint(equalTo: mainWindow.leadingAnchor),
            disconnectView.trailingAnchor.constraint(equalTo: mainWindow.trailingAnchor),
            disconnectView.topAnchor.constraint(equalTo: mainWindow.topAnchor),
            disconnectView.bottomAnchor.constraint(equalTo: mainWindow.bottomAnchor)
        ])

        self.disconnectView = disconnectView
    }

    private func hideDisconnectView() {
        disconnectView?.removeFromSuperview()
        disconnectView = nil 
    }

    @objc private func retryConnection() {
        hideDisconnectView()
        DispatchQueue.main.asyncAfter(deadline: .now()) { [weak self] in
            guard let self = self else { return }
            if !self.isConnected() {
                self.showDisconnectView() 
            }
        }
    }
}
