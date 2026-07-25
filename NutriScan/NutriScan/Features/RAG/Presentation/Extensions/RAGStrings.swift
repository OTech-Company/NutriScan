//
//  RAGStrings.swift
//  NutriScan
//
//  Created by Osama Hosam on 24/07/2026.
//

import Foundation

/// English/Arabic copy for the RAG chat and voice screens, selected explicitly by
/// the current `RAGLanguage` rather than relying only on the system locale, so the
/// in-app language toggle takes effect immediately.
enum RAGStrings {
    static func headerTitle(_ language: RAGLanguage) -> String {
        language == .arabic ? "الذكاء الاصطناعي للتغذية" : "Nutrition AI"
    }

    static func inputPlaceholder(_ language: RAGLanguage) -> String {
        language == .arabic ? "اسأل عن التغذية..." : "Ask about nutrition..."
    }

    static func listeningPlaceholder(_ language: RAGLanguage) -> String {
        language == .arabic ? "جاري الاستماع..." : "Listening..."
    }

    static func emptyStateTitle(_ language: RAGLanguage) -> String {
        language == .arabic ? "اسأل أي شيء عن التغذية" : "Ask anything about nutrition"
    }

    static func emptyStateSubtitle(_ language: RAGLanguage) -> String {
        language == .arabic
            ? "احصل على إجابات مدعومة بمصادر صحية موثوقة وأبحاث علمية."
            : "Get answers backed by trusted health sources and research papers."
    }

    static func sourcesTitle(_ language: RAGLanguage) -> String {
        language == .arabic ? "المصادر" : "Sources"
    }

    static func failedAnswer(_ language: RAGLanguage) -> String {
        language == .arabic ? "تعذر الحصول على إجابة. حاول مرة أخرى." : "Couldn't get a response. Please try again."
    }

    static func switchToTextChat(_ language: RAGLanguage) -> String {
        language == .arabic ? "التبديل إلى الدردشة النصية" : "Switch to Text Chat"
    }

    static func sourcedFromOfficialDocumentation(_ language: RAGLanguage) -> String {
        language == .arabic ? "مصادر من وثائق رسمية" : "Sourced from Official Documentation"
    }

    static func micPermissionDenied(_ language: RAGLanguage) -> String {
        language == .arabic
            ? "يرجى السماح بالوصول إلى الميكروفون والتعرف على الصوت لاستخدام الإدخال الصوتي."
            : "Please allow microphone and speech recognition access to use voice input."
    }

    static func recognizerUnavailable(_ language: RAGLanguage) -> String {
        language == .arabic ? "التعرف على الصوت غير متاح الآن." : "Speech recognition isn't available right now."
    }

    // Voice-chat status captions only — a short state word, never the actual
    // transcript or answer text (the voice screen never displays either).
    static func voiceIdle(_ language: RAGLanguage) -> String {
        language == .arabic ? "اضغط للتحدث" : "Tap to speak"
    }

    static func voiceListening(_ language: RAGLanguage) -> String {
        language == .arabic ? "جاري الاستماع..." : "Listening..."
    }

    static func voiceThinking(_ language: RAGLanguage) -> String {
        language == .arabic ? "جاري التفكير..." : "Thinking..."
    }

    static func voiceSpeaking(_ language: RAGLanguage) -> String {
        language == .arabic ? "جاري الرد..." : "Speaking..."
    }

    static func voiceGenericError(_ language: RAGLanguage) -> String {
        language == .arabic ? "حدث خطأ ما." : "Something went wrong."
    }
}
