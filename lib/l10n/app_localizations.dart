import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
    Locale('fr'),
  ];

  /// No description provided for @appName.
  ///
  /// In fr, this message translates to:
  /// **'SmartScan Assistant'**
  String get appName;

  /// No description provided for @navHome.
  ///
  /// In fr, this message translates to:
  /// **'Accueil'**
  String get navHome;

  /// No description provided for @navScan.
  ///
  /// In fr, this message translates to:
  /// **'Scanner'**
  String get navScan;

  /// No description provided for @navHistory.
  ///
  /// In fr, this message translates to:
  /// **'Historique'**
  String get navHistory;

  /// No description provided for @navSettings.
  ///
  /// In fr, this message translates to:
  /// **'Paramètres'**
  String get navSettings;

  /// No description provided for @homeTitle.
  ///
  /// In fr, this message translates to:
  /// **'Scanner & Traduire'**
  String get homeTitle;

  /// No description provided for @homeSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Votre assistant de lecture intelligent propulsé par l\'IA'**
  String get homeSubtitle;

  /// No description provided for @featureOcr.
  ///
  /// In fr, this message translates to:
  /// **'Reconnaissance de texte'**
  String get featureOcr;

  /// No description provided for @featureOcrDesc.
  ///
  /// In fr, this message translates to:
  /// **'Extrayez le texte de n\'importe quelle image ou document instantanément.'**
  String get featureOcrDesc;

  /// No description provided for @featureLang.
  ///
  /// In fr, this message translates to:
  /// **'Détection de langue'**
  String get featureLang;

  /// No description provided for @featureLangDesc.
  ///
  /// In fr, this message translates to:
  /// **'Identification automatique de la langue source du texte scanné.'**
  String get featureLangDesc;

  /// No description provided for @featureOffline.
  ///
  /// In fr, this message translates to:
  /// **'Traduction hors ligne'**
  String get featureOffline;

  /// No description provided for @featureOfflineDesc.
  ///
  /// In fr, this message translates to:
  /// **'Traduisez vos textes en Français, Anglais ou Arabe sans connexion.'**
  String get featureOfflineDesc;

  /// No description provided for @scanNow.
  ///
  /// In fr, this message translates to:
  /// **'Scanner maintenant'**
  String get scanNow;

  /// No description provided for @aboutApp.
  ///
  /// In fr, this message translates to:
  /// **'À propos de l\'application'**
  String get aboutApp;

  /// No description provided for @settingsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Paramètres'**
  String get settingsTitle;

  /// No description provided for @settingsSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Personnalisez votre expérience'**
  String get settingsSubtitle;

  /// No description provided for @settingsAppearance.
  ///
  /// In fr, this message translates to:
  /// **'APPARENCE & LANGUE'**
  String get settingsAppearance;

  /// No description provided for @settingsPreferences.
  ///
  /// In fr, this message translates to:
  /// **'PRÉFÉRENCES'**
  String get settingsPreferences;

  /// No description provided for @settingsApp.
  ///
  /// In fr, this message translates to:
  /// **'APPLICATION'**
  String get settingsApp;

  /// No description provided for @darkMode.
  ///
  /// In fr, this message translates to:
  /// **'Mode Sombre'**
  String get darkMode;

  /// No description provided for @interfaceLanguage.
  ///
  /// In fr, this message translates to:
  /// **'Langue de l\'interface'**
  String get interfaceLanguage;

  /// No description provided for @soundEffects.
  ///
  /// In fr, this message translates to:
  /// **'Effets sonores'**
  String get soundEffects;

  /// No description provided for @vibrations.
  ///
  /// In fr, this message translates to:
  /// **'Vibrations'**
  String get vibrations;

  /// No description provided for @about.
  ///
  /// In fr, this message translates to:
  /// **'À propos'**
  String get about;

  /// No description provided for @historyTitle.
  ///
  /// In fr, this message translates to:
  /// **'Historique'**
  String get historyTitle;

  /// No description provided for @scanDetails.
  ///
  /// In fr, this message translates to:
  /// **'Détails du scan'**
  String get scanDetails;

  /// No description provided for @detectedText.
  ///
  /// In fr, this message translates to:
  /// **'Texte détecté'**
  String get detectedText;

  /// No description provided for @translation.
  ///
  /// In fr, this message translates to:
  /// **'Traduction'**
  String get translation;

  /// No description provided for @close.
  ///
  /// In fr, this message translates to:
  /// **'Fermer'**
  String get close;

  /// No description provided for @noHistory.
  ///
  /// In fr, this message translates to:
  /// **'Aucun scan pour le moment'**
  String get noHistory;

  /// No description provided for @saveSuccess.
  ///
  /// In fr, this message translates to:
  /// **'Scan enregistré dans l\'historique'**
  String get saveSuccess;

  /// No description provided for @aboutTitle.
  ///
  /// In fr, this message translates to:
  /// **'À propos'**
  String get aboutTitle;

  /// No description provided for @aboutDesc.
  ///
  /// In fr, this message translates to:
  /// **'SmartScan Assistant est une application intelligente qui vous permet de numériser n\'importe quel texte physique et de le traduire instantanément.'**
  String get aboutDesc;

  /// No description provided for @version.
  ///
  /// In fr, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @developer.
  ///
  /// In fr, this message translates to:
  /// **'Développeur'**
  String get developer;

  /// No description provided for @resultsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Résultats du Scan'**
  String get resultsTitle;

  /// No description provided for @scanSaved.
  ///
  /// In fr, this message translates to:
  /// **'Scan enregistré dans l\'historique'**
  String get scanSaved;

  /// No description provided for @recognizedText.
  ///
  /// In fr, this message translates to:
  /// **'Texte Reconnu'**
  String get recognizedText;

  /// No description provided for @translateTo.
  ///
  /// In fr, this message translates to:
  /// **'Traduire en :'**
  String get translateTo;

  /// No description provided for @backHome.
  ///
  /// In fr, this message translates to:
  /// **'Retour à l\'accueil'**
  String get backHome;

  /// No description provided for @onboarding1Title.
  ///
  /// In fr, this message translates to:
  /// **'+ 10 langues supportées'**
  String get onboarding1Title;

  /// No description provided for @onboarding1Desc.
  ///
  /// In fr, this message translates to:
  /// **'Détectez et traduisez automatiquement plus de 10 langues du monde entier.'**
  String get onboarding1Desc;

  /// No description provided for @onboarding2Title.
  ///
  /// In fr, this message translates to:
  /// **'Traduction par caméra'**
  String get onboarding2Title;

  /// No description provided for @onboarding2Desc.
  ///
  /// In fr, this message translates to:
  /// **'Pointez votre caméra vers n\'importe quel texte et obtenez une traduction instantanée.'**
  String get onboarding2Desc;

  /// No description provided for @onboarding3Title.
  ///
  /// In fr, this message translates to:
  /// **'Traduction et lecture vocale'**
  String get onboarding3Title;

  /// No description provided for @onboarding3Desc.
  ///
  /// In fr, this message translates to:
  /// **'Écoutez la traduction avec des voix naturelles dans la langue de votre choix.'**
  String get onboarding3Desc;

  /// No description provided for @onboarding4Title.
  ///
  /// In fr, this message translates to:
  /// **'Traduction Hors-ligne'**
  String get onboarding4Title;

  /// No description provided for @onboarding4Desc.
  ///
  /// In fr, this message translates to:
  /// **'Continuez à traduire vos textes même sans connexion internet.'**
  String get onboarding4Desc;

  /// No description provided for @onboardingSkip.
  ///
  /// In fr, this message translates to:
  /// **'Passer'**
  String get onboardingSkip;

  /// No description provided for @onboardingStart.
  ///
  /// In fr, this message translates to:
  /// **'Commencer'**
  String get onboardingStart;

  /// No description provided for @onboardingNext.
  ///
  /// In fr, this message translates to:
  /// **'Suivant'**
  String get onboardingNext;

  /// No description provided for @onboardingFinish.
  ///
  /// In fr, this message translates to:
  /// **'Terminer'**
  String get onboardingFinish;

  /// No description provided for @onboardingWelcome.
  ///
  /// In fr, this message translates to:
  /// **'Traduisez le monde autour de vous'**
  String get onboardingWelcome;

  /// No description provided for @scannerTitle.
  ///
  /// In fr, this message translates to:
  /// **'Scanner un document'**
  String get scannerTitle;

  /// No description provided for @scannerPrompt.
  ///
  /// In fr, this message translates to:
  /// **'Alignez le texte dans le cadre'**
  String get scannerPrompt;

  /// No description provided for @scannerAnalysis.
  ///
  /// In fr, this message translates to:
  /// **'Analyse en cours...'**
  String get scannerAnalysis;

  /// No description provided for @share.
  ///
  /// In fr, this message translates to:
  /// **'Partager'**
  String get share;

  /// No description provided for @retry.
  ///
  /// In fr, this message translates to:
  /// **'Réessayer'**
  String get retry;

  /// No description provided for @match.
  ///
  /// In fr, this message translates to:
  /// **'Correspondance'**
  String get match;

  /// No description provided for @copy.
  ///
  /// In fr, this message translates to:
  /// **'Copier'**
  String get copy;

  /// No description provided for @detected.
  ///
  /// In fr, this message translates to:
  /// **'détecté'**
  String get detected;

  /// No description provided for @mlKitSdk.
  ///
  /// In fr, this message translates to:
  /// **'Firebase ML Kit SDK'**
  String get mlKitSdk;

  /// No description provided for @featureOcrTitle.
  ///
  /// In fr, this message translates to:
  /// **'Reconnaissance de texte (Vision)'**
  String get featureOcrTitle;

  /// No description provided for @featureLangTitle.
  ///
  /// In fr, this message translates to:
  /// **'Identification de langue (NLP)'**
  String get featureLangTitle;

  /// No description provided for @featureTradTitle.
  ///
  /// In fr, this message translates to:
  /// **'Traduction (NLP)'**
  String get featureTradTitle;

  /// No description provided for @developedWith.
  ///
  /// In fr, this message translates to:
  /// **'Développé avec Flutter & Firebase ML Kit'**
  String get developedWith;

  /// No description provided for @deleteConfirmAll.
  ///
  /// In fr, this message translates to:
  /// **'Voulez-vous vraiment effacer tout l\'historique ?'**
  String get deleteConfirmAll;

  /// No description provided for @deleteConfirmSelected.
  ///
  /// In fr, this message translates to:
  /// **'Voulez-vous vraiment supprimer les éléments sélectionnés ?'**
  String get deleteConfirmSelected;

  /// No description provided for @deleteAll.
  ///
  /// In fr, this message translates to:
  /// **'Effacer tout'**
  String get deleteAll;

  /// No description provided for @delete.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer'**
  String get delete;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
