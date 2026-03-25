# crud_flutter

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

======== LÓGICA DAS CAMADAS ========
model = representação de dados no app 
view = responsável pela interface do usuário.
view_model = estado/controle da tela 
service = comunicação com AP

======== FLUXO DE DADOS ========
Service → chama API
Model → faz fromJson/toJson
ViewModel → controla estado
View → renderiza