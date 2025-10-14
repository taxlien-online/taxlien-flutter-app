// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'TaxLien.online';

  @override
  String get systemStatus => 'Status do Sistema';

  @override
  String get playback => 'Reprodução';

  @override
  String get stopped => 'Parado';

  @override
  String get file => 'Arquivo';

  @override
  String get position => 'Posição';

  @override
  String get seconds => 'seg';

  @override
  String get playbackControls => 'Controles de Reprodução';

  @override
  String get play => 'Reproduzir';

  @override
  String get pause => 'Pausa';

  @override
  String get stop => 'Parar';

  @override
  String get volume => 'Volume';

  @override
  String get projectionSettings => 'Configurações de Projeção';

  @override
  String get brightness => 'Brilho';

  @override
  String get rotation => 'Rotação';

  @override
  String get mediaFiles => 'Arquivos de Mídia';

  @override
  String get image => 'Imagem';

  @override
  String get calibration => 'Calibração';

  @override
  String get calibrationTitle => 'Calibração de Projeção';

  @override
  String get preview => 'Visualização';

  @override
  String get offset => 'Deslocamento';

  @override
  String get xOffset => 'Deslocamento X';

  @override
  String get yOffset => 'Deslocamento Y';

  @override
  String get scaleRotation => 'Escala e Rotação';

  @override
  String get scale => 'Escala';

  @override
  String get apply => 'Aplicar';

  @override
  String get reset => 'Redefinir';

  @override
  String get calibrationApplied => 'Calibração aplicada';

  @override
  String get online => 'CONECTADO';

  @override
  String get offline => 'DESCONECTADO';

  @override
  String get languageSettings => 'Configurações de Idioma';

  @override
  String get languageChanged => 'Idioma alterado';

  @override
  String get onboardingWelcomeTitle => 'Bem-vindo ao TaxLien.online';

  @override
  String get onboardingWelcomeDescription =>
      'Sua porta de entrada para a liberdade digital e conexão espiritual';

  @override
  String get onboardingConnectionTitle => 'Conectar ao FreeDome';

  @override
  String get onboardingConnectionDescription =>
      'Estabeleça uma conexão segura com sua rede FreeDome';

  @override
  String get onboardingDomeControlTitle => 'Controle da Cúpula';

  @override
  String get onboardingDomeControlDescription =>
      'Controle as configurações e configurações da sua cúpula';

  @override
  String get onboardingCalibrationTitle => 'Calibração';

  @override
  String get onboardingCalibrationDescription =>
      'Calibre sua cúpula para desempenho ideal';

  @override
  String get onboardingMediaTitle => 'Gerenciamento de Mídia';

  @override
  String get onboardingMediaDescription =>
      'Faça upload e gerencie seus arquivos de mídia';

  @override
  String get onboardingReadyTitle => 'Você Está Pronto!';

  @override
  String get onboardingReadyDescription =>
      'Comece sua jornada para a liberdade digital';

  @override
  String get next => 'Próximo';

  @override
  String get back => 'Voltar';

  @override
  String get skip => 'Pular';

  @override
  String get getStarted => 'Começar';

  @override
  String get skipConfirmationTitle => 'Pular Onboarding?';

  @override
  String get skipConfirmationMessage =>
      'Tem certeza de que deseja pular o onboarding? Você sempre pode acessar o tutorial mais tarde nas configurações.';

  @override
  String get cancel => 'Cancelar';

  @override
  String get connectingToFreedome => 'Conectando ao FreeDome...';

  @override
  String get domeStatusActive => 'Status da Cúpula: Ativo';

  @override
  String get open => 'Abrir';

  @override
  String get close => 'Fechar';

  @override
  String get calibrationProgress => 'Progresso da Calibração';

  @override
  String mediaFilesCount(int count) {
    return 'Arquivos de Mídia: $count itens';
  }

  @override
  String get upload => 'Enviar';

  @override
  String get manage => 'Gerenciar';

  @override
  String get serverSettings => 'Configurações do Servidor';

  @override
  String get connectionStatus => 'Status da Conexão';

  @override
  String get russian => 'Russo';

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
    return 'Erro ao carregar dados: $error';
  }

  @override
  String get taxLienMarketplace => 'Mercado de Gravames Fiscais';

  @override
  String get filters => 'Filtros';

  @override
  String get refresh => 'Atualizar';

  @override
  String get searchHint =>
      'Pesquisar por endereço, proprietário ou ID do lote...';

  @override
  String get clear => 'Limpar';

  @override
  String foundLiens(int count) {
    return 'Encontrados: $count gravames';
  }

  @override
  String sortBy(String sortLabel) {
    return 'Ordenar por: $sortLabel';
  }

  @override
  String get retry => 'Tentar Novamente';

  @override
  String get noLiensFound => 'Nenhum gravame fiscal encontrado';

  @override
  String get tryChangingSearch =>
      'Tente alterar os parâmetros de pesquisa ou filtros';

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
    return 'De: $amount';
  }

  @override
  String amountTo(String amount) {
    return 'Até: $amount';
  }

  @override
  String interestRateFrom(String rate) {
    return 'Taxa a partir de: $rate%';
  }

  @override
  String auctionDateSort(String direction) {
    return 'Data do Leilão $direction';
  }

  @override
  String taxAmountSort(String direction) {
    return 'Valor do Imposto $direction';
  }

  @override
  String interestRateSort(String direction) {
    return 'Taxa de Juros $direction';
  }

  @override
  String assessedValueSort(String direction) {
    return 'Valor Avaliado $direction';
  }

  @override
  String redemptionDeadlineSort(String direction) {
    return 'Prazo de Resgate $direction';
  }

  @override
  String lienNumber(String parcelId) {
    return 'Gravame #$parcelId';
  }

  @override
  String owner(String owner) {
    return 'Proprietário: $owner';
  }

  @override
  String get taxAmount => 'Valor do Imposto';

  @override
  String get interestRate => 'Taxa de Juros';

  @override
  String get assessedValue => 'Valor Avaliado';

  @override
  String get auctionDate => 'Data do Leilão';

  @override
  String get additionalInfo => 'Informações Adicionais';

  @override
  String get county => 'Condado';

  @override
  String get state => 'Estado';

  @override
  String get redemptionDeadline => 'Prazo de Resgate';

  @override
  String get status => 'Status';

  @override
  String get buyLien => 'Comprar Gravame';

  @override
  String get availableForPurchase => 'Disponível para compra';

  @override
  String get sold => 'Vendido';

  @override
  String get redeemed => 'Resgatado';

  @override
  String get foreclosed => 'Executado';

  @override
  String get purchaseLien => 'Comprar Gravame';

  @override
  String enterBidAmount(String amount) {
    return 'Digite o valor do lance (mínimo $amount):';
  }

  @override
  String get bidAmount => 'Valor do Lance';

  @override
  String get lienPurchasedSuccessfully => 'Gravame comprado com sucesso!';

  @override
  String get purchaseError => 'Erro na compra';

  @override
  String get invalidBidAmount => 'Valor do lance inválido';

  @override
  String get buy => 'Comprar';

  @override
  String get profile => 'Perfil';

  @override
  String get settings => 'Configurações';

  @override
  String get notAuthorized => 'Não autorizado';

  @override
  String get loginForAccess => 'Faça login para acessar os recursos';

  @override
  String get login => 'Entrar';

  @override
  String get register => 'Registrar';

  @override
  String get edit => 'Editar';

  @override
  String get logout => 'Sair';

  @override
  String get balance => 'Saldo';

  @override
  String get available => 'Disponível';

  @override
  String get topUp => 'Recarregar';

  @override
  String get quickActions => 'Ações Rápidas';

  @override
  String get transactionHistory => 'Histórico de Transações';

  @override
  String get viewAllTransactions => 'Ver todas as transações';

  @override
  String get favoriteLiens => 'Gravames Favoritos';

  @override
  String get savedLiens => 'Seus gravames salvos';

  @override
  String get notifications => 'Notificações';

  @override
  String get notificationSettings => 'Configurações de notificação';

  @override
  String get help => 'Ajuda';

  @override
  String get appSettings => 'Configurações do Aplicativo';

  @override
  String get language => 'Idioma';

  @override
  String get theme => 'Tema';

  @override
  String get dark => 'Escuro';

  @override
  String get light => 'Claro';

  @override
  String get security => 'Segurança';

  @override
  String get securitySettings => 'Configurações de segurança';

  @override
  String get privacy => 'Privacidade';

  @override
  String get privacySettings => 'Configurações de privacidade';

  @override
  String get aboutApp => 'Sobre o Aplicativo';

  @override
  String get version => 'Versão';

  @override
  String get license => 'Licença';

  @override
  String get termsOfService => 'Termos de Serviço';

  @override
  String get userAgreement => 'Acordo do Usuário';

  @override
  String get privacyPolicy => 'Política de Privacidade';

  @override
  String get dataProcessing => 'Processamento de dados pessoais';

  @override
  String get loginToAccount => 'Entrar na Conta';

  @override
  String get password => 'Senha';

  @override
  String get loginSuccessful => 'Login bem-sucedido!';

  @override
  String get loginError => 'Erro de login';

  @override
  String get registration => 'Registro';

  @override
  String get firstName => 'Nome';

  @override
  String get lastName => 'Sobrenome';

  @override
  String get registrationSuccessful => 'Registro bem-sucedido!';

  @override
  String get registrationError => 'Erro de registro';

  @override
  String get registerAccount => 'Registrar';

  @override
  String get logoutConfirmation => 'Confirmação de Logout';

  @override
  String get logoutConfirmationMessage => 'Tem certeza de que deseja sair?';

  @override
  String get myInvestments => 'My Investments';

  @override
  String get myLiens => 'My Liens';

  @override
  String get favorites => 'Favorites';

  @override
  String get statistics => 'Statistics';

  @override
  String get noInvestmentsYet => 'You don\'t have any investments yet';

  @override
  String get goToMarketplace => 'Go to marketplace to buy tax liens';

  @override
  String get goToMarketplaceButton => 'Go to Marketplace';

  @override
  String get noFavoriteLiens => 'No favorite liens';

  @override
  String get addToFavoritesHint => 'Add liens to favorites for quick access';

  @override
  String get overallStatistics => 'Overall Statistics';

  @override
  String get totalInvested => 'Total Invested';

  @override
  String get currentValue => 'Current Value';

  @override
  String get profitLoss => 'Profit/Loss';

  @override
  String get roi => 'ROI';

  @override
  String get statusStatistics => 'Status Statistics';

  @override
  String get activeLiens => 'Active Liens';

  @override
  String get redeemedLiens => 'Redeemed Liens';

  @override
  String get foreclosedLiens => 'Foreclosed Liens';

  @override
  String get totalLiens => 'Total Liens';

  @override
  String get monthlyReturns => 'Monthly Returns';

  @override
  String get profitChartInDevelopment => 'Profit Chart\n(in development)';

  @override
  String get topPerformingLiens => 'Top Performing Liens';

  @override
  String get investmentInfo => 'Investment Information';

  @override
  String get purchaseDate => 'Purchase Date';

  @override
  String get purchaseAmount => 'Purchase Amount';

  @override
  String get daysInInvestment => 'Days in Investment';

  @override
  String get interestEarned => 'Interest Earned';

  @override
  String get redemptionDate => 'Redemption Date';

  @override
  String get digitalFreedomGateway => 'Digital Freedom Gateway';

  @override
  String get connection => 'Connection';

  @override
  String get calibrationScreenComingSoon => 'Calibration screen coming soon';

  @override
  String get mediaManagementComingSoon => 'Media management coming soon';

  @override
  String get lienSearch => 'Lien Search';

  @override
  String get searching => 'Searching...';

  @override
  String get noSearchHistory => 'No search history';

  @override
  String get clearSearchHistory => 'Clear search history';

  @override
  String get searchHistory => 'Search History';

  @override
  String get recentSearches => 'Recent Searches';

  @override
  String get purchase => 'Purchase';

  @override
  String get searchHistoryEmpty => 'Search history is empty';

  @override
  String get searchQueriesWillAppearHere =>
      'Your search queries will appear here';

  @override
  String get nothingFound => 'Nothing found';

  @override
  String get tryChangingSearchQuery => 'Try changing your search query';

  @override
  String foundLiensCount(int count) {
    return 'Found: $count liens';
  }

  @override
  String daysAgo(int days) {
    return '$days days ago';
  }

  @override
  String hoursAgo(int hours) {
    return '$hours hours ago';
  }

  @override
  String minutesAgo(int minutes) {
    return '$minutes minutes ago';
  }

  @override
  String get justNow => 'Just now';
}
