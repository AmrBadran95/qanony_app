
# Legal Services Mobile Application

This mobile app provides comprehensive legal services for lawyers and clients, featuring task management, subscription plans, real-time consultations, and more.

---

## Features

- **Subscription System:** Free and paid tiers allowing lawyers to manage tasks and receive notifications.  
- **Task Management:** Lawyers can add, edit, and delete tasks with timely Firebase Cloud Messaging (FCM) reminders 10 minutes before appointments.  
- **Online Meetings:** Real-time consultations enabled via Zego SDK.  
- **Push Notifications:** Implemented using Firebase FCM with scheduled notifications handled by a Node.js server.  
- **Payment Gateway:** Integrated Stripe for subscription payments, including webhook support for seamless transaction handling.  
- **Backend Services:** Built with Node.js and Firebase Firestore, Authentication, and FCM for data synchronization.  
- **Admin Panel:** Developed with ReactJS for managing users, subscriptions, and application content.  
- **AI Integration:** Incorporates Gemini Model 2.5 for enhanced app intelligence and features.  
- **Sharing:** Content sharing functionality to boost user engagement.

---

## Technologies Used

- ReactJS (Admin Panel)  
- Flutter & Dart (Mobile App)  
- Firebase (Auth, Firestore, FCM)  
- Cloudinary (Image Storage)
- Node.js (Backend Server)  
- Stripe (Payment Gateway)  
- Zego SDK (Online Meetings)  
- AI Gemini Model 2.5

---

## Installation & Running

1. Clone the repo  

   ```bash
   git clone https://github.com/AmrBadran95/qanony_app
   ```

2. Install dependencies for backend and admin panel  

   ```bash
   flutter pub get
   ```

3. Setup Firebase and Stripe environment variables.  
4. Run backend server and admin panel.  
5. Build and run the Flutter mobile app.

---
