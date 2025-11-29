#/bin/bash 

# 1. Limpeza padrão do Flutter
flutter clean

# 2. Entre no diretório do Android
cd android

# 3. (Apenas para macOS/Linux) Torne o gradlew executável
chmod +x ./gradlew

# 4. Execute a limpeza do Gradle. Isso remove todos os caches do Gradle.
./gradlew clean

# 5. Volte para a raiz do projeto
cd ..

# 6. Busque os pacotes do Flutter novamente
flutter pub get