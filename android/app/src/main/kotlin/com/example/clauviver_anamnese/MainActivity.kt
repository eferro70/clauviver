// android/app/src/main/kotlin/br/com/clauviver/anamnese/MainActivity.kt
package br.com.clauviver.anamnese

import android.os.Bundle // Importe o Bundle
import androidx.core.splashscreen.SplashScreen.Companion.installSplashScreen // <-- 1. IMPORTE A BIBLIOTECA
import io.flutter.embedding.android.FlutterActivity

class MainActivity: FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        // Handle the splash screen transition.
        installSplashScreen() 

        super.onCreate(savedInstanceState)
    }
}
