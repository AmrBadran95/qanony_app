# Keep Stripe classes
-keep class com.stripe.** { *; }
-keep class **.zego.** { *; }

-keep class **.**.zego_zpns.**{*;}

# Keep Stripe push provisioning classes to avoid missing class errors
-keep class com.stripe.android.pushProvisioning.** { *; }
-keep class com.reactnativestripesdk.pushprovisioning.** { *; }
-dontwarn com.stripe.android.pushProvisioning.**
-dontwarn com.reactnativestripesdk.pushprovisioning.**
