import 'package:crud_flutter/core/api/api_response.dart';

class ServiceUtils {
  // =========================
  // EXTRAI OBJETO
  // =========================
  static T extract<T>(ApiResponse<T> res) {
    if (res.data == null) {
      throw Exception(res.message);
    }
    return res.data as T;
  }

  // =========================
  // EXTRAI LISTA
  // =========================
  static List<T> extractList<T>(ApiResponse<List<T>> res) {
    return res.data ?? [];
  }

  // =========================
  // VALIDA APENAS STATUS
  // =========================
  static void validate(ApiResponse res) {
    if (!res.success) {
      throw Exception(res.message);
    }
  }
}

/*# 🧱 ServiceUtils (Helper de Padronização de API)

## 📌 O que é?

O `ServiceUtils` é um **helper centralizado** responsável por padronizar o tratamento das respostas da API dentro dos services do Flutter.

Ele evita repetição de código e garante que todas as respostas do backend sejam tratadas de forma consistente em todo o sistema.

---

## 🎯 Por que ele existe?

Antes do helper, cada service fazia validações manualmente, como:

- verificar se `res.data` é null
- lançar exceções com `res.message`
- tratar listas com `map`
- validar `success` em cada request

Isso gerava:
- código repetido
- inconsistência entre services
- maior chance de bugs
- dificuldade de manutenção

---

## ⚙️ Como funciona?

O `ServiceUtils` centraliza três operações principais:

### 1. 🔹 extract<T>
Usado para respostas que retornam **um único objeto**

```dart
ServiceUtils.extract<Produto>(res); */
