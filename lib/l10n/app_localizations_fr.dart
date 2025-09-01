// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'TaxLien.online';

  @override
  String get systemStatus => 'État du Système';

  @override
  String get playback => 'Lecture';

  @override
  String get stopped => 'Arrêté';

  @override
  String get file => 'Fichier';

  @override
  String get position => 'Position';

  @override
  String get seconds => 'sec';

  @override
  String get playbackControls => 'Contrôles de Lecture';

  @override
  String get play => 'Lire';

  @override
  String get pause => 'Pause';

  @override
  String get stop => 'Arrêter';

  @override
  String get volume => 'Volume';

  @override
  String get projectionSettings => 'Paramètres de Projection';

  @override
  String get brightness => 'Luminosité';

  @override
  String get rotation => 'Rotation';

  @override
  String get mediaFiles => 'Fichiers Média';

  @override
  String get image => 'Image';

  @override
  String get calibration => 'Calibrage';

  @override
  String get calibrationTitle => 'Calibrage de Projection';

  @override
  String get preview => 'Aperçu';

  @override
  String get offset => 'Décalage';

  @override
  String get xOffset => 'Décalage X';

  @override
  String get yOffset => 'Décalage Y';

  @override
  String get scaleRotation => 'Échelle et Rotation';

  @override
  String get scale => 'Échelle';

  @override
  String get apply => 'Appliquer';

  @override
  String get reset => 'Réinitialiser';

  @override
  String get calibrationApplied => 'Calibrage appliqué';

  @override
  String get online => 'CONNECTÉ';

  @override
  String get offline => 'DÉCONNECTÉ';

  @override
  String get languageSettings => 'Paramètres de Langue';

  @override
  String get languageChanged => 'Langue modifiée';

  @override
  String get onboardingWelcomeTitle => 'Bienvenue dans TaxLien.online';

  @override
  String get onboardingWelcomeDescription =>
      'Votre passerelle vers la liberté numérique et la connexion spirituelle';

  @override
  String get onboardingConnectionTitle => 'Se Connecter à FreeDome';

  @override
  String get onboardingConnectionDescription =>
      'Établissez une connexion sécurisée à votre réseau FreeDome';

  @override
  String get onboardingDomeControlTitle => 'Contrôle du Dôme';

  @override
  String get onboardingDomeControlDescription =>
      'Contrôlez les paramètres et configurations de votre dôme';

  @override
  String get onboardingCalibrationTitle => 'Calibrage';

  @override
  String get onboardingCalibrationDescription =>
      'Calibrez votre dôme pour des performances optimales';

  @override
  String get onboardingMediaTitle => 'Gestion des Médias';

  @override
  String get onboardingMediaDescription =>
      'Téléchargez et gérez vos fichiers média';

  @override
  String get onboardingReadyTitle => 'Vous Êtes Prêt !';

  @override
  String get onboardingReadyDescription =>
      'Commencez votre voyage vers la liberté numérique';

  @override
  String get next => 'Suivant';

  @override
  String get back => 'Retour';

  @override
  String get skip => 'Passer';

  @override
  String get getStarted => 'Commencer';

  @override
  String get skipConfirmationTitle => 'Passer l\'Onboarding ?';

  @override
  String get skipConfirmationMessage =>
      'Êtes-vous sûr de vouloir passer l\'onboarding ? Vous pouvez toujours accéder au tutoriel plus tard depuis les paramètres.';

  @override
  String get cancel => 'Annuler';

  @override
  String get connectingToFreedome => 'Connexion à FreeDome...';

  @override
  String get domeStatusActive => 'État du Dôme : Actif';

  @override
  String get open => 'Ouvrir';

  @override
  String get close => 'Fermer';

  @override
  String get calibrationProgress => 'Progrès du Calibrage';

  @override
  String mediaFilesCount(int count) {
    return 'Fichiers Média : $count éléments';
  }

  @override
  String get upload => 'Télécharger';

  @override
  String get manage => 'Gérer';

  @override
  String get serverSettings => 'Paramètres du Serveur';

  @override
  String get connectionStatus => 'État de Connexion';

  @override
  String get russian => 'Russe';

  @override
  String get ukrainian => 'Ukrainien';

  @override
  String dataLoadError(String error) {
    return 'Erreur de chargement des données : $error';
  }

  @override
  String get taxLienMarketplace => 'Marché des Privilèges Fiscaux';

  @override
  String get filters => 'Filtres';

  @override
  String get refresh => 'Actualiser';

  @override
  String get searchHint =>
      'Rechercher par adresse, propriétaire ou ID de parcelle...';

  @override
  String get clear => 'Effacer';

  @override
  String foundLiens(int count) {
    return 'Trouvé : $count privilèges';
  }

  @override
  String sortBy(String sortLabel) {
    return 'Trier par : $sortLabel';
  }

  @override
  String get retry => 'Réessayer';

  @override
  String get noLiensFound => 'Aucun privilège fiscal trouvé';

  @override
  String get tryChangingSearch =>
      'Essayez de modifier les paramètres de recherche ou les filtres';

  @override
  String stateFilter(String state) {
    return 'État : $state';
  }

  @override
  String countyFilter(String county) {
    return 'Comté : $county';
  }

  @override
  String amountFrom(String amount) {
    return 'De : $amount';
  }

  @override
  String amountTo(String amount) {
    return 'À : $amount';
  }

  @override
  String interestRateFrom(String rate) {
    return 'Taux à partir de : $rate%';
  }

  @override
  String auctionDateSort(String direction) {
    return 'Date d\'Enchère $direction';
  }

  @override
  String taxAmountSort(String direction) {
    return 'Montant d\'Impôt $direction';
  }

  @override
  String interestRateSort(String direction) {
    return 'Taux d\'Intérêt $direction';
  }

  @override
  String assessedValueSort(String direction) {
    return 'Valeur Évaluée $direction';
  }

  @override
  String redemptionDeadlineSort(String direction) {
    return 'Date Limite de Rédemption $direction';
  }

  @override
  String lienNumber(String parcelId) {
    return 'Privilège #$parcelId';
  }

  @override
  String owner(String owner) {
    return 'Propriétaire : $owner';
  }

  @override
  String get taxAmount => 'Montant d\'Impôt';

  @override
  String get interestRate => 'Taux d\'Intérêt';

  @override
  String get assessedValue => 'Valeur Évaluée';

  @override
  String get auctionDate => 'Date d\'Enchère';

  @override
  String get additionalInfo => 'Informations Supplémentaires';

  @override
  String get county => 'Comté';

  @override
  String get state => 'État';

  @override
  String get redemptionDeadline => 'Date Limite de Rédemption';

  @override
  String get status => 'Statut';

  @override
  String get buyLien => 'Acheter le Privilège';

  @override
  String get availableForPurchase => 'Disponible à l\'achat';

  @override
  String get sold => 'Vendu';

  @override
  String get redeemed => 'Racheté';

  @override
  String get foreclosed => 'Saisi';

  @override
  String get purchaseLien => 'Acheter un Privilège';

  @override
  String enterBidAmount(String amount) {
    return 'Entrez le montant de l\'enchère (minimum $amount):';
  }

  @override
  String get bidAmount => 'Montant de l\'Enchère';

  @override
  String get lienPurchasedSuccessfully => 'Privilège acheté avec succès !';

  @override
  String get purchaseError => 'Erreur d\'achat';

  @override
  String get invalidBidAmount => 'Montant d\'enchère invalide';

  @override
  String get buy => 'Acheter';

  @override
  String get profile => 'Profil';

  @override
  String get settings => 'Paramètres';

  @override
  String get notAuthorized => 'Non autorisé';

  @override
  String get loginForAccess =>
      'Connectez-vous pour accéder aux fonctionnalités';

  @override
  String get login => 'Se Connecter';

  @override
  String get register => 'S\'Inscrire';

  @override
  String get edit => 'Modifier';

  @override
  String get logout => 'Se Déconnecter';

  @override
  String get balance => 'Solde';

  @override
  String get available => 'Disponible';

  @override
  String get topUp => 'Recharger';

  @override
  String get quickActions => 'Actions Rapides';

  @override
  String get transactionHistory => 'Historique des Transactions';

  @override
  String get viewAllTransactions => 'Voir toutes les transactions';

  @override
  String get favoriteLiens => 'Privilèges Favoris';

  @override
  String get savedLiens => 'Vos privilèges sauvegardés';

  @override
  String get notifications => 'Notifications';

  @override
  String get notificationSettings => 'Paramètres de notification';

  @override
  String get help => 'Aide';

  @override
  String get appSettings => 'Paramètres de l\'Application';

  @override
  String get language => 'Langue';

  @override
  String get theme => 'Thème';

  @override
  String get dark => 'Sombre';

  @override
  String get light => 'Clair';

  @override
  String get security => 'Sécurité';

  @override
  String get securitySettings => 'Paramètres de sécurité';

  @override
  String get privacy => 'Confidentialité';

  @override
  String get privacySettings => 'Paramètres de confidentialité';

  @override
  String get aboutApp => 'À Propos de l\'Application';

  @override
  String get version => 'Version';

  @override
  String get license => 'Licence';

  @override
  String get termsOfService => 'Conditions d\'Utilisation';

  @override
  String get userAgreement => 'Accord Utilisateur';

  @override
  String get privacyPolicy => 'Politique de Confidentialité';

  @override
  String get dataProcessing => 'Traitement des données personnelles';

  @override
  String get loginToAccount => 'Se Connecter au Compte';

  @override
  String get password => 'Mot de Passe';

  @override
  String get loginSuccessful => 'Connexion réussie !';

  @override
  String get loginError => 'Erreur de connexion';

  @override
  String get registration => 'Inscription';

  @override
  String get firstName => 'Prénom';

  @override
  String get lastName => 'Nom';

  @override
  String get registrationSuccessful => 'Inscription réussie !';

  @override
  String get registrationError => 'Erreur d\'inscription';

  @override
  String get registerAccount => 'S\'Inscrire';

  @override
  String get logoutConfirmation => 'Confirmation de Déconnexion';

  @override
  String get logoutConfirmationMessage =>
      'Êtes-vous sûr de vouloir vous déconnecter ?';

  @override
  String get myInvestments => 'Mes Investissements';

  @override
  String get myLiens => 'Mes Privilèges';

  @override
  String get favorites => 'Favoris';

  @override
  String get statistics => 'Statistiques';

  @override
  String get noInvestmentsYet => 'Vous n\'avez pas encore d\'investissements';

  @override
  String get goToMarketplace =>
      'Allez sur le marché pour acheter des privilèges fiscaux';

  @override
  String get goToMarketplaceButton => 'Aller au Marché';

  @override
  String get noFavoriteLiens => 'Aucun privilège favori';

  @override
  String get addToFavoritesHint =>
      'Ajoutez des privilèges aux favoris pour un accès rapide';

  @override
  String get overallStatistics => 'Statistiques Générales';

  @override
  String get totalInvested => 'Total Investi';

  @override
  String get currentValue => 'Valeur Actuelle';

  @override
  String get profitLoss => 'Bénéfice/Perte';

  @override
  String get roi => 'ROI';

  @override
  String get statusStatistics => 'Statistiques de Statut';

  @override
  String get activeLiens => 'Privilèges Actifs';

  @override
  String get redeemedLiens => 'Privilèges Rachetés';

  @override
  String get foreclosedLiens => 'Privilèges Saisis';

  @override
  String get totalLiens => 'Total des Privilèges';

  @override
  String get monthlyReturns => 'Rendements Mensuels';

  @override
  String get profitChartInDevelopment =>
      'Graphique de Bénéfices\n(en développement)';

  @override
  String get topPerformingLiens => 'Privilèges les Plus Performants';

  @override
  String get investmentInfo => 'Informations d\'Investissement';

  @override
  String get purchaseDate => 'Date d\'Achat';

  @override
  String get purchaseAmount => 'Montant d\'Achat';

  @override
  String get daysInInvestment => 'Jours d\'Investissement';

  @override
  String get interestEarned => 'Intérêts Gagnés';

  @override
  String get redemptionDate => 'Date de Rachat';

  @override
  String get digitalFreedomGateway => 'Passerelle vers la Liberté Numérique';

  @override
  String get connection => 'Connexion';

  @override
  String get calibrationScreenComingSoon =>
      'Écran de calibration bientôt disponible';

  @override
  String get mediaManagementComingSoon =>
      'Gestion des médias bientôt disponible';

  @override
  String get lienSearch => 'Recherche de Privilège';

  @override
  String get searching => 'Recherche...';

  @override
  String get noSearchHistory => 'Aucun historique de recherche';

  @override
  String get clearSearchHistory => 'Effacer l\'historique de recherche';

  @override
  String get searchHistory => 'Historique de Recherche';

  @override
  String get recentSearches => 'Recherches Récentes';

  @override
  String get purchase => 'Acheter';

  @override
  String get searchHistoryEmpty => 'L\'historique de recherche est vide';

  @override
  String get searchQueriesWillAppearHere =>
      'Vos requêtes de recherche apparaîtront ici';

  @override
  String get nothingFound => 'Rien trouvé';

  @override
  String get tryChangingSearchQuery =>
      'Essayez de modifier votre requête de recherche';

  @override
  String foundLiensCount(int count) {
    return 'Trouvé : $count privilèges';
  }

  @override
  String daysAgo(int days) {
    return 'il y a $days jours';
  }

  @override
  String hoursAgo(int hours) {
    return 'il y a $hours heures';
  }

  @override
  String minutesAgo(int minutes) {
    return 'il y a $minutes minutes';
  }

  @override
  String get justNow => 'À l\'instant';
}
