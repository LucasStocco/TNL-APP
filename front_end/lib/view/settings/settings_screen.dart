import 'package:crud_flutter/background/workers/notification_worker.dart';
import 'package:crud_flutter/view/settings/widgets/privacy_policy_bottom_sheet.dart';
import 'package:crud_flutter/view/settings/widgets/settings_card.dart';
import 'package:crud_flutter/view/settings/widgets/settings_section_title.dart';
import 'package:crud_flutter/view/settings/widgets/settings_switch_tile.dart';
import 'package:crud_flutter/view/settings/widgets/settings_tile.dart';
import 'package:crud_flutter/view_model/settings/settings_viewmodel.dart';
import 'package:flutter/material.dart';

/// Tela principal de configurações do aplicativo
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late final SettingsViewModel viewModel;

  @override
  void initState() {
    super.initState();

    viewModel = SettingsViewModel();

    viewModel.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        foregroundColor: Colors.black,
        title: const Text(
          'Configurações',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SettingsSectionTitle(
              title: 'Configurações Gerais',
            ),

            const SizedBox(height: 12),

            SettingsCard(
              children: [
                SettingsTile(
                  icon: Icons.palette_outlined,
                  title: 'Aparência',
                  onTap: () {},
                ),
                const Divider(height: 1),
                SettingsSwitchTile(
                  icon: Icons.notifications_none_rounded,
                  title: 'Notificações',
                  value: viewModel.notificationsEnabled,
                  onChanged: (value) async {
                    await viewModel.toggleNotifications(value);
                  },
                ),
              ],
            ),

            const SizedBox(height: 32),

            const SettingsSectionTitle(
              title: 'Aplicativo',
            ),

            const SizedBox(height: 12),

            /// 🧪 TESTE REAL DO WORKER
            ElevatedButton(
              onPressed: () async {
                await NotificationWorker.execute(
                  NotificationWorker.taskName,
                  {},
                );
              },
              child: const Text('Testar Notificação (Worker)'),
            ),

            const SizedBox(height: 16),

            SettingsCard(
              children: [
                SettingsTile(
                  icon: Icons.shield_outlined,
                  title: 'Política de Proteção de Dados',
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (_) {
                        return const PrivacyPolicyBottomSheet();
                      },
                    );
                  },
                ),
                const Divider(height: 1),
                SettingsTile(
                  icon: Icons.star_outline_rounded,
                  title: 'Avaliar Aplicativo',
                  onTap: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
