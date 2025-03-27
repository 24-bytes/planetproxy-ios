//
//  AnalyticsManager.swift
//  ios
//
//  Created by Siddhant Kundlik Thaware on 26/03/25.
//

import Foundation
import FirebaseAnalytics
import FirebaseCrashlytics
import Mixpanel

struct EventName {
    struct VIEW {
        static let ACCOUNT_INFORMATION = "view_account_information"
        static let PAYMENT_SUCCESS = "view_payment_success"
        static let SETTINGS_SCREEN = "view_settings_screen"
        static let SERVERS_SCREEN = "view_servers_screen"
        static let DASHBOARD_SCREEN = "view_dashboard_screen"
        static let SIGN_UP_SCREEN = "view_sign_up_screen"
        static let CUSTOMER_SUPPORT_SCREEN = "view_customer_support"
        static let SIGN_IN_SCREEN = "view_sign_in_screen"
        static let SUBSCRIPTION_SCREEN = "view_subscription"
        static let CHECKOUT_SCREEN = "view_checkout_screen"
        static let SUBSCRIPTION_LIST_SCREEN = "view_sub_list"
        static let FAQ = "view_faq"
        static let PAYMENT_FAILURE = "view_payment_failure"
        static let PAYMENT_REDIRECTION = "view_payment_redirection"
        static let NO_INTERNET = "view_no_internet"
    }

    struct TAP {
        static let DASHBOARD_NAV_MENU = "tap_dashboard_nav_menu"
        static let FAQ = "tap_faq"
        static let ACCOUNT_INFORMATION = "tap_account_information"
        static let CUSTOMER_SUPPORT = "tap_customer_support"
        static let VPN_CONNECT = "tap_vpn_connect"
        static let VPN_DISCONNECT = "tap_vpn_disconnect"
        static let VIEW_SERVERS = "tap_view_servers"
        static let SERVER_CHANGE = "tap_server_change"
        static let LOGOUT = "tap_logout"
        static let DASHBOARD_SUBSCRIPTION_DETAILS = "tap_dashboard_sub_details"
        static let SIGNUP_CREATE_ACCOUNT = "tap_signup_create_account"
        static let SIGNUP_GOOGLE = "tap_signup_google"
        static let SIGNIN = "tap_signup_signin"
        static let DASHBOARD_NAV_LOGIN = "tap_dashboard_nav_login"
        static let DASHBOARD_NAV_SETTINGS = "tap_dashboard_nav_settings"
        static let DASHBOARD_NAV_RATE_US = "tap_dashboard_nav_rate_us"
        static let DASHBOARD_NAV_PRIVACY_POLICY = "tap_dashboard_nav_privacy"
        static let DASHBOARD_NAV_PRIVACY_TERMS = "tap_dashboard_nav_terms"
    }

    struct CHANGE {
        static let VPN_CONFIG = "change_vpn_config"
    }

    struct ON {
        static let VPN_MONITORING_CANCELLED = "on_vpn_monitoring_cancelled"
        static let VPN_MONITORING_ERROR = "on_vpn_monitoring_error"
        static let VPN_DISCONNECT = "on_vpn_disconnect"
        static let SERVERS_LOADED = "on_servers_loaded"
        static let VPN_ERROR_AFTER_CONNECTING = "on_vpn_error_after_connecting"
        static let REQUEST_NOTIFICATION_PERM = "on_request_notification_perm"
        static let REQUEST_VPN_PERM = "on_request_vpn_perm"
        static let VPN_ALWAYS_ON = "on_vpn_always_on"
        static let VPN_CONNECTION_TIMEOUT = "on_vpn_connection_timeout"
        static let REQUEST_REWARDED_AD = "on_request_rewarded_ad"
        static let REQUEST_INTERSTITIAL_AD = "on_request_interstitial_ad"
        static let VPN_CONNECTED = "on_vpn_connected"
        static let VPN_FAILED = "on_vpn_failed"
        static let VPN_PEER_FAILED = "on_vpn_peer_failed"
        static let VPN_CONFIG_FAILED = "on_vpn_config_failed"
        static let VPN_CONFIG_LOADED = "on_vpn_config_loaded"
        static let ON_USER_AUTHENTICATED = "on_user_authenticated"
    }

    struct MEASURE {
        static let VPN_CONFIG_FETCH = "measure_vpn_config_fetch"
        static let VPN_CONNECTION = "measure_vpn_connection"
        static let VPN_SERVERS = "measure_vpn_servers"
    }
}

class AnalyticsManager {
    static let shared = AnalyticsManager()

    func trackEvent(_ eventName: String, parameters: [String: Any]? = nil) {
        print("ANALYTICS EVENT TRIGGER: \(eventName)")
        Analytics.logEvent(eventName, parameters: parameters)
       
        let mixpanelParams = parameters?.compactMapValues { $0 as? MixpanelType } ?? [:]

       Mixpanel.mainInstance().track(event: eventName, properties: mixpanelParams)
    }

    func startTimeEvent(_ eventName: String) {
        print("ANALYTICS EVENT STARTED: \(eventName)")
        Analytics.logEvent("\(eventName)_start", parameters: nil)
        Mixpanel.mainInstance().time(event: eventName)
    }

    func endTimeEvent(_ eventName: String, parameters: [String: Any]? = nil) {
        print("ANALYTICS EVENT ENDED: \(eventName)")
        Analytics.logEvent("\(eventName)_end", parameters: parameters)
        
        let mixpanelParams = parameters?.compactMapValues { $0 as? MixpanelType } ?? [:]

       Mixpanel.mainInstance().track(event: eventName, properties: mixpanelParams)
    }

    func setUser(userId: String?, email: String?, name: String?) {
        guard let userId = userId else { return }

        Analytics.setUserID(userId)
        Analytics.setUserProperty(email, forName: "email")
        Analytics.setUserProperty(name, forName: "name")
        Crashlytics.crashlytics().setUserID(userId)

        let mixpanel = Mixpanel.mainInstance()
        mixpanel.identify(distinctId: userId)
        mixpanel.people.set(properties: [
            "userId": userId,
            "Email": email ?? "",
            "Name": name ?? ""
        ])

        print("User set: ID=\(userId), Email=\(email ?? "N/A"), Name=\(name ?? "N/A")")
    }

    func reset() {
        Analytics.resetAnalyticsData()
        Mixpanel.mainInstance().reset()
        print("Analytics data reset")
    }
}
