import 'package:crud_flutter/service/notifications/notification_service.dart';
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
  /// ViewModel responsável por:
  /// - controlar estado das notificações
  /// - salvar preferências localmente
  late final SettingsViewModel viewModel;

  @override
  void initState() {
    super.initState();

    /// Inicializa o ViewModel
    viewModel = SettingsViewModel();

    /// Escuta mudanças do ViewModel
    /// e atualiza a interface automaticamente
    viewModel.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    /// Estrutura base da tela
    return Scaffold(
      /// Cor de fundo da página
      backgroundColor: const Color(0xFFF5F5F5),

      /// Barra superior da tela
      appBar: AppBar(
        /// Remove cor padrão do AppBar
        backgroundColor: Colors.transparent,

        /// Remove sombra
        elevation: 0,

        /// Remove sombra ao scrollar
        scrolledUnderElevation: 0,

        /// Cor padrão dos ícones/textos
        foregroundColor: Colors.black,

        /// Título da página
        title: const Text(
          'Configurações',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),

      /// Permite scroll caso conteúdo cresça
      body: SingleChildScrollView(
        /// Espaçamento geral da tela
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// =========================
            /// CONFIGURAÇÕES GERAIS
            /// =========================

            const SettingsSectionTitle(
              title: 'Configurações Gerais',
            ),

            const SizedBox(height: 12),

            /// Card agrupando configurações gerais
            SettingsCard(
              children: [
                /// Tile de aparência
                SettingsTile(
                  icon: Icons.palette_outlined,
                  title: 'Aparência',

                  /// Futuramente:
                  /// abrir seleção de tema
                  onTap: () {},
                ),

                const Divider(height: 1),

                /// Switch de notificações
                SettingsSwitchTile(
                  /// Ícone lateral
                  icon: Icons.notifications_none_rounded,

                  /// Texto da opção
                  title: 'Notificações',

                  /// Valor atual vindo do ViewModel
                  value: viewModel.notificationsEnabled,

                  /// Quando usuário altera switch:
                  /// - salva no SharedPreferences
                  /// - atualiza estado da UI
                  onChanged: (value) async {
                    await viewModel.toggleNotifications(value);
                  },
                ),
              ],
            ),

            const SizedBox(height: 32),

            /// =========================
            /// APLICATIVO
            /// =========================

            const SettingsSectionTitle(
              title: 'Aplicativo',
            ),

            const SizedBox(height: 12),

            /// Botão temporário para testar notificação
            ElevatedButton(
              onPressed: () async {
                await NotificationService.showTestNotification();
              },
              child: const Text('Testar Notificação'),
            ),

            const SizedBox(height: 16),

            /// Card com opções institucionais
            SettingsCard(
              children: [
                /// Política de dados
                SettingsTile(
                  icon: Icons.shield_outlined,
                  title: 'Política de Proteção de Dados',
                  onTap: () {
                    /// Abre modal inferior
                    showModalBottomSheet(
                      /// Contexto da tela atual
                      context: context,

                      /// Permite modal crescer mais
                      isScrollControlled: true,

                      /// Remove fundo branco padrão
                      backgroundColor: Colors.transparent,

                      /// Widget do modal
                      builder: (_) {
                        return const PrivacyPolicyBottomSheet();
                      },
                    );
                  },
                ),

                const Divider(height: 1),

                /// Avaliação do aplicativo
                SettingsTile(
                  icon: Icons.star_outline_rounded,
                  title: 'Avaliar Aplicativo',

                  /// Futuramente:
                  /// abrir página da Play Store
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
