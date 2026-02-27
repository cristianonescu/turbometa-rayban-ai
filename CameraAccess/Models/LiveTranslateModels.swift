/*
 * Live Translate Models
 * 实时翻译数据模型：语种、音色、翻译记录
 */

import Foundation

// MARK: - 支持的语种

enum TranslateLanguage: String, CaseIterable, Codable, Identifiable {
    // Languages that support both audio + text output
    case en = "en"      // English
    case ro = "ro"      // Romanian
    case ja = "ja"      // Japanese
    case ko = "ko"      // Korean
    case fr = "fr"      // French
    case de = "de"      // German
    case ru = "ru"      // Russian
    case es = "es"      // Spanish
    case pt = "pt"      // Portuguese
    case it = "it"      // Italian
    case yue = "yue"    // Cantonese

    // Languages supported only as input (source language)
    case id = "id"      // Indonesian
    case vi = "vi"      // Vietnamese
    case th = "th"      // Thai
    case ar = "ar"      // Arabic
    case hi = "hi"      // Hindi
    case el = "el"      // Greek
    case tr = "tr"      // Turkish

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .en: return "livetranslate.lang.en".localized
        case .ro: return "livetranslate.lang.ro".localized
        case .ja: return "livetranslate.lang.ja".localized
        case .ko: return "livetranslate.lang.ko".localized
        case .fr: return "livetranslate.lang.fr".localized
        case .de: return "livetranslate.lang.de".localized
        case .ru: return "livetranslate.lang.ru".localized
        case .es: return "livetranslate.lang.es".localized
        case .pt: return "livetranslate.lang.pt".localized
        case .it: return "livetranslate.lang.it".localized
        case .yue: return "livetranslate.lang.yue".localized
        case .id: return "livetranslate.lang.id".localized
        case .vi: return "livetranslate.lang.vi".localized
        case .th: return "livetranslate.lang.th".localized
        case .ar: return "livetranslate.lang.ar".localized
        case .hi: return "livetranslate.lang.hi".localized
        case .el: return "livetranslate.lang.el".localized
        case .tr: return "livetranslate.lang.tr".localized
        }
    }

    var flag: String {
        switch self {
        case .en: return "🇺🇸"
        case .ro: return "🇷🇴"
        case .ja: return "🇯🇵"
        case .ko: return "🇰🇷"
        case .fr: return "🇫🇷"
        case .de: return "🇩🇪"
        case .ru: return "🇷🇺"
        case .es: return "🇪🇸"
        case .pt: return "🇵🇹"
        case .it: return "🇮🇹"
        case .yue: return "🇭🇰"
        case .id: return "🇮🇩"
        case .vi: return "🇻🇳"
        case .th: return "🇹🇭"
        case .ar: return "🇸🇦"
        case .hi: return "🇮🇳"
        case .el: return "🇬🇷"
        case .tr: return "🇹🇷"
        }
    }

    /// 是否支持作为目标语言（输出音频+文本）
    var supportsAudioOutput: Bool {
        switch self {
        case .en, .ro, .ja, .ko, .fr, .de, .ru, .es, .pt, .it, .yue:
            return true
        case .id, .vi, .th, .ar, .hi, .el, .tr:
            return false
        }
    }

    /// 可作为目标语言的语种
    static var targetLanguages: [TranslateLanguage] {
        allCases.filter { $0.supportsAudioOutput }
    }

    /// 所有源语言
    static var sourceLanguages: [TranslateLanguage] {
        allCases
    }
}

// MARK: - 翻译音色

enum TranslateVoice: String, CaseIterable, Codable, Identifiable {
    case cherry = "Cherry"
    case nofish = "Nofish"
    case jada = "Jada"
    case dylan = "Dylan"
    case sunny = "Sunny"
    case peter = "Peter"
    case kiki = "Kiki"
    case eric = "Eric"

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .cherry: return "livetranslate.voice.cherry".localized
        case .nofish: return "livetranslate.voice.nofish".localized
        case .jada: return "livetranslate.voice.jada".localized
        case .dylan: return "livetranslate.voice.dylan".localized
        case .sunny: return "livetranslate.voice.sunny".localized
        case .peter: return "livetranslate.voice.peter".localized
        case .kiki: return "livetranslate.voice.kiki".localized
        case .eric: return "livetranslate.voice.eric".localized
        }
    }

    var description: String {
        switch self {
        case .cherry: return "livetranslate.voice.cherry.desc".localized
        case .nofish: return "livetranslate.voice.nofish.desc".localized
        case .jada: return "livetranslate.voice.jada.desc".localized
        case .dylan: return "livetranslate.voice.dylan.desc".localized
        case .sunny: return "livetranslate.voice.sunny.desc".localized
        case .peter: return "livetranslate.voice.peter.desc".localized
        case .kiki: return "livetranslate.voice.kiki.desc".localized
        case .eric: return "livetranslate.voice.eric.desc".localized
        }
    }

    /// 支持的语种（音色可能只支持部分语种）
    var supportedLanguages: [TranslateLanguage] {
        switch self {
        case .cherry, .nofish:
            // 支持多语种
            return [.ro, .en, .fr, .de, .ru, .it, .es, .pt, .ja, .ko]
        case .jada, .dylan, .sunny, .peter, .eric:
            // 仅支持中文
            return [.ro]
        case .kiki:
            // 仅支持粤语
            return [.yue]
        }
    }

    /// 检查音色是否支持指定语种
    func supports(language: TranslateLanguage) -> Bool {
        supportedLanguages.contains(language)
    }
}

// MARK: - 翻译记录

struct TranslateRecord: Codable, Identifiable {
    let id: UUID
    let timestamp: Date
    let sourceLanguage: TranslateLanguage
    let targetLanguage: TranslateLanguage
    let originalText: String      // 识别的原文
    let translatedText: String    // 翻译结果

    init(
        id: UUID = UUID(),
        timestamp: Date = Date(),
        sourceLanguage: TranslateLanguage,
        targetLanguage: TranslateLanguage,
        originalText: String,
        translatedText: String
    ) {
        self.id = id
        self.timestamp = timestamp
        self.sourceLanguage = sourceLanguage
        self.targetLanguage = targetLanguage
        self.originalText = originalText
        self.translatedText = translatedText
    }
}

// MARK: - WebSocket 事件

enum TranslateClientEvent: String {
    case sessionUpdate = "session.update"
    case inputAudioBufferAppend = "input_audio_buffer.append"
    case inputImageBufferAppend = "input_image_buffer.append"
}

enum TranslateServerEvent: String {
    case sessionCreated = "session.created"
    case sessionUpdated = "session.updated"
    case responseCreated = "response.created"
    case responseOutputItemAdded = "response.output_item.added"
    case responseContentPartAdded = "response.content_part.added"
    case responseAudioTranscriptText = "response.audio_transcript.text"
    case responseAudioTranscriptDone = "response.audio_transcript.done"
    case responseTextDone = "response.text.done"
    case responseAudioDelta = "response.audio.delta"
    case responseAudioDone = "response.audio.done"
    case responseContentPartDone = "response.content_part.done"
    case responseOutputItemDone = "response.output_item.done"
    case responseDone = "response.done"
    case error = "error"
}
