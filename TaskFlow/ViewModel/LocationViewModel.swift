//
//  LocationViewModel.swift
//  TaskFlow
//
//  Created by İrem Sever on 31.10.2025.
//


import SwiftUI
import CoreLocation
import Combine
@MainActor
final class LocationViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var latitude: Double?
    @Published var longitude: Double?
    @Published var statusText: String = "Bilinmiyor"

    private let manager = CLLocationManager()

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        refreshStatus()
    }

    func request() {
        if CLLocationManager.locationServicesEnabled() {
            switch manager.authorizationStatus {
            case .notDetermined:
                manager.requestWhenInUseAuthorization()
            case .authorizedWhenInUse, .authorizedAlways:
                manager.startUpdatingLocation()
            case .denied, .restricted:
                break
            @unknown default: break
            }
        }
        refreshStatus()
    }

    func stop() { manager.stopUpdatingLocation() }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        refreshStatus()
        if manager.authorizationStatus == .authorizedWhenInUse || manager.authorizationStatus == .authorizedAlways {
            manager.startUpdatingLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let last = locations.last else { return }
        latitude  = last.coordinate.latitude
        longitude = last.coordinate.longitude
        refreshStatus()
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        statusText = "Konum alınamadı: \(error.localizedDescription)"
    }

    private func refreshStatus() {
        let auth: CLAuthorizationStatus = manager.authorizationStatus
        let gpsOn = CLLocationManager.locationServicesEnabled()
        let authText: String = switch auth {
            case .authorizedAlways, .authorizedWhenInUse: "Konum izinleri açık"
            case .denied: "Konum izni kapalı"
            case .restricted: "Konum kısıtlı"
            case .notDetermined: "İzin sorulmadı"
            @unknown default: "Bilinmiyor"
        }
        statusText = "\(authText) • GPS \(gpsOn ? "aktif" : "pasif")"
    }
}
