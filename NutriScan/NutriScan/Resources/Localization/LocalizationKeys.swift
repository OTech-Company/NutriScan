//
//  LocalizationKeys.swift
//  NutriScan
//
//  Created by Ahmed Nageh on 15/08/2026.
//

import Foundation

struct LocalizationKeys {

    // MARK: - Common
    struct Common {
        static let back: String.LocalizationValue = "common.back"
        static let cancel: String.LocalizationValue = "common.cancel"
        static let continueAction: String.LocalizationValue = "common.continue"
        static let done: String.LocalizationValue = "common.done"
        static let error: String.LocalizationValue = "common.error"
        static let ok: String.LocalizationValue = "common.ok"
        static let retry: String.LocalizationValue = "common.retry"
        static let save: String.LocalizationValue = "common.save"
        static let tryAgain: String.LocalizationValue = "common.try_again"
        static let delete: String.LocalizationValue = "common.delete"
        static let edit: String.LocalizationValue = "common.edit"
        static let logout: String.LocalizationValue = "common.logout"
        static let dismiss: String.LocalizationValue = "common.dismiss"
        static let somethingWentWrong: String.LocalizationValue = "common.something_went_wrong"
        static let noInternetConnection: String.LocalizationValue = "common.no_internet_connection"
        static let actionFailed: String.LocalizationValue = "common.action_failed"
        static let unknownError: String.LocalizationValue = "common.unknown_error"
        static let share: String.LocalizationValue = "common.share"
        static let height: String.LocalizationValue = "common.height"
        static let weight: String.LocalizationValue = "common.weight"
        static let other: String.LocalizationValue = "common.other"
        static let start: String.LocalizationValue = "common.start"
        static let fieldRequired: String.LocalizationValue = "common.field_required"
        static let searchPlaceholder: String.LocalizationValue = "common.search_placeholder"
        static let searchOptionsPlaceholder: String.LocalizationValue = "common.search_options_placeholder"
        static let cm: String.LocalizationValue = "cm"
        static let kg: String.LocalizationValue = "kg"
    }

    // MARK: - Auth
    struct Auth {
        struct Login {
            static let title: String.LocalizationValue = "auth.login.title"
            static let emailTitle: String.LocalizationValue = "auth.login.email_title"
            static let emailPlaceholder: String.LocalizationValue = "auth.login.email_placeholder"
            static let passwordTitle: String.LocalizationValue = "auth.login.password_title"
            static let passwordPlaceholder: String.LocalizationValue = "auth.login.password_placeholder"
            static let forgotPassword: String.LocalizationValue = "auth.login.forgot_password"
            static let signIn: String.LocalizationValue = "auth.login.sign_in"
            static let noAccount: String.LocalizationValue = "auth.login.no_account"
            static let signUp: String.LocalizationValue = "auth.login.sign_up"
            static let or: String.LocalizationValue = "auth.login.or"
            static let failedTitle: String.LocalizationValue = "auth.login.failed_title"
            static let failedUnknown: String.LocalizationValue = "auth.login.failed_unknown"
            static let tryAgain: String.LocalizationValue = "auth.login.try_again"
        }

        struct Register {
            static let title: String.LocalizationValue = "auth.register.title"
            static let firstNameTitle: String.LocalizationValue = "auth.register.first_name_title"
            static let firstNamePlaceholder: String.LocalizationValue = "auth.register.first_name_placeholder"
            static let lastNameTitle: String.LocalizationValue = "auth.register.last_name_title"
            static let lastNamePlaceholder: String.LocalizationValue = "auth.register.last_name_placeholder"
            static let emailTitle: String.LocalizationValue = "auth.register.email_title"
            static let emailPlaceholder: String.LocalizationValue = "auth.register.email_placeholder"
            static let passwordTitle: String.LocalizationValue = "auth.register.password_title"
            static let passwordPlaceholder: String.LocalizationValue = "auth.register.password_placeholder"
            static let confirmPasswordTitle: String.LocalizationValue = "auth.register.confirm_password_title"
            static let confirmPasswordPlaceholder: String.LocalizationValue = "auth.register.confirm_password_placeholder"
            static let signUp: String.LocalizationValue = "auth.register.sign_up"
            static let alreadyHaveAccount: String.LocalizationValue = "auth.register.already_have_account"
            static let signIn: String.LocalizationValue = "auth.register.sign_in"
            static let successTitle: String.LocalizationValue = "auth.register.success_title"
            static let successDescription: String.LocalizationValue = "auth.register.success_description"
            static let failedTitle: String.LocalizationValue = "auth.register.failed_title"
        }

        struct ForgotPassword {
            static let headerTitle: String.LocalizationValue = "auth.forgot_password.header_title"
            static let headerSubtitle: String.LocalizationValue = "auth.forgot_password.header_subtitle"
            static let resetTitle: String.LocalizationValue = "auth.forgot_password.reset_title"
            static let resetDescription: String.LocalizationValue = "auth.forgot_password.reset_description"
            static let emailTitle: String.LocalizationValue = "auth.forgot_password.email_title"
            static let emailPlaceholder: String.LocalizationValue = "auth.forgot_password.email_placeholder"
            static let sendResetLink: String.LocalizationValue = "auth.forgot_password.send_reset_link"
            static let continueButton: String.LocalizationValue = "auth.forgot_password.continue"
            static let resendLink: String.LocalizationValue = "auth.forgot_password.resend_link"
            static let resetLinkSentTitle: String.LocalizationValue = "auth.forgot_password.reset_link_sent_title"
            static let resetLinkSentDesc: String.LocalizationValue = "auth.forgot_password.reset_link_sent_desc"
            static let checkInbox: String.LocalizationValue = "auth.forgot_password.check_inbox"
            static let optionEmailTitle: String.LocalizationValue = "auth.forgot_password.option_email_title"
            static let optionEmailDesc: String.LocalizationValue = "auth.forgot_password.option_email_desc"
            static let option2faTitle: String.LocalizationValue = "auth.forgot_password.option_2fa_title"
            static let option2faDesc: String.LocalizationValue = "auth.forgot_password.option_2fa_desc"
            static let optionGauthTitle: String.LocalizationValue = "auth.forgot_password.option_gauth_title"
            static let optionGauthDesc: String.LocalizationValue = "auth.forgot_password.option_gauth_desc"
            static let optionSmsTitle: String.LocalizationValue = "auth.forgot_password.option_sms_title"
            static let optionSmsDesc: String.LocalizationValue = "auth.forgot_password.option_sms_desc"
        }

        struct VerificationPending {
            static let headerTitle: String.LocalizationValue = "auth.verification.header_title"
            static let headerSubtitle: String.LocalizationValue = "auth.verification.header_subtitle"
            static let linkSentTo: String.LocalizationValue = "auth.verification.link_sent_to"
            static let instructions: String.LocalizationValue = "auth.verification.instructions"
            static let goToSignIn: String.LocalizationValue = "auth.verification.go_to_sign_in"
            static let resendEmailIn: String.LocalizationValue = "auth.verification.resend_email_in"
            static let didNotReceive: String.LocalizationValue = "auth.verification.did_not_receive"
            static let resendEmail: String.LocalizationValue = "auth.verification.resend_email"
            static let sentTitle: String.LocalizationValue = "auth.verification.sent_title"
        }

        struct AccountRestoration {
            static let headerTitle: String.LocalizationValue = "auth.account_restoration.header_title"
            static let headerSubtitle: String.LocalizationValue = "auth.account_restoration.header_subtitle"
            static let contentTitle: String.LocalizationValue = "auth.account_restoration.content_title"
            static let contentDescription: String.LocalizationValue = "auth.account_restoration.content_description"
            static let daysRemaining: String.LocalizationValue = "auth.account_restoration.days_remaining"
            static let scheduledDeletion: String.LocalizationValue = "auth.account_restoration.scheduled_deletion"
            static let restoreButton: String.LocalizationValue = "auth.account_restoration.restore_button"
            static let wantToExit: String.LocalizationValue = "auth.account_restoration.want_to_exit"
            static let logOut: String.LocalizationValue = "auth.account_restoration.log_out"
            static let failedTitle: String.LocalizationValue = "auth.account_restoration.failed_title"
        }
    }

    // MARK: - Validation
    struct Validation {
        struct Email {
            static let required: String.LocalizationValue = "validation.email.required"
            static let invalid: String.LocalizationValue = "validation.email.invalid"
        }

        struct Password {
            static let required: String.LocalizationValue = "validation.password.required"
            static let minLength: String.LocalizationValue = "validation.password.min_length"
            static let mismatch: String.LocalizationValue = "validation.password.mismatch"
        }

        struct Name {
            static let firstRequired: String.LocalizationValue = "validation.name.first_required"
            static let firstLength: String.LocalizationValue = "validation.name.first_length"
            static let lastRequired: String.LocalizationValue = "validation.name.last_required"
            static let lastLength: String.LocalizationValue = "validation.name.last_length"
            static let fullRequired: String.LocalizationValue = "validation.name.full_required"
            static let fullLength: String.LocalizationValue = "validation.name.full_length"
        }

        struct Height {
            static let required: String.LocalizationValue = "validation.height.required"
            static let invalid: String.LocalizationValue = "validation.height.invalid"
        }

        struct Weight {
            static let required: String.LocalizationValue = "validation.weight.required"
            static let invalid: String.LocalizationValue = "validation.weight.invalid"
        }

        struct Mobile {
            static let required: String.LocalizationValue = "validation.mobile.required"
            static let length: String.LocalizationValue = "validation.mobile.length"
            static let invalid: String.LocalizationValue = "validation.mobile.invalid"
        }

        struct VerifyCode {
            static let required: String.LocalizationValue = "validation.verify_code.required"
            static let length: String.LocalizationValue = "validation.verify_code.length"
            static let invalid: String.LocalizationValue = "validation.verify_code.invalid"
        }
    }

    // MARK: - Settings
    struct Settings {
        static let title: String.LocalizationValue = "settings.title"
        static let subtitle: String.LocalizationValue = "settings.subtitle"
        static let profileSettings: String.LocalizationValue = "settings.profile_settings"
        static let notificationSettings: String.LocalizationValue = "settings.notification_settings"
        static let appearance: String.LocalizationValue = "settings.appearance"
        static let language: String.LocalizationValue = "settings.language"
        static let terms: String.LocalizationValue = "settings.terms"
        static let help: String.LocalizationValue = "settings.help"
        static let logout: String.LocalizationValue = "settings.logout"
        static let deleteAccount: String.LocalizationValue = "settings.delete_account"
        static let logoutAlertTitle: String.LocalizationValue = "settings.logout_alert_title"
        static let logoutAlertDescription: String.LocalizationValue = "settings.logout_alert_description"
        static let logoutAlertConfirm: String.LocalizationValue = "settings.logout_alert_confirm"
        static let deleteAlertTitle: String.LocalizationValue = "settings.delete_alert_title"
        static let deleteAlertDescription: String.LocalizationValue = "settings.delete_alert_description"
        static let deleteAlertConfirm: String.LocalizationValue = "settings.delete_alert_confirm"
        static let mailNotConfigured: String.LocalizationValue = "settings.mail_not_configured"
        static let mailNotConfiguredDesc: String.LocalizationValue = "settings.mail_not_configured_desc"
        static let faqTitle: String.LocalizationValue = "settings.faq_title"
        static let contactUs: String.LocalizationValue = "settings.contact_us"
        static let contactSupport: String.LocalizationValue = "settings.contact_support"
        static let madeWith: String.LocalizationValue = "settings.made_with"

        // FAQ Data Items
        static let faq1Question: String.LocalizationValue = "settings.faq_1_q"
        static let faq1Answer: String.LocalizationValue = "settings.faq_1_a"
        static let faq2Question: String.LocalizationValue = "settings.faq_2_q"
        static let faq2Answer: String.LocalizationValue = "settings.faq_2_a"
        static let faq3Question: String.LocalizationValue = "settings.faq_3_q"
        static let faq3Answer: String.LocalizationValue = "settings.faq_3_a"
        static let faq4Question: String.LocalizationValue = "settings.faq_4_q"
        static let faq4Answer: String.LocalizationValue = "settings.faq_4_a"
        static let faq5Question: String.LocalizationValue = "settings.faq_5_q"
        static let faq5Answer: String.LocalizationValue = "settings.faq_5_a"
        static let faq6Question: String.LocalizationValue = "settings.faq_6_q"
        static let faq6Answer: String.LocalizationValue = "settings.faq_6_a"
        static let faq7Question: String.LocalizationValue = "settings.faq_7_q"
        static let faq7Answer: String.LocalizationValue = "settings.faq_7_a"
        static let faq8Question: String.LocalizationValue = "settings.faq_8_q"
        static let faq8Answer: String.LocalizationValue = "settings.faq_8_a"
        static let faq9Question: String.LocalizationValue = "settings.faq_9_q"
        static let faq9Answer: String.LocalizationValue = "settings.faq_9_a"
        static let faq10Question: String.LocalizationValue = "settings.faq_10_q"
        static let faq10Answer: String.LocalizationValue = "settings.faq_10_a"

        // Terms Data Items
        static let terms1Title: String.LocalizationValue = "settings.terms_1_title"
        static let terms1Body: String.LocalizationValue = "settings.terms_1_body"
        static let terms2Title: String.LocalizationValue = "settings.terms_2_title"
        static let terms2Body: String.LocalizationValue = "settings.terms_2_body"
        static let terms3Title: String.LocalizationValue = "settings.terms_3_title"
        static let terms3Body: String.LocalizationValue = "settings.terms_3_body"
        static let terms4Title: String.LocalizationValue = "settings.terms_4_title"
        static let terms4Body: String.LocalizationValue = "settings.terms_4_body"
        static let terms5Title: String.LocalizationValue = "settings.terms_5_title"
        static let terms5Body: String.LocalizationValue = "settings.terms_5_body"
        static let terms6Title: String.LocalizationValue = "settings.terms_6_title"
        static let terms6Body: String.LocalizationValue = "settings.terms_6_body"
        static let terms7Title: String.LocalizationValue = "settings.terms_7_title"
        static let terms7Body: String.LocalizationValue = "settings.terms_7_body"
        static let terms8Title: String.LocalizationValue = "settings.terms_8_title"
        static let terms8Body: String.LocalizationValue = "settings.terms_8_body"
    }

    // MARK: - ProfileSetup
    struct ProfileSetup {
        static let healthProfileTitle: String.LocalizationValue = "profile_setup.health_profile_title"
        static let healthProfileSubtitle: String.LocalizationValue = "profile_setup.health_profile_subtitle"
        static let chronicConditions: String.LocalizationValue = "profile_setup.chronic_conditions"
        static let allergies: String.LocalizationValue = "profile_setup.allergies"
        static let searchConditions: String.LocalizationValue = "profile_setup.search_conditions"
        static let searchAllergies: String.LocalizationValue = "profile_setup.search_allergies"
        static let save: String.LocalizationValue = "profile_setup.save"
        static let saving: String.LocalizationValue = "profile_setup.saving"
        static let updateFailedTitle: String.LocalizationValue = "profile_setup.update_failed_title"
        static let years: String.LocalizationValue = "profile_setup.years"
        static let heightDescription: String.LocalizationValue = "profile_setup.height_description"
        static let yourExercise: String.LocalizationValue = "profile_setup.your_exercise"
        static let male: String.LocalizationValue = "profile_setup.male"
        static let female: String.LocalizationValue = "profile_setup.female"
        static let invalidAgeTitle: String.LocalizationValue = "profile_setup.invalid_age_title"
        static let invalidAgeDesc: String.LocalizationValue = "profile_setup.invalid_age_desc"
        static let searchConditionsPlaceholder: String.LocalizationValue = "profile_setup.search_conditions_placeholder"
        static let searchAllergiesPlaceholder: String.LocalizationValue = "profile_setup.search_allergies_placeholder"
        static let genderTitlePrefix: String.LocalizationValue = "profile_setup.gender_title_prefix"
        static let genderTitleHighlight: String.LocalizationValue = "profile_setup.gender_title_highlight"
        static let genderSubtitle: String.LocalizationValue = "profile_setup.gender_subtitle"
        static let birthdateTitlePrefix: String.LocalizationValue = "profile_setup.birthdate_title_prefix"
        static let birthdateTitleHighlight: String.LocalizationValue = "profile_setup.birthdate_title_highlight"
        static let birthdateSubtitle: String.LocalizationValue = "profile_setup.birthdate_subtitle"
        static let weightTitlePrefix: String.LocalizationValue = "profile_setup.weight_title_prefix"
        static let weightTitleHighlight: String.LocalizationValue = "profile_setup.weight_title_highlight"
        static let weightSubtitle: String.LocalizationValue = "profile_setup.weight_subtitle"
        static let heightTitlePrefix: String.LocalizationValue = "profile_setup.height_title_prefix"
        static let heightTitleHighlight: String.LocalizationValue = "profile_setup.height_title_highlight"
        static let heightTitleSuffix: String.LocalizationValue = "profile_setup.height_title_suffix"
        static let heightSubtitle: String.LocalizationValue = "profile_setup.height_subtitle"
        static let healthProfileStepTitlePrefix: String.LocalizationValue = "profile_setup.health_profile_step_title_prefix"
        static let healthProfileStepTitleHighlight: String.LocalizationValue = "profile_setup.health_profile_step_title_highlight"
        static let healthProfileStepSubtitle: String.LocalizationValue = "profile_setup.health_profile_step_subtitle"
    }

    // MARK: - Profile
    struct Profile {
        static let familyMembers: String.LocalizationValue = "profile.family_members"
        static let addMember: String.LocalizationValue = "profile.add_member"
        static let showDetails: String.LocalizationValue = "profile.show_details"
        static let failedToLoad: String.LocalizationValue = "profile.failed_to_load"
        static let scanHistory: String.LocalizationValue = "profile.scan_history"
        static let caloriesHistory: String.LocalizationValue = "profile.calories_history"
        static let notifications: String.LocalizationValue = "profile.notifications"
        static let settings: String.LocalizationValue = "profile.settings"
        static let memberNamePlaceholder: String.LocalizationValue = "profile.member_name_placeholder"
        static let relationPlaceholder: String.LocalizationValue = "profile.relation_placeholder"
        static let duplicateMemberTitle: String.LocalizationValue = "profile.duplicate_member_title"
        static let duplicateMemberDesc: String.LocalizationValue = "profile.duplicate_member_desc"
        static let saveChangesTitle: String.LocalizationValue = "profile.save_changes_title"
        static let deleteMemberTitle: String.LocalizationValue = "profile.delete_member_title"
        static let dayStreak: String.LocalizationValue = "profile.day_streak"
    }

    // MARK: - Home
    struct Home {
        static let explore: String.LocalizationValue = "home.explore"
        static let healthComesFirst: String.LocalizationValue = "home.health_comes_first"
        static let recentHistory: String.LocalizationValue = "home.recent_history"
        static let viewAll: String.LocalizationValue = "home.view_all"
        static let dailyHealthTip: String.LocalizationValue = "home.daily_health_tip"
        static let readyToScan: String.LocalizationValue = "home.ready_to_scan"
        static let checkNutritionalFacts: String.LocalizationValue = "home.check_nutritional_facts"
        static let healthNews: String.LocalizationValue = "home.health_news"
        static let chatWithAI: String.LocalizationValue = "home.chat_with_ai"
        static let deleteScanTitle: String.LocalizationValue = "home.delete_scan_title"
        static let deleteScanDesc: String.LocalizationValue = "home.delete_scan_desc"
        static let deleteFailedTitle: String.LocalizationValue = "home.delete_failed_title"
        static let defaultDailyTip: String.LocalizationValue = "home.default_daily_tip"
    }

    // MARK: - ScanHistory
    struct ScanHistory {
        static let title: String.LocalizationValue = "scan_history.title"
        static let emptyTitle: String.LocalizationValue = "scan_history.empty_title"
        static let emptyDesc: String.LocalizationValue = "scan_history.empty_desc"
        static let todayWithTime: String.LocalizationValue = "scan_history.today_with_time"
        static let yesterdayWithTime: String.LocalizationValue = "scan_history.yesterday_with_time"
        static let today: String.LocalizationValue = "scan_history.today"
        static let yesterday: String.LocalizationValue = "scan_history.yesterday"
    }

    // MARK: - Scan
    struct Scan {
        static let analyzing: String.LocalizationValue = "scan.analyzing"
        static let scanComplete: String.LocalizationValue = "scan.scan_complete"
        static let scanFailed: String.LocalizationValue = "scan.scan_failed"
        static let couldNotAnalyze: String.LocalizationValue = "scan.could_not_analyze"
        static let processing: String.LocalizationValue = "scan.processing"
        static let safe: String.LocalizationValue = "scan.safe"
        static let unsafe: String.LocalizationValue = "scan.unsafe"
        static let caution: String.LocalizationValue = "scan.caution"
        static let noScanFoundWithId: String.LocalizationValue = "scan.no_scan_found_with_id"
    }

    // MARK: - Favorites
    struct Favorites {
        static let emptyTitle: String.LocalizationValue = "favorites.empty_title"
        static let emptyDesc: String.LocalizationValue = "favorites.empty_desc"
        static let kcal: String.LocalizationValue = "favorites.kcal"
        static let removeProductTitle: String.LocalizationValue = "favorites.remove_product_title"
        static let removeProductDesc: String.LocalizationValue = "favorites.remove_product_desc"
        static let couldntAddMealTitle: String.LocalizationValue = "favorites.couldnt_add_meal_title"
        static let noInternetDesc: String.LocalizationValue = "favorites.no_internet_desc"
        static let adding: String.LocalizationValue = "favorites.adding"
        static let added: String.LocalizationValue = "favorites.added"
        static let ready: String.LocalizationValue = "favorites.ready"
        static let searchPlaceholder: String.LocalizationValue = "favorites.search_placeholder"
    }

    // MARK: - Notifications
    struct Notifications {
        static let emptyTitle: String.LocalizationValue = "notifications.empty_title"
        static let emptyDesc: String.LocalizationValue = "notifications.empty_desc"
        static let clearAll: String.LocalizationValue = "notifications.clear_all"
        static let doNotDisturb: String.LocalizationValue = "notifications.do_not_disturb"
        static let notificationSettings: String.LocalizationValue = "notifications.notification_settings"
        static let clearAllTitle: String.LocalizationValue = "notifications.clear_all_title"
        static let clearAllDesc: String.LocalizationValue = "notifications.clear_all_desc"

        // Sections
        static let sectionFitness: String.LocalizationValue = "notifications.section_fitness"
        static let sectionReminders: String.LocalizationValue = "notifications.section_reminders"
        static let sectionContent: String.LocalizationValue = "notifications.section_content"

        // Categories
        static let categorySteps: String.LocalizationValue = "notifications.category_steps"
        static let categoryWater: String.LocalizationValue = "notifications.category_water"
        static let categoryWorkout: String.LocalizationValue = "notifications.category_workout"
        static let categoryFoodLog: String.LocalizationValue = "notifications.category_food_log"
        static let categoryStreak: String.LocalizationValue = "notifications.category_streak"
        static let categoryBreakTime: String.LocalizationValue = "notifications.category_break_time"
        static let categoryScanReminders: String.LocalizationValue = "notifications.category_scan_reminders"
        static let categoryHealthNews: String.LocalizationValue = "notifications.category_health_news"
        static let categoryHealthQuotes: String.LocalizationValue = "notifications.category_health_quotes"
    }

    // MARK: - StepTracker
    struct StepTracker {
        static let stepHistory: String.LocalizationValue = "step_tracker.step_history"
        static let noHistory: String.LocalizationValue = "step_tracker.no_history"
        static let steps: String.LocalizationValue = "step_tracker.steps"
        static let dailyInsight: String.LocalizationValue = "step_tracker.daily_insight"
        static let periodAverage: String.LocalizationValue = "step_tracker.period_average"
        static let caloriesBurned: String.LocalizationValue = "step_tracker.calories_burned"
        static let distanceCovered: String.LocalizationValue = "step_tracker.distance_covered"
        static let activeMinutes: String.LocalizationValue = "step_tracker.active_minutes"
        static let week: String.LocalizationValue = "step_tracker.week"
        static let month: String.LocalizationValue = "step_tracker.month"
        static let threeMonths: String.LocalizationValue = "step_tracker.three_months"
        static let sixMonths: String.LocalizationValue = "step_tracker.six_months"
        static let start: String.LocalizationValue = "step_tracker.start"
        static let end: String.LocalizationValue = "step_tracker.end"
        static let goal: String.LocalizationValue = "step_tracker.goal"
        static let period: String.LocalizationValue = "step_tracker.period"
        static let day: String.LocalizationValue = "step_tracker.day"
        static let ofGoal: String.LocalizationValue = "step_tracker.of_goal"
        static let km: String.LocalizationValue = "km"
        static let min: String.LocalizationValue = "min"
    }

    // MARK: - Exercise
    struct Exercise {
        static let title: String.LocalizationValue = "exercise.title"
        static let searchPlaceholder: String.LocalizationValue = "exercise.search_placeholder"
        static let noExercises: String.LocalizationValue = "exercise.no_exercises"
        static let sets: String.LocalizationValue = "exercise.sets"
        static let reps: String.LocalizationValue = "exercise.reps"
        static let instructions: String.LocalizationValue = "exercise.instructions"
        static let totalTime: String.LocalizationValue = "exercise.total_time"
        static let restart: String.LocalizationValue = "exercise.restart"
        static let pause: String.LocalizationValue = "exercise.pause"
        static let resume: String.LocalizationValue = "exercise.resume"
        static let finish: String.LocalizationValue = "exercise.finish"
        static let cancel: String.LocalizationValue = "exercise.cancel"
        static let tryAdjustingSearch: String.LocalizationValue = "exercise.try_adjusting_search"
        static let readMore: String.LocalizationValue = "exercise.read_more"
        static let exerciseLabel: String.LocalizationValue = "exercise.label"
        static let startWorkout: String.LocalizationValue = "exercise.start_workout"
        static let workoutCompletedTitle: String.LocalizationValue = "exercise.workout_completed_title"
        static let cancelWorkoutTitle: String.LocalizationValue = "exercise.cancel_workout_title"
        static let cancelWorkoutDesc: String.LocalizationValue = "exercise.cancel_workout_desc"
        static let endWorkout: String.LocalizationValue = "exercise.end_workout"
        static let keepGoing: String.LocalizationValue = "exercise.keep_going"
        static let restartTimerTitle: String.LocalizationValue = "exercise.restart_timer_title"
        static let restartTimerDesc: String.LocalizationValue = "exercise.restart_timer_desc"
    }

    // MARK: - Calories
    struct Calories {
        static let historyTitle: String.LocalizationValue = "calories.history_title"
        static let applyDate: String.LocalizationValue = "calories.apply_date"
        static let water: String.LocalizationValue = "calories.water"
        static let calorieGoals: String.LocalizationValue = "calories.calorie_goals"
        static let completePersonalInfo: String.LocalizationValue = "calories.complete_personal_info"
        static let addFood: String.LocalizationValue = "calories.add_food"
        static let dailyProducts: String.LocalizationValue = "calories.daily_products"
        static let motionAndFitnessTitle: String.LocalizationValue = "calories.motion_fitness_title"
        static let permissionRequired: String.LocalizationValue = "calories.permission_required"
        static let notice: String.LocalizationValue = "calories.notice"
        static let removeOneServingTitle: String.LocalizationValue = "calories.remove_one_serving_title"
        static let removeMealTitle: String.LocalizationValue = "calories.remove_meal_title"
        static let removeOneServingDesc: String.LocalizationValue = "calories.remove_one_serving_desc"
        static let removeMealDesc: String.LocalizationValue = "calories.remove_meal_desc"
        static let removeWaterTitle: String.LocalizationValue = "calories.remove_water_title"
        static let removeWaterDesc: String.LocalizationValue = "calories.remove_water_desc"
        static let removeTargetCupTitle: String.LocalizationValue = "calories.remove_target_cup_title"
        static let removeTargetCupDesc: String.LocalizationValue = "calories.remove_target_cup_desc"
        static let yourTDEE: String.LocalizationValue = "calories.your_tdee"
        static let caloriesGained: String.LocalizationValue = "calories.calories_gained"
        static let caloriesBurned: String.LocalizationValue = "calories.calories_burned"
        static let unknownProduct: String.LocalizationValue = "calories.unknown_product"
        static let minToday: String.LocalizationValue = "calories.min_today"
        static let totalMeals: String.LocalizationValue = "calories.total_meals"
        static let cups: String.LocalizationValue = "calories.cups"
        static let historyDate: String.LocalizationValue = "calories.history_date"
        static let filterByDate: String.LocalizationValue = "calories_history.filter_by_date"
        static let historyIncompleteResponse: String.LocalizationValue = "calories_history.incomplete_response"
        static let historyNotFound: String.LocalizationValue = "calories_history.not_found"
        static let target: String.LocalizationValue = "target"
    }

    // MARK: - ProductDetails
    struct ProductDetails {
        static let title: String.LocalizationValue = "product_details.title"
        static let scannedAt: String.LocalizationValue = "product_details.scanned_at"
        static let forYou: String.LocalizationValue = "product_details.for_you"
        static let whyIts: String.LocalizationValue = "product_details.why_its"
        static let calories: String.LocalizationValue = "product_details.calories"
        static let protein: String.LocalizationValue = "product_details.protein"
        static let carbs: String.LocalizationValue = "product_details.carbs"
        static let fat: String.LocalizationValue = "product_details.fat"
        static let sugar: String.LocalizationValue = "product_details.sugar"
        static let fiber: String.LocalizationValue = "product_details.fiber"
        static let sodium: String.LocalizationValue = "product_details.sodium"
        static let scanFailed: String.LocalizationValue = "product_details.scan_failed"
        static let failedUpdateFavorite: String.LocalizationValue = "product_details.failed_update_favorite"
        static let g: String.LocalizationValue = "g"
        static let mg: String.LocalizationValue = "mg"
    }

    // MARK: - News
    struct News {
        static let title: String.LocalizationValue = "news.title"
        static let noNews: String.LocalizationValue = "news.no_news"
        static let noNewsDesc: String.LocalizationValue = "news.no_news_desc"
        static let readFullArticle: String.LocalizationValue = "news.read_full_article"
        static let openArticle: String.LocalizationValue = "news.open_article"
        static let noConnectionPaginationDesc: String.LocalizationValue = "news.no_connection_pagination_desc"
        static let couldntLoadArticlesDesc: String.LocalizationValue = "news.couldnt_load_articles_desc"
        static let clearSearch: String.LocalizationValue = "news.clear_search"
        static let searchPlaceholder: String.LocalizationValue = "news.search_placeholder"
    }

    // MARK: - PersonalInformation
    struct PersonalInformation {
        static let title: String.LocalizationValue = "personal_info.title"
    }

    // MARK: - EditProfile
    struct EditProfile {
        static let saveChangesDesc: String.LocalizationValue = "edit_profile.save_changes_desc"
        static let discard: String.LocalizationValue = "edit_profile.discard"
    }

    // MARK: - Onboarding
    struct Onboarding {
        static let scanLabelsTitle: String.LocalizationValue = "onboarding.scan_labels_title"
        static let knowWhatsSafeTitle: String.LocalizationValue = "onboarding.know_whats_safe_title"
        static let shopWithConfidenceTitle: String.LocalizationValue = "onboarding.shop_with_confidence_title"
        static let scanLabelsDesc: String.LocalizationValue = "onboarding.scan_labels_desc"
        static let knowWhatsSafeDesc: String.LocalizationValue = "onboarding.know_whats_safe_desc"
        static let shopWithConfidenceDesc: String.LocalizationValue = "onboarding.shop_with_confidence_desc"
        static let next: String.LocalizationValue = "onboarding.next"
        static let letsStart: String.LocalizationValue = "onboarding.lets_start"
        static let back: String.LocalizationValue = "onboarding.back"
        static let skip: String.LocalizationValue = "onboarding.skip"
    }

    // MARK: - EmptyState
    struct EmptyState {
        // Titles
        static let titleNoConnection: String.LocalizationValue = "empty_state.title_no_connection"
        static let titleError404: String.LocalizationValue = "empty_state.title_error_404"
        static let titleNoScans: String.LocalizationValue = "empty_state.title_no_scans"
        static let titleNotificationPermission: String.LocalizationValue = "empty_state.title_notification_permission"
        static let titleNoNotifications: String.LocalizationValue = "empty_state.title_no_notifications"
        static let titleNoSaved: String.LocalizationValue = "empty_state.title_no_saved"
        static let titleNoSearchResults: String.LocalizationValue = "empty_state.title_no_search_results"
        static let titleNoCaloriesHistory: String.LocalizationValue = "empty_state.title_no_calories_history"
        static let titleServerProblem: String.LocalizationValue = "empty_state.title_server_problem"

        // Descriptions
        static let descNoConnection: String.LocalizationValue = "empty_state.desc_no_connection"
        static let descError404: String.LocalizationValue = "empty_state.desc_error_404"
        static let descNoScans: String.LocalizationValue = "empty_state.desc_no_scans"
        static let descNotificationPermission: String.LocalizationValue = "empty_state.desc_notification_permission"
        static let descNoNotifications: String.LocalizationValue = "empty_state.desc_no_notifications"
        static let descNoSaved: String.LocalizationValue = "empty_state.desc_no_saved"
        static let descNoSearchResults: String.LocalizationValue = "empty_state.desc_no_search_results"
        static let descNoCaloriesHistory: String.LocalizationValue = "empty_state.desc_no_calories_history"
        static let descServerProblem: String.LocalizationValue = "empty_state.desc_server_problem"

        // Actions
        static let actionGoToHome: String.LocalizationValue = "empty_state.action_go_to_home"
        static let actionStartScanning: String.LocalizationValue = "empty_state.action_start_scanning"
        static let actionGoToSettings: String.LocalizationValue = "empty_state.action_go_to_settings"
        static let actionGoBack: String.LocalizationValue = "empty_state.action_go_back"
        static let actionGoToScans: String.LocalizationValue = "empty_state.action_go_to_scans"
        static let actionGoToScan: String.LocalizationValue = "empty_state.action_go_to_scan"
        static let actionAddMeals: String.LocalizationValue = "empty_state.action_add_meals"
        static let actionTryAgain: String.LocalizationValue = "empty_state.action_try_again"
    }

    // MARK: - TabBar
    struct TabBar {
        static let home: String.LocalizationValue = "tab.home"
        static let calories: String.LocalizationValue = "tab.calories"
        static let scan: String.LocalizationValue = "tab.scan"
        static let favorites: String.LocalizationValue = "tab.favorites"
        static let profile: String.LocalizationValue = "tab.profile"
    }

    // MARK: - Accessibility
    struct Accessibility {
        static let historyFor: String.LocalizationValue = "accessibility.history_for"
        static let viewDetailsFor: String.LocalizationValue = "accessibility.view_details_for"
        static let opensProductDetails: String.LocalizationValue = "accessibility.opens_product_details"
        static let removeFromSaved: String.LocalizationValue = "accessibility.remove_from_saved"
        static let addMealTracking: String.LocalizationValue = "accessibility.add_meal_tracking"
        static let swipeAddProduct: String.LocalizationValue = "accessibility.swipe_add_product"
        static let switchLanguage: String.LocalizationValue = "accessibility.switch_language"
        static let startVoiceChat: String.LocalizationValue = "accessibility.start_voice_chat"
        static let loadingMoreArticles: String.LocalizationValue = "accessibility.loading_more_articles"
        static let opensArticleDetails: String.LocalizationValue = "accessibility.opens_article_details"
        static let articleActions: String.LocalizationValue = "accessibility.article_actions"
        static let opensPersonalInfo: String.LocalizationValue = "accessibility.opens_personal_info"
        static let waterCup: String.LocalizationValue = "accessibility.water_cup"
        static let waterCupHint: String.LocalizationValue = "accessibility.water_cup_hint"
        static let chooseHistoryDate: String.LocalizationValue = "accessibility.choose_history_date"
        static let removeDateFilter: String.LocalizationValue = "accessibility.remove_date_filter"
    }

    // MARK: - RAG
    struct RAG {
        static let stopListening: String.LocalizationValue = "rag.stop_listening"
        static let skipAnswer: String.LocalizationValue = "rag.skip_answer"
        static let loading: String.LocalizationValue = "rag.loading"
        static let startSpeaking: String.LocalizationValue = "rag.start_speaking"
    }
}

// MARK: - Convenience Extension
extension String.LocalizationValue {
    /// Resolves localized string using current AppLanguage
    var localized: String {
        AppLanguage.localized(self)
    }
}
