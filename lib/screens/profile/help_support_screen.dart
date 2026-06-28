import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  void _copyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('$text copied!'),
      backgroundColor: AppTheme.success,
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 2),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10)),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? AppTheme.card : Colors.white;

    return Scaffold(
      appBar: AppBar(title: const Text('Help & Support')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Developer card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppTheme.primary, AppTheme.primaryDark],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 36,
                      backgroundColor: Colors.white24,
                      child: Text('MA',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(height: 12),
                    const Text('Muhammad Abdullah',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    const Text(
                        'Developer & Creator of MomentumX',
                        style: TextStyle(
                            color: Colors.white70, fontSize: 13)),
                    const SizedBox(height: 4),
                    const Text(
                        'CS Student @ FAST-NUCES Faisalabad',
                        style: TextStyle(
                            color: Colors.white60, fontSize: 12)),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              const Text('Contact Developer',
                  style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600)),
              const SizedBox(height: 12),

              // Contact tiles
              _ContactTile(
                icon: Icons.email_outlined,
                label: 'Email',
                value: 'devinsightfulabdullah.email@gmail.com', 
                cardColor: cardColor,
                onTap: () => _copyToClipboard(
                    context, 'your.email@gmail.com'),
              ),
              _ContactTile(
                icon: Icons.phone_outlined,
                label: 'Phone / WhatsApp',
                value: '+92 312 7509739', 
                cardColor: cardColor,
                onTap: () =>
                    _copyToClipboard(context, '+92 300 0000000'),
              ),
              _ContactTile(
                icon: Icons.link,
                label: 'LinkedIn',
                value: 'linkedin.com/in/abdullah-dev01',
                cardColor: cardColor,
                onTap: () => _copyToClipboard(
                    context, 'https://linkedin.com/in/abdullah-dev01'),
              ),
              _ContactTile(
                icon: Icons.code,
                label: 'GitHub',
                value: 'github.com/abdullah-dev1',
                cardColor: cardColor,
                onTap: () => _copyToClipboard(context,
                    'https://github.com/abdullah-dev1'),
              ),

              const SizedBox(height: 24),
              const Text('FAQ',
                  style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600)),
              const SizedBox(height: 12),

              _FAQTile(
                question: 'How do I reset my password?',
                answer:
                    'On the login screen, tap "Forgot Password" and enter your email. You\'ll receive a reset link.',
                cardColor: cardColor,
              ),
              _FAQTile(
                question: 'Is my data backed up?',
                answer:
                    'Yes. All your data is synced to our secure cloud server automatically when you\'re connected to the internet.',
                cardColor: cardColor,
              ),
             
              _FAQTile(
                question: 'Can I use MomentumX offline?',
                answer:
                    'Yes! MomentumX works offline. Your data will sync to the cloud automatically when you reconnect.',
                cardColor: cardColor,
              ),

              const SizedBox(height: 24),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    const Text('MomentumX',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15)),
                    const SizedBox(height: 4),
                    Text('Version 1.0.0',
                        style: TextStyle(
                            color: isDark
                                ? AppTheme.textSecondary
                                : Colors.grey[500],
                            fontSize: 12)),
                    const SizedBox(height: 4),
                    Text('Built with ❤️ in Faisalabad, Pakistan',
                        style: TextStyle(
                            color: isDark
                                ? AppTheme.textSecondary
                                : Colors.grey[500],
                            fontSize: 12)),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _ContactTile extends StatelessWidget {
  final IconData icon;
  final String label, value;
  final Color cardColor;
  final VoidCallback onTap;

  const _ContactTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.cardColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(
            horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.primary.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon,
                  color: AppTheme.primary, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: const TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 11)),
                  Text(value,
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500)),
                ],
              ),
            ),
            const Icon(Icons.copy,
                color: AppTheme.textSecondary, size: 16),
          ],
        ),
      ),
    );
  }
}

class _FAQTile extends StatefulWidget {
  final String question, answer;
  final Color cardColor;
  const _FAQTile(
      {required this.question,
      required this.answer,
      required this.cardColor});

  @override
  State<_FAQTile> createState() => _FAQTileState();
}

class _FAQTileState extends State<_FAQTile> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _expanded = !_expanded),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: widget.cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _expanded
                ? AppTheme.primary.withOpacity(0.4)
                : Colors.transparent,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(widget.question,
                      style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600)),
                ),
                Icon(
                  _expanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: AppTheme.textSecondary,
                  size: 20,
                ),
              ],
            ),
            if (_expanded) ...[
              const SizedBox(height: 10),
              Text(widget.answer,
                  style: const TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 13,
                      height: 1.5)),
            ],
          ],
        ),
      ),
    );
  }
}