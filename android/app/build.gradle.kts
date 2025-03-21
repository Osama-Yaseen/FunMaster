plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.oyasin.fun_master"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.oyasin.fun_master"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = 23
        targetSdk = flutter.targetSdkVersion
        versionCode = 4
        versionName = "1.3.0"
    }
  buildTypes {
        release {
                isMinifyEnabled = true  // ✅ Enable minification (Required for shrinking)
    isShrinkResources = true  // ✅ Remove unused resources
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )

            // ✅ Correct signing configuration
            signingConfig = signingConfigs.create("release") {
                storeFile = file(rootProject.file("fun_master_key.jks"))
                storePassword = "As1d2f3@"
                keyAlias = "funmaster"
                keyPassword = "As1d2f3@"
            }
        }
    }
}

flutter {
    source = "../.."
}
