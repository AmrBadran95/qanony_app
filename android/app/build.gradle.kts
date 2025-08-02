    plugins {
        id("com.android.application")
        // START: FlutterFire Configuration
        id("com.google.gms.google-services")
        // END: FlutterFire Configuration
        id("kotlin-android")
        id("dev.flutter.flutter-gradle-plugin")
    }

    android {
        namespace = "com.example.qanony"

        compileSdk = flutter.compileSdkVersion
        ndkVersion = "29.0.13113456"

        compileOptions {
            sourceCompatibility = JavaVersion.VERSION_11
            targetCompatibility = JavaVersion.VERSION_11
            isCoreLibraryDesugaringEnabled = true
        }

        kotlinOptions {
            jvmTarget = JavaVersion.VERSION_11.toString()
        }

        defaultConfig {
            applicationId = "com.example.qanony"
            minSdk = 23
            targetSdk = flutter.targetSdkVersion
            versionCode = flutter.versionCode
            versionName = flutter.versionName
            multiDexEnabled = true
        }

        buildTypes {
            release {
                signingConfig = signingConfigs.getByName("debug")

                minifyEnabled true
                shrinkResources true

                proguardFiles(
                    getDefaultProguardFile("proguard-android-optimize.txt"),
                    "proguard-rules.pro"
                )
            }
        }
    }

    flutter {
        source = "../.."
    }

    dependencies {
        implementation(platform("com.google.firebase:firebase-bom:33.16.0"))
        implementation("com.google.firebase:firebase-analytics")
        implementation("com.google.firebase:firebase-auth")
        implementation("com.google.firebase:firebase-firestore")
        coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
    }
