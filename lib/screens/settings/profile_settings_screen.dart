// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import '../../services/auth_service.dart';

class ProfileSettingsScreen extends StatefulWidget {
  const ProfileSettingsScreen({super.key});

  @override
  State<ProfileSettingsScreen> createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends State<ProfileSettingsScreen> {
  final firstCtrl = TextEditingController();
  final lastCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final mobileCtrl = TextEditingController();

  String language = "English";
  bool loading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  /* ================= LOAD PROFILE ================= */

  Future<void> _load() async {
    final profile = await AuthService.getProfile();

    if (profile == null) {
      setState(() {
        loading = false;
        error = "Failed to load profile. Please login again.";
      });
      return;
    }

    firstCtrl.text = profile["first_name"] ?? "";
    lastCtrl.text = profile["last_name"] ?? "";
    emailCtrl.text = profile["email"] ?? "";
    mobileCtrl.text = profile["mobile"] ?? "";

    setState(() => loading = false);
  }

  /* ================= SAVE PROFILE ================= */

  Future<void> _save() async {
    final ok = await AuthService.updateProfile(
      firstName: firstCtrl.text.trim(),
      lastName: lastCtrl.text.trim(),
      email: emailCtrl.text.trim(),
      mobile: mobileCtrl.text.trim(),
    );

    if (!mounted) return;

    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile updated")),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Failed to update profile"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  /* ================= UI ================= */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile Settings"),
        foregroundColor: Colors.white,
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF0F4C5C),
                Color(0xFF0AA6B7),
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : error != null
              ? Center(
                  child: Text(
                    error!,
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _field("First Name", firstCtrl),
                      _field("Last Name", lastCtrl),
                      _field("Email", emailCtrl),
                      _field("Mobile", mobileCtrl),
                      const SizedBox(height: 12),
                      DropdownButtonFormField(
                        value: language,
                        items: const [
                          DropdownMenuItem(
                              value: "English", child: Text("English")),
                          DropdownMenuItem(
                              value: "Hindi", child: Text("Hindi")),
                          DropdownMenuItem(
                              value: "Telugu", child: Text("Telugu")),
                        ],
                        onChanged: (v) =>
                            setState(() => language = v.toString()),
                        decoration: const InputDecoration(
                          labelText: "Language",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _save,
                          child: const Text("Save Changes"),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }

  Widget _field(String label, TextEditingController c) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: TextField(
          controller: c,
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
          ),
        ),
      );
}
