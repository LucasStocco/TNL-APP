import 'package:crud_flutter/core/utils/notification/messages/notification_frequency.dart';
import 'package:crud_flutter/model/sistema_notifica%C3%A7%C3%B5es/notification_state.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:crud_flutter/service/notifications/notification_preferences_service.dart';

class ControladorConfigNotificacoes extends ChangeNotifier {
  bool permissaoSistemaConcedida = true;
  bool get permissaoSistema => permissaoSistemaConcedida;

  bool get notificacoesAtivadas => _state.notificacoesAtivadas;

  bool get lembretesAtivados => _state.lembretesAtivados;

  bool get contextoAtivado => _state.contextoAtivado;

  bool get incentivosAtivados => _state.incentivosAtivados;

  bool get horarioPreferidoAtivado => _state.horarioPreferidoAtivado;

  EstadoNotificacao _state = const EstadoNotificacao(
    notificacoesAtivadas: true,
    lembretesAtivados: true,
    contextoAtivado: true,
    incentivosAtivados: true,
    horarioPreferidoAtivado: true,
    frequencia: FrequenciaNotificacao.normal,
    horarioPreferido: TimeOfDay(hour: 19, minute: 0),
  );

  EstadoNotificacao get state => _state;

  // =========================
  // CONVENIENCE GETTERS
  // =========================

  TimeOfDay get horarioPreferido => _state.horarioPreferido;
  FrequenciaNotificacao get frequenciaNotificacao => _state.frequencia;

  String get descricaoFrequenciaNotificacao {
    switch (_state.frequencia) {
      case FrequenciaNotificacao.low:
        return 'Baixa (1x/dia)';
      case FrequenciaNotificacao.high:
        return 'Alta (frequente)';
      case FrequenciaNotificacao.normal:
      default:
        return 'Média (3x/dia)';
    }
  }

  // =========================
  // INIT
  // =========================

  ControladorConfigNotificacoes() {
    _loadPreferences();
  }

  // =========================
  // LOAD STATE
  // =========================

  Future<void> _loadPreferences() async {
    _state = EstadoNotificacao(
      notificacoesAtivadas:
          await NotificationPreferencesService.isNotificationsEnabled(),
      lembretesAtivados:
          await NotificationPreferencesService.isRemindersEnabled(),
      contextoAtivado: await NotificationPreferencesService.isContextEnabled(),
      incentivosAtivados:
          await NotificationPreferencesService.isIncentivesEnabled(),
      horarioPreferidoAtivado:
          await NotificationPreferencesService.isPreferredTimeEnabled(),
      frequencia: await NotificationPreferencesService.getFrequency(),
      horarioPreferido: await NotificationPreferencesService.getPreferredTime(),
    );

    permissaoSistemaConcedida = await _checkSystemPermission();

    notifyListeners();
  }

  // =========================
  // SYSTEM PERMISSION
  // =========================

  Future<bool> _checkSystemPermission() async {
    final status = await Permission.notification.status;
    return status.isGranted;
  }

  Future<void> refreshSystemPermission() async {
    permissaoSistemaConcedida = await _checkSystemPermission();

    if (!permissaoSistemaConcedida) {
      _state = _state.copyWith(
        notificacoesAtivadas: false,
        lembretesAtivados: false,
        contextoAtivado: false,
        incentivosAtivados: false,
      );
    }

    notifyListeners();
  }

  // =========================
  // TIME
  // =========================

  Future<void> setPreferredTime(TimeOfDay time) async {
    _state = _state.copyWith(horarioPreferido: time);

    await NotificationPreferencesService.setPreferredTime(time);

    notifyListeners();
  }

  Future<void> togglePreferredTime(bool value) async {
    _state = _state.copyWith(horarioPreferidoAtivado: value);

    await NotificationPreferencesService.setPreferredTimeEnabled(value);

    notifyListeners();
  }

  // =========================
  // GLOBAL TOGGLE
  // =========================

  Future<void> toggleNotifications(bool value) async {
    if (!value) {
      _state = _state.copyWith(
        notificacoesAtivadas: false,
        lembretesAtivados: false,
        contextoAtivado: false,
        incentivosAtivados: false,
      );
    } else {
      _state = _state.copyWith(
        notificacoesAtivadas: true,
      );
    }

    await NotificationPreferencesService.setNotificationsEnabled(value);

    notifyListeners();
  }

  // =========================
  // CATEGORY TOGGLES
  // =========================

  Future<void> toggleReminders(bool value) async {
    _state = _state.copyWith(lembretesAtivados: value);

    await NotificationPreferencesService.setRemindersEnabled(value);

    notifyListeners();
  }

  Future<void> toggleContext(bool value) async {
    _state = _state.copyWith(contextoAtivado: value);

    await NotificationPreferencesService.setContextEnabled(value);

    notifyListeners();
  }

  Future<void> toggleIncentives(bool value) async {
    _state = _state.copyWith(incentivosAtivados: value);

    await NotificationPreferencesService.setIncentivesEnabled(value);

    notifyListeners();
  }

  // =========================
  // FREQUENCY
  // =========================

  Future<void> setNotificationFrequency(FrequenciaNotificacao value) async {
    _state = _state.copyWith(frequencia: value);

    await NotificationPreferencesService.setFrequency(value);
    notifyListeners();
  }
}
