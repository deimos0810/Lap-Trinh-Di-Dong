# Fix Gradle/Java Incompatibility and Kotlin Version Issues

The project is failing to build due to two main reasons:
1. **Java/Gradle Incompatibility**: The current Gradle version (7.6.3) does not support the Java version being used (25.0.2).
2. **Kotlin Language Version**: The build is complaining about Kotlin language version 1.4 being unsupported.

## Proposed Changes

### [Component Name] Android Build Configuration

#### [MODIFY] [gradle-wrapper.properties](file:///D:/Zalo/LTDD/2001230180/buoi3/android/gradle/wrapper/gradle-wrapper.properties)
- Upgrade Gradle from `7.6.3` to `8.10.2` to support newer Java versions.

#### [MODIFY] [settings.gradle.kts](file:///D:/Zalo/LTDD/2001230180/buoi3/android/settings.gradle.kts)
- Upgrade Android Gradle Plugin (AGP) version to `8.2.2`.
- Upgrade Kotlin version to `1.9.22`.

#### [MODIFY] [app/build.gradle.kts](file:///D:/Zalo/LTDD/2001230180/buoi3/android/app/build.gradle.kts)
- Ensure compatibility with AGP 8.x (e.g. check namespace, though it seems already present).
- (Optional) Bump `jvmTarget` to `17` if needed, but `11` should still work. I'll keep it at `11` for now to minimize changes unless it fails.

## Verification Plan

### Automated Tests
- Run `./gradlew clean build` (via `flutter build apk` or similar command) to verify the build succeeds.

### Manual Verification
- Check the output of the build to ensure no more "Language version 1.4" or "Java compatibility" errors.
