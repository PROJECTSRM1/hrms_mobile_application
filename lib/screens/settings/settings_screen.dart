import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/theme_provider.dart';
import 'profile_settings_screen.dart';
import 'change_password_screen.dart';
import 'about_app_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      appBar: AppBar(
        title: const Text("Settings"),
        foregroundColor: Colors.white,
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF0F4C5C), Color(0xFF0AA6B7)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _section("GENERAL"),
          _card([
            _tile(
              icon: Icons.person,
              title: "Profile Settings",
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ProfileSettingsScreen(),
                ),
              ),
            ),
          ]),

          const SizedBox(height: 20),
          _section("APPEARANCE"),
          _card([
            _switchTile(
              icon: Icons.dark_mode,
              title: "Dark Mode",
              value: themeProvider.isDarkMode,
              onChanged: themeProvider.toggleTheme,
            ),
          ]),

          const SizedBox(height: 20),
          _section("SECURITY"),
          _card([
            _tile(
              icon: Icons.lock,
              title: "Change Password",
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ChangePasswordScreen()),
              ),
            ),
          ]),

          const SizedBox(height: 20),
          _section("ABOUT"),
          _card([
            _tile(
              icon: Icons.info,
              title: "About App",
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AboutAppScreen()),
              ),
            ),
          ]),
        ],
      ),
    );
  }

  /* ---------- UI HELPERS ---------- */

  Widget _section(String title) => Padding(
    padding: const EdgeInsets.only(left: 8, bottom: 8),
    child: Text(
      title,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: Colors.grey,
      ),
    ),
  );

  Widget _card(List<Widget> children) => Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
    ),
    child: Column(children: children),
  );

  Widget _tile({
    required IconData icon,
    required String title,
    VoidCallback? onTap,
  }) => ListTile(
    leading: Icon(icon, color: const Color(0xFF0AA6B7)),
    title: Text(title),
    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
    onTap: onTap,
  );

  Widget _switchTile({
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) => ListTile(
    leading: Icon(icon, color: const Color(0xFF0AA6B7)),
    title: Text(title),
    trailing: Switch(
      value: value,
      onChanged: onChanged,
      activeThumbColor: const Color(0xFF0AA6B7),
    ),
  );
}
