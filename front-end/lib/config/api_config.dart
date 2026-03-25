class ApiConfig {
  static const String baseUrl = 'http://localhost:8088';
}


//http://seu ip/listas

// concete o celular via USB no modo dev
// adb reverse tcp:8088 tcp:8088 no terminal 
// flutter clean
// flutter run

/*
🎯 Como funciona

Celular → localhost:8088
ADB redireciona → PC:8088
Spring responde

Sem IP.
Sem dor de cabeça.
Sem mudar quando troca Wi-Fi.

🧠 Só lembre de uma coisa

Se você:

Reiniciar o celular

Desconectar o cabo

Reiniciar o PC

Vai precisar rodar novamente:

adb reverse tcp:8088 tcp:8088


🚑 ERRO: Connection refused (111)
1️⃣ Backend está rodando?

Tem que aparecer:

Tomcat started on port 8088

Se não:

mvn spring-boot:run
2️⃣ Celular conectado?
adb devices

Tem que aparecer:

device

Se unauthorized → autorize no celular.

3️⃣ Refazer ADB Reverse

Sempre que reiniciar algo:

adb reverse --remove-all
adb reverse tcp:8088 tcp:8088
adb reverse --list

Tem que aparecer:

tcp:8088 tcp:8088

Se vier vazio → não está ativo.

4️⃣ Se Flutter travar
flutter clean
flutter pub get
flutter run
5️⃣ Se ADB travar
adb kill-server
adb start-server
adb devices

Depois refaz o reverse.

6️⃣ Alternativa mais estável (sem USB)
ipconfig

Trocar no ApiConfig:

static const String baseUrl = 'http://192.168.X.X:8088';
 */