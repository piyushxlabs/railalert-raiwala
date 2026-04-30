import 'package:flutter/foundation.dart';

class TranslationService {
  static final ValueNotifier<String> currentLanguage = ValueNotifier<String>('en');

  static void setLanguage(String langCode) {
    currentLanguage.value = langCode;
  }

  static String translate(String key) {
    final lang = currentLanguage.value;
    if (_translations[lang] != null && _translations[lang]![key] != null) {
      return _translations[lang]![key]!;
    }
    // Fallback to English
    return _translations['en']![key] ?? key;
  }

  static final Map<String, Map<String, String>> _translations = {
    'en': {
      'language_selection_title': 'Choose Language',
      'language_selection_subtitle': 'Please select your preferred language.',
      'disclaimer_appbar_title': 'Legal Disclaimer',
      'disclaimer_notice_title': 'Important Legal Notice',
      'disclaimer_body_1': 'This application is a strictly non-profit, community-driven initiative built solely to help the residents of Raiwala avoid traffic queues.',
      'disclaimer_body_2': 'It has NO official affiliation with Indian Railways or any government body.',
      'disclaimer_body_3': 'The developer, volunteers, and any operating gateman hold zero legal liability for any delays, accidents, or misinformation. The app is provided "as-is" for convenience only, and users must follow actual physical railway signals and physical gate closures at all times. By using this app, you agree that you cannot hold anyone responsible for the data shown here.',
      'agree_button': 'I Agree & Enter',
      'disagree_button': 'I Disagree',
      'dashboard_title': 'Raiwala Crossing',
      'meet_developer': 'Meet the Developer 👋',
      'made_with_love': 'Made with ❤️ for Raiwala',
      'say_hi': 'Say Hi ➔',
      'service_paused': 'SERVICE PAUSED',
      'service_paused_subtitle': 'Gateman has paused regular updates',
      'gate_open': 'GATE OPEN',
      'gate_open_subtitle': 'Road is clear — proceed normally',
      'gate_alert': '⚠ TRAIN COMING',
      'gate_alert_subtitle': 'Gate closing soon — plan your route',
      'gate_closed': 'GATE CLOSED',
      'gate_closed_subtitle': 'Wait or take an alternate route',
    },
    'hi': {
      'language_selection_title': 'भाषा चुनें',
      'language_selection_subtitle': 'कृपया अपनी पसंदीदा भाषा चुनें।',
      'disclaimer_appbar_title': 'कानूनी अस्वीकरण',
      'disclaimer_notice_title': 'महत्वपूर्ण कानूनी सूचना',
      'disclaimer_body_1': 'यह एप्लिकेशन एक गैर-लाभकारी, समुदाय-संचालित पहल है जो केवल रायवाला के निवासियों को ट्रैफिक जाम से बचाने में मदद करने के लिए बनाई गई है।',
      'disclaimer_body_2': 'इसका भारतीय रेलवे या किसी भी सरकारी निकाय से कोई आधिकारिक संबंध नहीं है।',
      'disclaimer_body_3': 'डेवलपर, स्वयंसेवक, और कोई भी ऑपरेटिंग गेटमैन किसी भी देरी, दुर्घटना, या गलत सूचना के लिए शून्य कानूनी जिम्मेदारी रखते हैं। यह ऐप केवल सुविधा के लिए "जैसी है" के आधार पर प्रदान किया गया है, और उपयोगकर्ताओं को हर समय वास्तविक भौतिक रेलवे संकेतों और फाटकों का पालन करना चाहिए। इस ऐप का उपयोग करके, आप सहमत हैं कि आप यहां दिखाए गए डेटा के लिए किसी को भी जिम्मेदार नहीं ठहरा सकते।',
      'agree_button': 'मैं सहमत हूँ और प्रवेश करें',
      'disagree_button': 'मैं असहमत हूँ',
      'dashboard_title': 'रायवाला क्रॉसिंग',
      'meet_developer': 'डेवलपर से मिलें 👋',
      'made_with_love': 'रायवाला के लिए ❤️ से बनाया गया',
      'say_hi': 'नमस्ते कहें ➔',
      'service_paused': 'सेवा रुकी हुई है',
      'service_paused_subtitle': 'गेटमैन ने नियमित अपडेट रोक दिए हैं',
      'gate_open': 'गेट खुला है',
      'gate_open_subtitle': 'सड़क साफ़ है - सामान्य रूप से आगे बढ़ें',
      'gate_alert': '⚠ ट्रेन आ रही है',
      'gate_alert_subtitle': 'गेट जल्द ही बंद हो जाएगा - अपना रास्ता चुनें',
      'gate_closed': 'गेट बंद है',
      'gate_closed_subtitle': 'प्रतीक्षा करें या कोई वैकल्पिक रास्ता लें',
    }
  };
}
