import SwiftUI
import Combine
enum EMethodsToastify {
    case append( _ toast: ToastValue)
    case position(position: ToastPosition)
    static var `pub` = NotificationCenter.default.publisher(for: Notification.Name(rawValue: "com.toastify"))
    static var `pubReceive`: AnyPublisher<EMethodsToastify, Never> {
         NotificationCenter.default.publisher(for: Notification.Name(rawValue: "com.toastify"))
             .compactMap { $0.object as? EMethodsToastify }
             .eraseToAnyPublisher()
     }
    static func notify(value: EMethodsToastify) {
        EMethodsToastify.pub.center.post(name: NSNotification.Name(rawValue: "com.toastify"), object: value)
    }
}
