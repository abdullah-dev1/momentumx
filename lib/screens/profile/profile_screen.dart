import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme.dart';
import '../../providers/user_provider.dart';
import '../../providers/theme_provider.dart';
import '../../services/api_service.dart';
import '../auth/login_screen.dart';
import 'edit_profile_screen.dart';
import 'help_support_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _showThemeDialog(BuildContext context) {
    final themeProvider = context.read<ThemeProvider>();
    showModalBottomSheet(
      context: context,
      backgroundColor:
          Theme.of(context).brightness == Brightness.dark
              ? AppTheme.surface
              : Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius:
              BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Choose Theme',
                style: TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _ThemeOption(
              icon: Icons.dark_mode,
              label: 'Dark',
              selected:
                  themeProvider.themeMode == ThemeMode.dark,
              onTap: () {
                themeProvider.setTheme(ThemeMode.dark);
                Navigator.pop(context);
              },
            ),
            _ThemeOption(
              icon: Icons.light_mode,
              label: 'Light',
              selected:
                  themeProvider.themeMode == ThemeMode.light,
              onTap: () {
                themeProvider.setTheme(ThemeMode.light);
                Navigator.pop(context);
              },
            ),
            _ThemeOption(
              icon: Icons.phone_android,
              label: 'Follow System',
              selected:
                  themeProvider.themeMode == ThemeMode.system,
              onTap: () {
                themeProvider.setTheme(ThemeMode.system);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showNotificationsDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor:
          Theme.of(context).brightness == Brightness.dark
              ? AppTheme.surface
              : Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius:
              BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => _NotificationsSheet(),
    );
  }

  void _showPrivacyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor:
            Theme.of(context).brightness == Brightness.dark
                ? AppTheme.surface
                : Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16)),
        title: const Text('Privacy & Security',
            style: TextStyle(fontWeight: FontWeight.bold)),
        content: const SingleChildScrollView(
          child: Text(
            'MomentumX takes your privacy seriously.\n\n'
            '• Your data is encrypted in transit using HTTPS.\n'
            '• Passwords are hashed with bcrypt and never stored in plain text.\n'
            '• We do not sell or share your personal data with third parties.\n'
            '• You can delete your account and all data at any time.\n'
            '• JWT tokens expire after 7 days for security.\n\n'
            'For any privacy concerns, contact:\nsupport@momentumx.app',
            style: TextStyle(fontSize: 13, height: 1.6),
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primary,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Got it',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor:
            Theme.of(context).brightness == Brightness.dark
                ? AppTheme.surface
                : Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16)),
        title: const Text('Log Out',
            style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text(
            'Are you sure you want to log out?',
            style: TextStyle(color: AppTheme.textSecondary)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel',
                style:
                    TextStyle(color: AppTheme.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () async {
              await ApiService.clearToken();
              await context.read<UserProvider>().clearUser();
              if (!context.mounted) return;
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (_) => const LoginScreen()),
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Log Out',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>();
    final themeProvider = context.watch<ThemeProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? AppTheme.card : Colors.white;

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Avatar + name
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 44,
                    backgroundColor: AppTheme.primary,
                    child: Text(user.initials,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold)),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) =>
                              const EditProfileScreen()),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: AppTheme.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.edit,
                          color: Colors.white, size: 14),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(user.name,
                  style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(user.email,
                  style: const TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 13)),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.primary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text('Goal: ${user.goal}',
                    style: const TextStyle(
                        color: AppTheme.primary,
                        fontSize: 12,
                        fontWeight: FontWeight.w500)),
              ),

              const SizedBox(height: 24),

              // Stats row
              Row(
                children: [
                  _ProfileStat(
                      label: 'Workouts',
                      value: '24',
                      color: cardColor),
                  const SizedBox(width: 10),
                  _ProfileStat(
                      label: 'Streak',
                      value: '7 🔥',
                      color: cardColor),
                  const SizedBox(width: 10),
                  _ProfileStat(
                      label: 'Lost',
                      value: '4 kg',
                      color: cardColor),
                ],
              ),

              const SizedBox(height: 24),

              // Settings group
              _SectionLabel('Account'),
              _SettingsTile(
                  icon: Icons.person_outline,
                  label: 'Edit Profile',
                  cardColor: cardColor,
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) =>
                              const EditProfileScreen()))),
              _SettingsTile(
                  icon: Icons.notifications_outlined,
                  label: 'Notifications',
                  cardColor: cardColor,
                  onTap: () =>
                      _showNotificationsDialog(context)),

              const SizedBox(height: 16),
              _SectionLabel('Preferences'),
              _SettingsTile(
                  icon: Icons.palette_outlined,
                  label: 'Theme',
                  trailing: Text(themeProvider.currentLabel,
                      style: const TextStyle(
                          color: AppTheme.primary,
                          fontSize: 13)),
                  cardColor: cardColor,
                  onTap: () => _showThemeDialog(context)),

              const SizedBox(height: 16),
              _SectionLabel('Security & Support'),
              _SettingsTile(
                  icon: Icons.lock_outline,
                  label: 'Privacy & Security',
                  cardColor: cardColor,
                  onTap: () => _showPrivacyDialog(context)),
              _SettingsTile(
                  icon: Icons.help_outline,
                  label: 'Help & Support',
                  cardColor: cardColor,
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) =>
                              const HelpSupportScreen()))),

              const SizedBox(height: 16),
              _SettingsTile(
                  icon: Icons.logout,
                  label: 'Log Out',
                  isRed: true,
                  cardColor: cardColor,
                  onTap: () => _showLogoutDialog(context)),

              const SizedBox(height: 8),
              Text('MomentumX v1.0.0',
                  style: TextStyle(
                      color: isDark
                          ? AppTheme.textSecondary
                          : Colors.grey[400],
                      fontSize: 12)),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(text,
            style: const TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5)),
      );
}

class _ProfileStat extends StatelessWidget {
  final String label, value;
  final Color color;
  const _ProfileStat(
      {required this.label,
      required this.value,
      required this.color});

  @override
  Widget build(BuildContext context) => Expanded(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(12)),
          child: Column(
            children: [
              Text(value,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18)),
              Text(label,
                  style: const TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 12)),
            ],
          ),
        ),
      );
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isRed;
  final VoidCallback onTap;
  final Color cardColor;
  final Widget? trailing;

  const _SettingsTile({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.cardColor,
    this.isRed = false,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(12)),
        child: ListTile(
          leading: Icon(icon,
              color: isRed
                  ? Colors.redAccent
                  : AppTheme.textSecondary,
              size: 22),
          title: Text(label,
              style: TextStyle(
                  color: isRed ? Colors.redAccent : null,
                  fontSize: 14)),
          trailing: trailing ??
              (isRed
                  ? null
                  : const Icon(Icons.arrow_forward_ios,
                      color: AppTheme.textSecondary, size: 14)),
          onTap: onTap,
        ),
      );
}

class _ThemeOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _ThemeOption({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => ListTile(
        leading: Icon(icon,
            color: selected
                ? AppTheme.primary
                : AppTheme.textSecondary),
        title: Text(label,
            style: TextStyle(
                color: selected ? AppTheme.primary : null,
                fontWeight: selected
                    ? FontWeight.w600
                    : FontWeight.normal)),
        trailing: selected
            ? const Icon(Icons.check_circle,
                color: AppTheme.primary)
            : null,
        onTap: onTap,
      );
}

class _NotificationsSheet extends StatefulWidget {
  @override
  State<_NotificationsSheet> createState() =>
      _NotificationsSheetState();
}

class _NotificationsSheetState
    extends State<_NotificationsSheet> {
  bool _workout = true;
  bool _habits = true;
  bool _water = false;
  bool _progress = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Notifications',
              style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          _NotifToggle(
              label: 'Workout reminders',
              value: _workout,
              onChanged: (v) => setState(() => _workout = v)),
          _NotifToggle(
              label: 'Habit check-ins',
              value: _habits,
              onChanged: (v) => setState(() => _habits = v)),
          _NotifToggle(
              label: 'Water reminders',
              value: _water,
              onChanged: (v) => setState(() => _water = v)),
          _NotifToggle(
              label: 'Weekly progress report',
              value: _progress,
              onChanged: (v) => setState(() => _progress = v)),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _NotifToggle extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _NotifToggle(
      {required this.label,
      required this.value,
      required this.onChanged});

  @override
  Widget build(BuildContext context) => SwitchListTile(
        title: Text(label, style: const TextStyle(fontSize: 14)),
        value: value,
        onChanged: onChanged,
        activeColor: AppTheme.primary,
        contentPadding: EdgeInsets.zero,
      );
}