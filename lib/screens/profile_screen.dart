import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../services/auth_service.dart';
import '../services/theme_service.dart';
import '../services/localization_service.dart';
import '../services/onboarding_service.dart';
// Services replaced with flutter_nft and flutter_icp libraries
import 'package:TaxLien.online/core/mocks/nft_mocks.dart';
// import 'package:TaxLien.online/core/mocks/nft_mocks.dart';
import '../core/constants/app_constants.dart';
import 'wallet_settings_screen.dart';
import 'yuku_marketplace_screen.dart';
import 'yuku_integration_demo_screen.dart';
import 'plug_wallet_screen.dart';

class ProfileScreen extends StatefulWidget {
  final AuthService authService;
  final ThemeService themeService;
  final LocalizationService localizationService;
  final OnboardingService onboardingService;
  // Services replaced with NFT client
  final NFTClient nftClient;

  const ProfileScreen({
    super.key,
    required this.authService,
    required this.themeService,
    required this.localizationService,
    required this.onboardingService,
    required this.nftClient,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)?.profile ?? 'Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => _showSettings(context),
            tooltip: AppLocalizations.of(context)?.settings ?? 'Settings',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Информация о пользователе
            _buildUserInfoCard(),

            const SizedBox(height: 16),

            // Баланс и финансы
            _buildBalanceCard(),

            const SizedBox(height: 16),

            // Быстрые действия
            _buildQuickActionsCard(),

            const SizedBox(height: 16),

            // Настройки приложения
            _buildAppSettingsCard(),

            const SizedBox(height: 16),

            // Информация о приложении
            _buildAppInfoCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfoCard() {
    final user = widget.authService.currentUser;

    if (user == null) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Icon(
                Icons.person_outline,
                size: 64,
                color: Colors.grey,
              ),
              const SizedBox(height: 16),
              Text(
                AppLocalizations.of(context)?.notAuthorized ?? 'Not authorized',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                AppLocalizations.of(context)?.loginForAccess ??
                    'Log in to access features',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _showLoginDialog(context),
                      child:
                          Text(AppLocalizations.of(context)?.login ?? 'Login'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _showRegisterDialog(context),
                      child: Text(
                          AppLocalizations.of(context)?.register ?? 'Register'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: Text(
                user.firstName[0].toUpperCase(),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              user.fullName,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              user.email,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            if (user.phone != null) ...[
              const SizedBox(height: 4),
              Text(
                user.phone!,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ],
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _showEditProfileDialog(context),
                    child: Text(AppLocalizations.of(context)?.edit ?? 'Edit'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _showLogoutDialog(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                    child:
                        Text(AppLocalizations.of(context)?.logout ?? 'Logout'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBalanceCard() {
    final user = widget.authService.currentUser;

    if (user == null) {
      return const SizedBox.shrink();
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.account_balance_wallet),
                const SizedBox(width: 8),
                Text(
                  AppLocalizations.of(context)?.balance ?? 'Balance',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)?.available ?? 'Available',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      Text(
                        '\$${user.balance.toStringAsFixed(2)}',
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () => _showAddFundsDialog(context),
                  child: Text(AppLocalizations.of(context)?.topUp ?? 'Top Up'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionsCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)?.quickActions ?? 'Quick Actions',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            _buildActionTile(
              icon: Icons.store,
              title: 'Yuku Marketplace',
              subtitle: 'Buy and sell NFT tax liens',
              onTap: () => _showYukuMarketplace(context),
            ),
            _buildActionTile(
              icon: Icons.play_circle_outline,
              title: 'Yuku Demo',
              subtitle: 'See integration features',
              onTap: () => _showYukuDemo(context),
            ),
            _buildActionTile(
              icon: Icons.history,
              title: AppLocalizations.of(context)?.transactionHistory ??
                  'Transaction History',
              subtitle: AppLocalizations.of(context)?.viewAllTransactions ??
                  'View all transactions',
              onTap: () => _showTransactionHistory(context),
            ),
            _buildActionTile(
              icon: Icons.favorite,
              title: AppLocalizations.of(context)?.favoriteLiens ??
                  'Favorite Liens',
              subtitle: AppLocalizations.of(context)?.savedLiens ??
                  'Your saved liens',
              onTap: () => _showFavorites(context),
            ),
            _buildActionTile(
              icon: Icons.notifications,
              title: AppLocalizations.of(context)?.notifications ??
                  'Notifications',
              subtitle: AppLocalizations.of(context)?.notificationSettings ??
                  'Notification settings',
              onTap: () => _showNotificationsSettings(context),
            ),
            _buildActionTile(
              icon: Icons.account_balance_wallet,
              title: 'Plug Wallet',
              subtitle: 'Manage ICP tokens and NFTs',
              onTap: () => _showPlugWallet(context),
            ),
            _buildActionTile(
              icon: Icons.help_outline,
              title: AppLocalizations.of(context)?.help ?? 'Help',
              subtitle: 'FAQ and support',
              onTap: () => _showHelp(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppSettingsCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)?.appSettings ?? 'App Settings',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            _buildSettingTile(
              icon: Icons.language,
              title: AppLocalizations.of(context)?.language ?? 'Language',
              subtitle: AppLocalizations.of(context)?.russian ?? 'Russian',
              onTap: () => _showLanguageSettings(context),
            ),
            _buildSettingTile(
              icon: Icons.dark_mode,
              title: AppLocalizations.of(context)?.theme ?? 'Theme',
              subtitle: widget.themeService.isDarkMode
                  ? (AppLocalizations.of(context)?.dark ?? 'Dark')
                  : (AppLocalizations.of(context)?.light ?? 'Light'),
              onTap: () {
                widget.themeService.toggleTheme();
                setState(() {});
              },
            ),
            _buildSettingTile(
              icon: Icons.security,
              title: AppLocalizations.of(context)?.security ?? 'Security',
              subtitle: AppLocalizations.of(context)?.securitySettings ??
                  'Security settings',
              onTap: () => _showSecuritySettings(context),
            ),
            _buildSettingTile(
              icon: Icons.privacy_tip,
              title: AppLocalizations.of(context)?.privacy ?? 'Privacy',
              subtitle: AppLocalizations.of(context)?.privacySettings ??
                  'Privacy settings',
              onTap: () => _showPrivacySettings(context),
            ),
            _buildSettingTile(
              icon: Icons.account_balance_wallet,
              title: 'Wallet Settings',
              subtitle: widget.nftClient
                          .getWalletProvider(BlockchainNetwork.icp)
                          ?.isConnected ==
                      true
                  ? 'Connected: Plug Wallet'
                  : 'Not connected',
              onTap: () => _showWalletSettings(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppInfoCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)?.aboutApp ?? 'About App',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            _buildInfoTile(
              icon: Icons.info_outline,
              title: AppLocalizations.of(context)?.version ?? 'Version',
              subtitle: '1.0.0',
            ),
            _buildInfoTile(
              icon: Icons.description,
              title: AppLocalizations.of(context)?.license ?? 'License',
              subtitle: 'MIT License',
              onTap: () => _showLicense(context),
            ),
            _buildInfoTile(
              icon: Icons.description,
              title: AppLocalizations.of(context)?.termsOfService ??
                  'Terms of Service',
              subtitle: AppLocalizations.of(context)?.userAgreement ??
                  'User Agreement',
              onTap: () => _showTermsOfService(context),
            ),
            _buildInfoTile(
              icon: Icons.description,
              title: AppLocalizations.of(context)?.privacyPolicy ??
                  'Privacy Policy',
              subtitle: AppLocalizations.of(context)?.dataProcessing ??
                  'Personal data processing',
              onTap: () => _showPrivacyPolicy(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing:
          onTap != null ? const Icon(Icons.arrow_forward_ios, size: 16) : null,
      onTap: onTap,
    );
  }

  // Диалоги
  void _showLoginDialog(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
            AppLocalizations.of(context)?.loginToAccount ?? 'Login to Account'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)?.password ?? 'Password',
                border: const OutlineInputBorder(),
              ),
              obscureText: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)?.cancel ?? 'Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final success = await widget.authService.login(
                email: emailController.text,
                password: passwordController.text,
              );
              if (success && context.mounted) {
                Navigator.pop(context);
                setState(() {});
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text(
                          AppLocalizations.of(context)?.loginSuccessful ??
                              'Login successful!')),
                );
              } else if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(widget.authService.error ??
                        (AppLocalizations.of(context)?.loginError ??
                            'Login error')),
                  ),
                );
              }
            },
            child: Text(AppLocalizations.of(context)?.login ?? 'Login'),
          ),
        ],
      ),
    );
  }

  void _showRegisterDialog(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final firstNameController = TextEditingController();
    final lastNameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title:
            Text(AppLocalizations.of(context)?.registration ?? 'Registration'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: firstNameController,
                decoration: InputDecoration(
                  labelText:
                      AppLocalizations.of(context)?.firstName ?? 'First Name',
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: lastNameController,
                decoration: InputDecoration(
                  labelText:
                      AppLocalizations.of(context)?.lastName ?? 'Last Name',
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText:
                      AppLocalizations.of(context)?.password ?? 'Password',
                  border: const OutlineInputBorder(),
                ),
                obscureText: true,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () async {
              final success = await widget.authService.register(
                email: emailController.text,
                password: passwordController.text,
                firstName: firstNameController.text,
                lastName: lastNameController.text,
              );
              if (success && context.mounted) {
                Navigator.pop(context);
                setState(() {});
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text(AppLocalizations.of(context)
                              ?.registrationSuccessful ??
                          'Registration successful!')),
                );
              } else if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(widget.authService.error ??
                        (AppLocalizations.of(context)?.registrationError ??
                            'Registration error')),
                  ),
                );
              }
            },
            child: Text(
                AppLocalizations.of(context)?.registerAccount ?? 'Register'),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)?.logoutConfirmation ??
            'Logout Confirmation'),
        content: Text(AppLocalizations.of(context)?.logoutConfirmationMessage ??
            'Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () async {
              await widget.authService.logout();
              if (context.mounted) {
                Navigator.pop(context);
                setState(() {});
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Вы вышли из аккаунта')),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Выйти'),
          ),
        ],
      ),
    );
  }

  void _showEditProfileDialog(BuildContext context) {
    final user = widget.authService.currentUser;
    if (user == null) return;

    final firstNameController = TextEditingController(text: user.firstName);
    final lastNameController = TextEditingController(text: user.lastName);
    final phoneController = TextEditingController(text: user.phone ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Редактировать профиль'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: firstNameController,
              decoration: const InputDecoration(
                labelText: 'Имя',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: lastNameController,
              decoration: const InputDecoration(
                labelText: 'Фамилия',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(
                labelText: 'Телефон',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () async {
              final success = await widget.authService.updateProfile(
                firstName: firstNameController.text,
                lastName: lastNameController.text,
                phone: phoneController.text.isNotEmpty
                    ? phoneController.text
                    : null,
              );
              if (success && context.mounted) {
                Navigator.pop(context);
                setState(() {});
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Профиль обновлен!')),
                );
              } else if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content:
                        Text(widget.authService.error ?? 'Ошибка обновления'),
                  ),
                );
              }
            },
            child: const Text('Сохранить'),
          ),
        ],
      ),
    );
  }

  void _showAddFundsDialog(BuildContext context) {
    final amountController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Пополнить баланс'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: amountController,
              decoration: const InputDecoration(
                labelText: 'Сумма',
                prefixText: '\$',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Функция в разработке')),
              );
            },
            child: const Text('Пополнить'),
          ),
        ],
      ),
    );
  }

  // Заглушки для остальных функций
  void _showSettings(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Настройки в разработке')),
    );
  }

  void _showYukuMarketplace(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => YukuMarketplaceScreen(
          nftClient: widget.nftClient,
        ),
      ),
    );
  }

  void _showYukuDemo(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => YukuIntegrationDemoScreen(
          nftClient: widget.nftClient,
        ),
      ),
    );
  }

  void _showTransactionHistory(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('История транзакций в разработке')),
    );
  }

  void _showFavorites(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Избранные закладные в разработке')),
    );
  }

  void _showNotificationsSettings(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Настройки уведомлений в разработке')),
    );
  }

  void _showHelp(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Помощь в разработке')),
    );
  }

  void _showLanguageSettings(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Настройки языка в разработке')),
    );
  }

  void _showSecuritySettings(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Настройки безопасности в разработке')),
    );
  }

  void _showPrivacySettings(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Настройки приватности в разработке')),
    );
  }

  void _showLicense(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Лицензия в разработке')),
    );
  }

  void _showTermsOfService(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Условия использования в разработке')),
    );
  }

  void _showPrivacyPolicy(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Политика конфиденциальности в разработке')),
    );
  }

  void _showWalletSettings(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => WalletSettingsScreen(
          nftClient: widget.nftClient,
        ),
      ),
    );
  }

  void _showPlugWallet(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PlugWalletScreen(
          nftClient: widget.nftClient,
        ),
      ),
    );
  }
}
