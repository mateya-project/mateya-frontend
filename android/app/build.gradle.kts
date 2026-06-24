import java.util.Properties

plugins {
    id("com.android.application")
    // START: FlutterFire Configuration
    id("com.google.gms.google-services")
    id("com.google.firebase.crashlytics")
    // END: FlutterFire Configuration
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

val requestedTasks = gradle.startParameter.taskNames
val requiresSignedReleaseArtifact = requestedTasks.any { taskName ->
    val normalizedTaskName = taskName.lowercase()
    normalizedTaskName.contains("bundlerelease") ||
        normalizedTaskName.contains("assemblerelease") ||
        normalizedTaskName.contains("packagerelease") ||
        normalizedTaskName.contains("signrelease")
}

val releaseSigningProperties = Properties()
val releaseSigningPropertiesFile = rootProject.file("key.properties")
if (releaseSigningPropertiesFile.exists()) {
    releaseSigningPropertiesFile.inputStream().use { input ->
        releaseSigningProperties.load(input)
    }
}

fun gradleOrEnv(name: String): String? {
    return releaseSigningProperties.getProperty(name)
        ?: providers.environmentVariable(name).orNull
}

val releaseStoreFilePath = gradleOrEnv("storeFile")
    ?: providers.environmentVariable("MATEYA_UPLOAD_STORE_FILE").orNull
val releaseStorePassword = gradleOrEnv("storePassword")
    ?: providers.environmentVariable("MATEYA_UPLOAD_STORE_PASSWORD").orNull
val releaseKeyAlias = gradleOrEnv("keyAlias")
    ?: providers.environmentVariable("MATEYA_UPLOAD_KEY_ALIAS").orNull
val releaseKeyPassword = gradleOrEnv("keyPassword")
    ?: providers.environmentVariable("MATEYA_UPLOAD_KEY_PASSWORD").orNull

val hasReleaseSigning =
    !releaseStoreFilePath.isNullOrBlank() &&
        !releaseStorePassword.isNullOrBlank() &&
        !releaseKeyAlias.isNullOrBlank() &&
        !releaseKeyPassword.isNullOrBlank()
val allowDebugSigningForRelease = providers.environmentVariable(
    "ALLOW_DEBUG_SIGNING_FOR_RELEASE",
).orNull.equals("true", ignoreCase = true)

if (requiresSignedReleaseArtifact && !hasReleaseSigning && !allowDebugSigningForRelease) {
    throw GradleException(
        "Release signing config is missing. Provide android/key.properties or " +
            "MATEYA_UPLOAD_STORE_FILE, MATEYA_UPLOAD_STORE_PASSWORD, " +
            "MATEYA_UPLOAD_KEY_ALIAS, MATEYA_UPLOAD_KEY_PASSWORD.",
    )
}

android {
    namespace = "com.zless.mateya"
    compileSdk = 36
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    signingConfigs {
        if (hasReleaseSigning) {
            create("release") {
                storeFile = file(releaseStoreFilePath!!)
                storePassword = releaseStorePassword
                keyAlias = releaseKeyAlias
                keyPassword = releaseKeyPassword
            }
        }
    }

    defaultConfig {
        applicationId = "com.zless.mateya"
        minSdk = 24
        targetSdk = 35
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        manifestPlaceholders["NAVER_MAP_CLIENT_ID"] = "io8sqad7yn"
    }

    buildTypes {
        release {
            signingConfig = if (hasReleaseSigning) {
                signingConfigs.getByName("release")
            } else {
                signingConfigs.getByName("debug")
            }
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}
