// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'TaxLien.online';

  @override
  String get systemStatus => 'Estado del Sistema';

  @override
  String get playback => 'Reproducción';

  @override
  String get stopped => 'Detenido';

  @override
  String get file => 'Archivo';

  @override
  String get position => 'Posición';

  @override
  String get seconds => 'seg';

  @override
  String get playbackControls => 'Controles de Reproducción';

  @override
  String get play => 'Reproducir';

  @override
  String get pause => 'Pausa';

  @override
  String get stop => 'Detener';

  @override
  String get volume => 'Volumen';

  @override
  String get projectionSettings => 'Configuración de Proyección';

  @override
  String get brightness => 'Brillo';

  @override
  String get rotation => 'Rotación';

  @override
  String get mediaFiles => 'Archivos Multimedia';

  @override
  String get image => 'Imagen';

  @override
  String get calibration => 'Calibración';

  @override
  String get calibrationTitle => 'Calibración de Proyección';

  @override
  String get preview => 'Vista Previa';

  @override
  String get offset => 'Desplazamiento';

  @override
  String get xOffset => 'Desplazamiento X';

  @override
  String get yOffset => 'Desplazamiento Y';

  @override
  String get scaleRotation => 'Escala y Rotación';

  @override
  String get scale => 'Escala';

  @override
  String get apply => 'Aplicar';

  @override
  String get reset => 'Restablecer';

  @override
  String get calibrationApplied => 'Calibración aplicada';

  @override
  String get online => 'CONECTADO';

  @override
  String get offline => 'DESCONECTADO';

  @override
  String get languageSettings => 'Configuración de Idioma';

  @override
  String get languageChanged => 'Idioma cambiado';

  @override
  String get onboardingWelcomeTitle => 'Bienvenido a TaxLien.online';

  @override
  String get onboardingWelcomeDescription =>
      'Tu puerta de entrada a la libertad digital y la conexión espiritual';

  @override
  String get onboardingConnectionTitle => 'Conectar a FreeDome';

  @override
  String get onboardingConnectionDescription =>
      'Establece una conexión segura a tu red FreeDome';

  @override
  String get onboardingDomeControlTitle => 'Control de Cúpula';

  @override
  String get onboardingDomeControlDescription =>
      'Controla la configuración y configuraciones de tu cúpula';

  @override
  String get onboardingCalibrationTitle => 'Calibración';

  @override
  String get onboardingCalibrationDescription =>
      'Calibra tu cúpula para un rendimiento óptimo';

  @override
  String get onboardingMediaTitle => 'Gestión de Medios';

  @override
  String get onboardingMediaDescription =>
      'Sube y gestiona tus archivos multimedia';

  @override
  String get onboardingReadyTitle => '¡Estás Listo!';

  @override
  String get onboardingReadyDescription =>
      'Comienza tu viaje hacia la libertad digital';

  @override
  String get next => 'Siguiente';

  @override
  String get back => 'Atrás';

  @override
  String get skip => 'Omitir';

  @override
  String get getStarted => 'Comenzar';

  @override
  String get skipConfirmationTitle => '¿Omitir Onboarding?';

  @override
  String get skipConfirmationMessage =>
      '¿Estás seguro de que quieres omitir el onboarding? Siempre puedes acceder al tutorial más tarde desde la configuración.';

  @override
  String get cancel => 'Cancelar';

  @override
  String get connectingToFreedome => 'Conectando a FreeDome...';

  @override
  String get domeStatusActive => 'Estado de Cúpula: Activo';

  @override
  String get open => 'Abrir';

  @override
  String get close => 'Cerrar';

  @override
  String get calibrationProgress => 'Progreso de Calibración';

  @override
  String mediaFilesCount(int count) {
    return 'Archivos Multimedia: $count elementos';
  }

  @override
  String get upload => 'Subir';

  @override
  String get manage => 'Gestionar';

  @override
  String get serverSettings => 'Configuración del Servidor';

  @override
  String get connectionStatus => 'Estado de Conexión';

  @override
  String get russian => 'Ruso';

  @override
  String get ukrainian => 'Ucraniano';

  @override
  String get english => 'English';

  @override
  String get chinese => 'Chinese';

  @override
  String get hindi => 'Hindi';

  @override
  String get thai => 'Thai';

  @override
  String dataLoadError(String error) {
    return 'Error al cargar datos: $error';
  }

  @override
  String get taxLienMarketplace => 'Mercado de Gravamen Fiscal';

  @override
  String get filters => 'Filtros';

  @override
  String get refresh => 'Actualizar';

  @override
  String get searchHint =>
      'Buscar por dirección, propietario o ID de parcela...';

  @override
  String get clear => 'Limpiar';

  @override
  String foundLiens(int count) {
    return 'Encontrados: $count gravámenes';
  }

  @override
  String sortBy(String sortLabel) {
    return 'Ordenar por: $sortLabel';
  }

  @override
  String get retry => 'Reintentar';

  @override
  String get noLiensFound => 'No se encontraron gravámenes fiscales';

  @override
  String get tryChangingSearch =>
      'Intenta cambiar los parámetros de búsqueda o filtros';

  @override
  String stateFilter(String state) {
    return 'Estado: $state';
  }

  @override
  String countyFilter(String county) {
    return 'Condado: $county';
  }

  @override
  String amountFrom(String amount) {
    return 'Desde: $amount';
  }

  @override
  String amountTo(String amount) {
    return 'Hasta: $amount';
  }

  @override
  String interestRateFrom(String rate) {
    return 'Tasa desde: $rate%';
  }

  @override
  String auctionDateSort(String direction) {
    return 'Fecha de Subasta $direction';
  }

  @override
  String taxAmountSort(String direction) {
    return 'Cantidad de Impuesto $direction';
  }

  @override
  String interestRateSort(String direction) {
    return 'Tasa de Interés $direction';
  }

  @override
  String assessedValueSort(String direction) {
    return 'Valor Evaluado $direction';
  }

  @override
  String redemptionDeadlineSort(String direction) {
    return 'Fecha Límite de Redención $direction';
  }

  @override
  String lienNumber(String parcelId) {
    return 'Gravamen #$parcelId';
  }

  @override
  String owner(String owner) {
    return 'Propietario: $owner';
  }

  @override
  String get taxAmount => 'Cantidad de Impuesto';

  @override
  String get interestRate => 'Tasa de Interés';

  @override
  String get assessedValue => 'Valor Evaluado';

  @override
  String get auctionDate => 'Fecha de Subasta';

  @override
  String get additionalInfo => 'Información Adicional';

  @override
  String get county => 'Condado';

  @override
  String get state => 'Estado';

  @override
  String get redemptionDeadline => 'Fecha Límite de Redención';

  @override
  String get status => 'Estado';

  @override
  String get buyLien => 'Comprar Gravamen';

  @override
  String get availableForPurchase => 'Disponible para compra';

  @override
  String get sold => 'Vendido';

  @override
  String get redeemed => 'Redimido';

  @override
  String get foreclosed => 'Embargado';

  @override
  String get purchaseLien => 'Comprar Gravamen';

  @override
  String enterBidAmount(String amount) {
    return 'Ingresa el monto de la oferta (mínimo $amount):';
  }

  @override
  String get bidAmount => 'Monto de Oferta';

  @override
  String get lienPurchasedSuccessfully => '¡Gravamen comprado exitosamente!';

  @override
  String get purchaseError => 'Error en la compra';

  @override
  String get invalidBidAmount => 'Monto de oferta inválido';

  @override
  String get buy => 'Comprar';

  @override
  String get profile => 'Perfil';

  @override
  String get settings => 'Configuración';

  @override
  String get notAuthorized => 'No autorizado';

  @override
  String get loginForAccess => 'Inicia sesión para acceder a las funciones';

  @override
  String get login => 'Iniciar Sesión';

  @override
  String get register => 'Registrarse';

  @override
  String get edit => 'Editar';

  @override
  String get logout => 'Cerrar Sesión';

  @override
  String get balance => 'Saldo';

  @override
  String get available => 'Disponible';

  @override
  String get topUp => 'Recargar';

  @override
  String get quickActions => 'Acciones Rápidas';

  @override
  String get transactionHistory => 'Historial de Transacciones';

  @override
  String get viewAllTransactions => 'Ver todas las transacciones';

  @override
  String get favoriteLiens => 'Gravámenes Favoritos';

  @override
  String get savedLiens => 'Tus gravámenes guardados';

  @override
  String get notifications => 'Notificaciones';

  @override
  String get notificationSettings => 'Configuración de notificaciones';

  @override
  String get help => 'Ayuda';

  @override
  String get appSettings => 'Configuración de la Aplicación';

  @override
  String get language => 'Idioma';

  @override
  String get theme => 'Tema';

  @override
  String get dark => 'Oscuro';

  @override
  String get light => 'Claro';

  @override
  String get security => 'Seguridad';

  @override
  String get securitySettings => 'Configuración de seguridad';

  @override
  String get privacy => 'Privacidad';

  @override
  String get privacySettings => 'Configuración de privacidad';

  @override
  String get aboutApp => 'Acerca de la Aplicación';

  @override
  String get version => 'Versión';

  @override
  String get license => 'Licencia';

  @override
  String get termsOfService => 'Términos de Servicio';

  @override
  String get userAgreement => 'Acuerdo de Usuario';

  @override
  String get privacyPolicy => 'Política de Privacidad';

  @override
  String get dataProcessing => 'Procesamiento de datos personales';

  @override
  String get loginToAccount => 'Iniciar Sesión en la Cuenta';

  @override
  String get password => 'Contraseña';

  @override
  String get loginSuccessful => '¡Inicio de sesión exitoso!';

  @override
  String get loginError => 'Error de inicio de sesión';

  @override
  String get registration => 'Registro';

  @override
  String get firstName => 'Nombre';

  @override
  String get lastName => 'Apellido';

  @override
  String get registrationSuccessful => '¡Registro exitoso!';

  @override
  String get registrationError => 'Error de registro';

  @override
  String get registerAccount => 'Registrarse';

  @override
  String get logoutConfirmation => 'Confirmación de Cierre de Sesión';

  @override
  String get logoutConfirmationMessage =>
      '¿Estás seguro de que quieres cerrar sesión?';

  @override
  String get myInvestments => 'Mis Inversiones';

  @override
  String get myLiens => 'Mis Gravámenes';

  @override
  String get favorites => 'Favoritos';

  @override
  String get statistics => 'Estadísticas';

  @override
  String get noInvestmentsYet => 'Aún no tienes ninguna inversión';

  @override
  String get goToMarketplace =>
      'Ve al mercado para comprar gravámenes fiscales';

  @override
  String get goToMarketplaceButton => 'Ir al Mercado';

  @override
  String get noFavoriteLiens => 'No hay gravámenes favoritos';

  @override
  String get addToFavoritesHint =>
      'Agrega gravámenes a favoritos para acceso rápido';

  @override
  String get overallStatistics => 'Estadísticas Generales';

  @override
  String get totalInvested => 'Total Invertido';

  @override
  String get currentValue => 'Valor Actual';

  @override
  String get profitLoss => 'Ganancia/Pérdida';

  @override
  String get roi => 'ROI';

  @override
  String get statusStatistics => 'Estadísticas de Estado';

  @override
  String get activeLiens => 'Gravámenes Activos';

  @override
  String get redeemedLiens => 'Gravámenes Redimidos';

  @override
  String get foreclosedLiens => 'Gravámenes Embargados';

  @override
  String get totalLiens => 'Total de Gravámenes';

  @override
  String get monthlyReturns => 'Retornos Mensuales';

  @override
  String get profitChartInDevelopment =>
      'Gráfico de Ganancias\n(en desarrollo)';

  @override
  String get topPerformingLiens => 'Gravámenes de Mejor Rendimiento';

  @override
  String get investmentInfo => 'Información de Inversión';

  @override
  String get purchaseDate => 'Fecha de Compra';

  @override
  String get purchaseAmount => 'Monto de Compra';

  @override
  String get daysInInvestment => 'Días en la Inversión';

  @override
  String get interestEarned => 'Interés Ganado';

  @override
  String get redemptionDate => 'Fecha de Redención';

  @override
  String get digitalFreedomGateway => 'Puerta de Entrada a la Libertad Digital';

  @override
  String get connection => 'Conexión';

  @override
  String get calibrationScreenComingSoon =>
      'Pantalla de calibración próximamente';

  @override
  String get mediaManagementComingSoon => 'Gestión de medios próximamente';

  @override
  String get lienSearch => 'Búsqueda de Gravamen';

  @override
  String get searching => 'Buscando...';

  @override
  String get noSearchHistory => 'No hay historial de búsqueda';

  @override
  String get clearSearchHistory => 'Limpiar historial de búsqueda';

  @override
  String get searchHistory => 'Historial de Búsqueda';

  @override
  String get recentSearches => 'Búsquedas Recientes';

  @override
  String get purchase => 'Comprar';

  @override
  String get searchHistoryEmpty => 'El historial de búsqueda está vacío';

  @override
  String get searchQueriesWillAppearHere =>
      'Tus consultas de búsqueda aparecerán aquí';

  @override
  String get nothingFound => 'No se encontró nada';

  @override
  String get tryChangingSearchQuery =>
      'Intenta cambiar tu consulta de búsqueda';

  @override
  String foundLiensCount(int count) {
    return 'Encontrados: $count gravámenes';
  }

  @override
  String daysAgo(int days) {
    return 'hace $days días';
  }

  @override
  String hoursAgo(int hours) {
    return 'hace $hours horas';
  }

  @override
  String minutesAgo(int minutes) {
    return 'hace $minutes minutos';
  }

  @override
  String get justNow => 'Ahora mismo';
}
