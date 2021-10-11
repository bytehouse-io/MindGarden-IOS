//
//  AnalyticEvent.swift
//  MindGarden
//
//  Created by Dante Kim on 10/7/21.
//

import Foundation

enum AnalyticEvent {
    //MARK: - Onboarding
    case screen_load_onboarding //
    case onboarding_tapped_continue //
    case onboarding_tapped_sign_in //
    //experience
    case screen_load_experience //
    case experience_tapped_none //
    case experience_tapped_some //
    case experience_tapped_alot //
    case experience_tapped_continue //
    //name
    case screen_load_name //
    case name_tapped_continue //
    //notification
    case screen_load_notification //
    case notification_tapped_done //
    case notification_tapped_turn_on //
    case notification_success //
    case notification_tapped_skip //
    // home + garden
    case onboarding_finished_mood //
    case onboarding_finished_gratitude //
    case onboarding_finished_meditation //
    case onboarding_finished_calendar //
    case onboarding_finished_stats //
    case onboarding_finished_single //
    case onboarding_finished_single_okay //

    //MARK: - Authentication
    case screen_load_onboarding_signup //
    case screen_load_onboarding_signin //
    case screen_load_signup //
    case screen_load_signin //
    case authentication_signin_successful //
    case authentication_signup_successful //
    case authentication_tapped_google //
    case authentication_tapped_apple //
    case authentication_tapped_forgot_password //

    //MARK: - Garden
    case screen_load_garden //
    case garden_next_month //
    case garden_previous_month //
    case garden_tapped_single_day //
    // left & right arrow in single day modal if present
    case garden_tapped_single_next_session //
    case garden_tapped_single_previous_session //

    //MARK: - HOME
    case screen_load_home //
    case home_tapped_plant_select //
    case home_selected_plant //
    case home_tapped_categories //
    case home_tapped_search //
    case home_tapped_recents //
    case home_tapped_favorites //
    case home_tapped_featured //
    case home_tapped_recent_meditation //
    case home_tapped_favorite_meditation //

    // bonus modal
    case home_tapped_bonus //
    case home_claim_daily //
    case home_claim_seven //
    case home_claim_thirty //

    //MARK: - Store
    case screen_load_store //
    case store_tapped_plant_tile //
    case store_tapped_purchase_modal_buy //
    case store_tapped_confirm_modal_confirm //
    case store_tapped_confirm_modal_cancel //
    case store_tapped_success_modal_okay //

    //MARK: - Middle
    case screen_load_middle //
    case middle_tapped_favorite //
    case middle_tapped_unfavorite
    case middle_tapped_back //
    case middle_tapped_recommended //
    case middle_tapped_row //
    case middle_tapped_row_favorite //
    case middle_tapped_row_unfavorite

    //MARK: - Play
    case screen_load_play //
    case play_tapped_back //
    case play_tapped_favorite //
    case play_tapped_unfavorite
    case play_tapped_sound //
    case play_tapped_sound_rain //
    case play_tapped_sound_night //
    case play_tapped_sound_beach //
    case play_tapped_sound_nature //
    case play_tapped_sound_fire //
    case play_tapped_sound_noSound //

    //MARK: - Finished
    case screen_load_finished //
    case finished_tapped_share //
    case finished_tapped_favorite //
    case finished_tapped_unfavorite
    case finished_tapped_finished //
    case finished_med_1_minute_meditation
    case finished_med_2_minute_meditation
    case finished_med_5_minute_meditation
    case finished_med_10_minute_meditation
    case finished_med_15_minute_meditation
    case finished_med_20_minute_meditation
    case finished_med_25_minute_meditation
    case finished_med_30_minute_meditation
    case finished_med_45_minute_meditation
    case finished_med_1_hour_meditation
    case finished_med_2_hour_meditation

    case finished_med_why_meditate
    case finished_med_create_your_anchor
    case finished_med_tuning_into_your_body
    case finished_med_gaining_clarity
    case finished_med_stress_antitode
    case finished_med_compassion_x_selflove
    case finished_med_joy_on_demand

    case finished_30_second_meditation
    case finished_basic_guided_meditation
    case finished_semguided_meditation
    case finished_meditation_for_focus
    case finished_anxiety_x_stress
    case finished_body_scan
    case finished_better_faster_sleep

    //MARK: - Profile
    case screen_load_profile //
    case profile_tapped_journey //
    case profile_tapped_settings //
    case profile_tapped_email //
    case profile_tapped_reddit //
    case profile_tapped_invite //
    case profile_tapped_notifications //
    case profile_tapped_instagram //
    case profile_tapped_restore //
    case profile_tapped_toggle_off_notifs //
    case profile_tapped_toggle_on_notifs //
    case profile_tapped_logout //

    //MARK: - Categories
    case screen_load_categories //
    case categories_tapped_unguided //
    case categories_tapped_all //
    case categories_tapped_courses //
    case categories_tapped_anxiety //
    case categories_tapped_focus //
    case categories_tapped_growth //
    case categories_tapped_meditation //
    case categories_tapped_sleep //
    case categories_tapped_confidence //

    //MARK: - tabs + plus
    case tabs_tapped_meditate //
    case tabs_tapped_garden //
    case tabs_tapped_store //
    case tabs_tapped_profile //
    case tabs_tapped_plus //
    //plus
    case plus_tapped_mood //
    //mood
    case mood_tapped_angry //
    case mood_tapped_sad //
    case mood_tapped_okay //
    case mood_tapped_happy //
    case mood_tapped_done //
    case mood_tapped_cancel
    //gratitude
    case plus_tapped_gratitude
    case gratitude_tapped_done // 
    case gratitude_tapped_cancel
    case gratitude_tapped_prompts

    case plus_tapped_meditate
}

extension AnalyticEvent {
    static func getSound(sound: Sound) -> AnalyticEvent {
        switch sound {
        case .beach:
            return .play_tapped_sound_beach
        case .fire:
            return .play_tapped_sound_fire
        case .rain:
            return .play_tapped_sound_rain
        case .night:
            return .play_tapped_sound_night
        case .noSound:
            return .play_tapped_sound_noSound
        case .nature:
            return .play_tapped_sound_nature
        }
    }
    static func getTab(tabName: String) -> AnalyticEvent {
        switch tabName {
        case "Garden":
            return .tabs_tapped_garden
        case "Meditate":
            return .tabs_tapped_meditate
        case "Shop":
            return .tabs_tapped_store
        case "Profile":
            return .tabs_tapped_profile
        default:
            return .tabs_tapped_meditate
        }
    }
    static func getCategory(category: String) -> AnalyticEvent {
        switch category {
        case "All": return .categories_tapped_all
        case "Unguided": return .categories_tapped_unguided
        case "Courses": return .categories_tapped_courses
        case "Anxiety": return .categories_tapped_anxiety
        case "Focus": return .categories_tapped_focus
        case "Sleep": return .categories_tapped_sleep
        case "Confidence": return .categories_tapped_confidence
        case "Growth": return .categories_tapped_growth
        default: return .categories_tapped_all
        }
    }
    static func getMeditation(meditation: String) -> AnalyticEvent {
        print("hong", meditation)
        switch meditation {
        case "finished_1_minute_meditation": return .finished_med_1_minute_meditation
        case "finished_2_minute_meditation": return .finished_med_2_minute_meditation
        case "finished_5_minute_meditation": return .finished_med_5_minute_meditation
        case "finished_10_minute_meditation": return .finished_med_10_minute_meditation
        case "finished_15_minute_meditation": return .finished_med_15_minute_meditation
        case "finished_20_minute_meditation": return .finished_med_20_minute_meditation
        case "finished_25_minute_meditation": return .finished_med_25_minute_meditation
        case "finished_30_minute_meditation": return .finished_med_30_minute_meditation
        case "finished_45_minute_meditation": return .finished_med_45_minute_meditation
        case "finished_1_hour_meditation": return .finished_med_1_hour_meditation
        case "finished_2_hour_meditation": return .finished_med_2_hour_meditation

        case "finished_why_meditate": return .finished_med_why_meditate
        case "finished_create_your_anchor": return .finished_med_create_your_anchor
        case "finished_tuning_into_your_body": return .finished_med_tuning_into_your_body
        case "finished_gaining_clarity": return .finished_med_gaining_clarity
        case "finished_stress_antitode": return .finished_med_stress_antitode
        case "finished_compassion_x_selflove": return .finished_med_compassion_x_selflove
        case "finished_joy_on_demand": return .finished_med_joy_on_demand

        case "finished_30_second_meditation": return .finished_30_second_meditation
        case "finished_basic_guided_meditation": return .finished_basic_guided_meditation
        case "finished_semguided_meditation": return .finished_semguided_meditation
        case "finished_meditation_for_focus": return .finished_meditation_for_focus
        case "finished_anxiety_x_stress": return .finished_anxiety_x_stress
        case "finished_body_scan": return .finished_body_scan
        case "finished_better_faster_sleep": return .finished_better_faster_sleep
        default: return .finished_med_1_minute_meditation
        }
    }
}

extension AnalyticEvent {
    var eventName:String {
        switch self {
        case .screen_load_onboarding: return "screen_load_onboarding"
        case .onboarding_tapped_continue: return "onboarding_tapped_continue"
        case .onboarding_tapped_sign_in: return "onboarding_tapped_sign_in"
        case .screen_load_experience: return "screen_load_experience"
        case .experience_tapped_none: return "experience_tapped_none"
        case .experience_tapped_some: return "experience_tapped_some"
        case .experience_tapped_alot: return "experience_tapped_alot"
        case .experience_tapped_continue: return "experience_tapped_continue"
        case .screen_load_name: return "screen_load_name"
        case .name_tapped_continue: return "name_tapped_continue"
        case .screen_load_notification: return "screen_load_notification"
        case .notification_tapped_done: return "notification_tapped_done"
        case .notification_tapped_turn_on: return "notifcation_tapped_turn_on"
        case .notification_success: return "notification_success"
        case .notification_tapped_skip: return "notification_tapped_skip"
        case .onboarding_finished_mood: return "onboarding_finished_mood"
        case .onboarding_finished_gratitude: return "onboarding_finished_meditation"
        case .onboarding_finished_meditation: return "onboarding_finished_meditation"
        case .onboarding_finished_calendar: return "onboarding_finished_calendar"
        case .onboarding_finished_stats: return "onboarding_finished_stats"
        case .onboarding_finished_single: return "onboarding_finshed_single"
        case .onboarding_finished_single_okay: return "onboarding_finshed_single_okay"
        case .screen_load_onboarding_signup: return "screen_load_onboarding_signup"
        case .screen_load_onboarding_signin:  return "screen_load_onboarding_signin:"
        case .screen_load_signup: return "screen_load_signup"
        case .screen_load_signin: return "screen_load_signin"
        case .authentication_signin_successful: return "authentication_signin_successful"
        case .authentication_signup_successful: return "authentication_signup_successful"
        case .authentication_tapped_google: return "authentication_tapped_google"
        case .authentication_tapped_apple:  return "authentication_tapped_apple"
        case .authentication_tapped_forgot_password: return "authentication_tapped_forgot_password"
        case .screen_load_garden: return "screen_load_garden"
        case .garden_next_month: return "garden_next_month"
        case .garden_previous_month: return "garden_previous_month"
        case .garden_tapped_single_day: return "garden_previous_month"
        case .garden_tapped_single_next_session: return "garden_tapped_single_next_session"
        case .garden_tapped_single_previous_session: return "garden_tapped_single_previous_session"
        case .screen_load_home: return "screen_load_home"
        case .home_tapped_plant_select: return "home_tapped_plant_select"
        case .home_selected_plant: return "home_selected_plant"
        case .home_tapped_categories: return "home_tapped_categories"
        case .home_tapped_search: return "home_tapped_search"
        case .home_tapped_recents: return "home_tapped_recents"
        case .home_tapped_favorites: return "home_tapped_favorites"
        case .home_tapped_featured: return "home_tapped_featured"
        case .home_tapped_recent_meditation: return "home_tapped_recent_meditation"
        case .home_tapped_favorite_meditation: return "home_tapped_favorite_meditation"
        case .home_tapped_bonus: return "home_tapped_bonus"
        case .home_claim_daily: return "home_claim_daily:"
        case .home_claim_seven: return "home_claim_seven"
        case .home_claim_thirty: return "home_claim_thirty"
        case .screen_load_store: return "screen_load_store"
        case .store_tapped_plant_tile: return "store_tapped_plant_tile"
        case .store_tapped_purchase_modal_buy: return "store_tapped_purchase_modal_buy"
        case .store_tapped_confirm_modal_confirm: return "store_tapped_confirm_modal_confirm"
        case .store_tapped_confirm_modal_cancel: return "store_tapped_confirm_modal_cancel"
        case .store_tapped_success_modal_okay: return "store_tapped_success_modal_okay"
        case .screen_load_middle: return "screen_load_middle"
        case .middle_tapped_favorite: return "middle_tapped_favorite"
        case .middle_tapped_unfavorite: return "middle_tapped_unfavorite"
        case .middle_tapped_back: return "middle_tapped_back"
        case .middle_tapped_recommended: return "middle_tapped_recommended"
        case .middle_tapped_row: return "middle_tapped_row"
        case .middle_tapped_row_favorite: return "middle_tapped_row_favorite"
        case .middle_tapped_row_unfavorite: return "middle_tapped_row_unfavorite"
        case .screen_load_play: return "screen_load_play"
        case .play_tapped_back: return "play_tapped_back"
        case .play_tapped_favorite: return "play_tapped_favorite"
        case .play_tapped_unfavorite: return "play_tapped_unfavorite"
        case .play_tapped_sound: return "play_tapped_sound"
        case .play_tapped_sound_rain: return "play_tapped_sound_rain"
        case .play_tapped_sound_night: return "play_tapped_sound_night"
        case .play_tapped_sound_nature: return "play_tapped_sound_nature"
        case .play_tapped_sound_fire: return "play_tapped_sound_fire"
        case .play_tapped_sound_noSound: return "play_tapped_sound_noSound"
        case .screen_load_finished: return "screen_load_finished"
        case .finished_tapped_share: return "finished_tapped_share"
        case .finished_tapped_favorite: return "finished_tapped_favorite"
        case .finished_tapped_unfavorite: return "finished_tapped_unfavorite"
        case .finished_tapped_finished: return "finished_tapped_finished"
        case .finished_med_1_minute_meditation:  return "finished_med_1_minute_meditation"
        case .finished_med_2_minute_meditation: return "finished_med_2_minute_meditation"
        case .finished_med_5_minute_meditation: return "finished_med_5_minute_meditation"
        case .finished_med_10_minute_meditation: return "finished_med_10_minute_meditation"
        case .finished_med_15_minute_meditation: return "finished_med_15_minute_meditation:"
        case .finished_med_20_minute_meditation: return "finished_med_20_minute_meditation"
        case .finished_med_25_minute_meditation: return "finished_med_25_minute_meditation"
        case .finished_med_30_minute_meditation: return "finished_med_30_minute_meditation"
        case .finished_med_45_minute_meditation: return "finished_med_45_minute_meditation"
        case .finished_med_1_hour_meditation: return "finished_med_1_hour_meditation"
        case .finished_med_2_hour_meditation: return "finished_med_2_hour_meditation"
        case .finished_med_why_meditate: return "finished_med_why_meditate"
        case .finished_med_create_your_anchor: return "finished_med_create_your_anchor"
        case .finished_med_tuning_into_your_body: return "finished_med_tuning_into_your_body"
        case .finished_med_gaining_clarity: return "finished_med_gaining_clarity"
        case .finished_med_stress_antitode: return "finished_med_stress_antitode"
        case .finished_med_compassion_x_selflove: return "finished_med_compassion_x_selflove"
        case .finished_med_joy_on_demand: return "finished_med_joy_on_demand"
        case .finished_30_second_meditation: return "finished_30_second_meditation"
        case .finished_basic_guided_meditation: return "finished_basic_guided_meditation"
        case .finished_semguided_meditation: return "finished_semguided_meditation"
        case .finished_meditation_for_focus: return "finished_meditation_for_focus"
        case .finished_anxiety_x_stress: return "finished_anxiety_x_stress"
        case .finished_body_scan: return "finished_body_scan"
        case .finished_better_faster_sleep: return "finished_better_faster_sleep"
        case .screen_load_profile: return "screen_load_profile"
        case .profile_tapped_journey: return "profile_tapped_journey"
        case .profile_tapped_settings: return "profile_tapped_settings"
        case .profile_tapped_email: return "profile_tapped_email"
        case .profile_tapped_reddit: return "profile_tapped_reddit"
        case .profile_tapped_invite: return "profile_tapped_invite"
        case .profile_tapped_notifications: return "profile_tapped_notifications"
        case .profile_tapped_instagram: return "profile_tapped_instagram"
        case .profile_tapped_restore: return "profile_tapped_restore"
        case .profile_tapped_toggle_off_notifs: return "profile_tapped_toggle_off_notifs"
        case .profile_tapped_toggle_on_notifs: return "profile_tapped_toggle_on_notifs"
        case .profile_tapped_logout: return "profile_tapped_logout"
        case .screen_load_categories: return "screen_load_categories"
        case .categories_tapped_unguided: return "categories_tapped_unguided"
        case .categories_tapped_all: return "categories_tapped_all"
        case .categories_tapped_courses: return "categories_tapped_courses"
        case .categories_tapped_anxiety: return "categories_tapped_anxiety"
        case .categories_tapped_focus: return "categories_tapped_focus"
        case .categories_tapped_growth: return "categories_tapped_growth"
        case .categories_tapped_meditation: return "categories_tapped_meditation"
        case .categories_tapped_sleep: return "categories_tapped_sleep"
        case .categories_tapped_confidence: return "categories_tapped_confidence"
        case .tabs_tapped_meditate: return "tabs_tapped_meditate"
        case .tabs_tapped_garden: return "tabs_tapped_garden"
        case .tabs_tapped_store: return "tabs_tapped_store"
        case .tabs_tapped_profile: return "tabs_tapped_profile"
        case .tabs_tapped_plus: return "tabs_tapped_plus"
        case .plus_tapped_mood: return "plus_tapped_mood"
        case .mood_tapped_angry: return "mood_tapped_angry"
        case .mood_tapped_sad: return "mood_tapped_sad"
        case .mood_tapped_okay: return "mood_tapped_okay"
        case .mood_tapped_happy: return "mood_tapped_happy"
        case .mood_tapped_done: return "mood_tapped_done"
        case .mood_tapped_cancel: return "mood_tapped_cancel"
        case .plus_tapped_gratitude: return "plus_tapped_gratitude"
        case .gratitude_tapped_done: return "gratitude_tapped_done"
        case .gratitude_tapped_cancel: return "gratitude_tapped_cancel"
        case .gratitude_tapped_prompts: return "gratitude_tapped_prompts"
        case .plus_tapped_meditate: return "plus_tapped_meditate"
        case .play_tapped_sound_beach: return "play_tapped_sound_beach"
        }
    }
}
