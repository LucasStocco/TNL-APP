import 'package:crud_flutter/background/workers/notification_worker.dart';
import 'package:crud_flutter/core/utils/notification/messages/notification_frequency.dart';
import 'package:crud_flutter/view/settings/widgets/privacy_policy_bottom_sheet.dart';
import 'package:crud_flutter/view/settings/widgets/settings_card.dart';
import 'package:crud_flutter/view/settings/widgets/settings_section_title.dart';
import 'package:crud_flutter/view/settings/widgets/settings_switch_tile.dart';
import 'package:crud_flutter/view/settings/widgets/settings_tile.dart';
import 'package:crud_flutter/view_model/settings/settings_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:app_settings/app_settings.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late final ControladorConfigNotificacoes viewModel;

  bool _hasChanges = false;
  bool _frequencyExpanded = false;

  void _markAsChanged() => _hasChanges = true;

  @override
  void initState() {
    super.initState();

    viewModel = ControladorConfigNotificacoes();

    viewModel.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: viewModel.horarioPreferido,
    );

    if (picked != null) {
      _markAsChanged();
      await viewModel.setPreferredTime(picked);
    }
  }

  Widget _frequencyOption(String title, String value) {
    final isSelected = viewModel.frequenciaNotificacao == value;

    return InkWell(
      onTap: () async {
        _markAsChanged();
        await viewModel.setNotificationFrequency(FrequenciaNotificacao.normal);

        setState(() {
          _frequencyExpanded = false;
        });
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        color: isSelected ? Colors.black.withOpacity(0.05) : Colors.transparent,
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              size: 20,
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final notificationsEnabled = viewModel.notificacoesAtivadas;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
        title: const Text(
          'Configurações',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context, _hasChanges),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SettingsSectionTitle(title: 'Configurações Gerais'),
            const SizedBox(height: 12),

            SettingsCard(
              children: [
                SettingsTile(
                  icon: Icons.palette_outlined,
                  title: 'Aparência',
                  subtitle: 'Deixe o app a sua cara!',
                  onTap: () {},
                ),
              ],
            ),

            const SizedBox(height: 32),

            const SettingsSectionTitle(title: 'Notificações'),
            const SizedBox(height: 12),

            SettingsCard(
              children: [
                SettingsSwitchTile(
                  icon: Icons.notifications_active_outlined,
                  title: 'Ativar notificações',
                  subtitle: 'Permite receber qualquer notificação.',
                  value: notificationsEnabled,
                  onChanged: (value) {
                    _markAsChanged();
                    viewModel.toggleNotifications(value);
                  },
                ),
                const Divider(height: 1),
                SettingsSwitchTile(
                  icon: Icons.alarm_outlined,
                  title: 'Lembretes',
                  subtitle: 'Não esqueça tarefas importantes.',
                  value: viewModel.lembretesAtivados,
                  onChanged: (value) {
                    _markAsChanged();
                    viewModel.toggleReminders(value);
                  },
                ),
                const Divider(height: 1),
                SettingsSwitchTile(
                  icon: Icons.chat_bubble_outline,
                  title: 'Contexto',
                  subtitle: 'Baseado no seu uso.',
                  value: viewModel.contextoAtivado,
                  onChanged: (value) {
                    _markAsChanged();
                    viewModel.toggleContext(value);
                  },
                ),
              ],
            ),

            const SizedBox(height: 32),

            const SettingsSectionTitle(title: 'Personalização'),
            const SizedBox(height: 12),

            SettingsCard(
              children: [
                SettingsSwitchTile(
                  icon: Icons.local_fire_department_outlined,
                  title: 'Incentivos',
                  subtitle: 'Te motiva a voltar.',
                  value: viewModel.incentivosAtivados,
                  onChanged: (value) {
                    _markAsChanged();
                    viewModel.toggleIncentives(value);
                  },
                ),
                const Divider(height: 1),

                SettingsSwitchTile(
                  icon: Icons.schedule,
                  title: 'Horário preferido',
                  subtitle: viewModel.horarioPreferidoAtivado
                      ? 'Notificações às ${viewModel.horarioPreferido.format(context)}'
                      : 'Desativado',
                  value: viewModel.horarioPreferidoAtivado,
                  onTap: viewModel.horarioPreferidoAtivado ? _pickTime : null,
                  onChanged: (value) async {
                    _markAsChanged();
                    await viewModel.togglePreferredTime(value);
                  },
                ),

                const Divider(height: 1),

                // =========================
                // FREQUÊNCIA (ISOLADA CORRETAMENTE)
                // =========================
                SettingsTile(
                  icon: Icons.schedule_send_outlined,
                  title:
                      'Frequência (${viewModel.descricaoFrequenciaNotificacao.split(' ').first})',
                  subtitle: 'Escolha a frequência das notificações.',
                  onTap: () {
                    setState(() {
                      _frequencyExpanded = !_frequencyExpanded;
                    });
                  },
                  trailing: Icon(
                    _frequencyExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                  ),
                ),

                AnimatedCrossFade(
                  duration: const Duration(milliseconds: 250),
                  crossFadeState: _frequencyExpanded
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                  firstChild: const SizedBox.shrink(),
                  secondChild: Column(
                    children: [
                      const Divider(height: 1),
                      _frequencyOption('Baixa (1x ao dia)', 'low'),
                      _frequencyOption('Média (3x ao dia)', 'medium'),
                      _frequencyOption('Alta (frequente)', 'high'),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // =========================
            // APLICATIVO (SEPARADO)
            // =========================
            const SettingsSectionTitle(title: 'Aplicativo'),
            const SizedBox(height: 12),

            ElevatedButton(
              onPressed: () async {
                await NotificationWorker.execute(
                  NotificationWorker.taskName,
                  {},
                );
              },
              child: const Text('Testar Notificação'),
            ),

            const SizedBox(height: 16),

            SettingsCard(
              children: [
                SettingsTile(
                  icon: Icons.shield_outlined,
                  title: 'Privacidade',
                  subtitle: 'Como seus dados são usados.',
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (_) => const PrivacyPolicyBottomSheet(),
                    );
                  },
                ),
                const Divider(height: 1),
                SettingsTile(
                  icon: Icons.star_outline_rounded,
                  title: 'Avaliar App',
                  subtitle: 'Ajude a melhorar.',
                  onTap: () {},
                ),
                const Divider(height: 1),
                SettingsTile(
                  icon: Icons.settings_outlined,
                  title: 'Permissões',
                  subtitle: 'Configurações do sistema',
                  onTap: () {
                    AppSettings.openAppSettings(
                      type: AppSettingsType.notification,
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
