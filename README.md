

#  Student Internship Management System

A mobile application built with Flutter that connects students with internship opportunities. Admins can post internships, and students can apply and track their applications.

---

##  Group Members

| Name             | ID          |
|------------------|-------------|
| Bemnet Asseged   | UGR/2591/15 |
| Hintsete Hilawe  | UGR/6054/15 |
| Mahider Nardos   | UGR/4445/15 |
| Meklit Shiferaw  | UGR/5036/15 |
| Meron Sisay      | UGR/0752/15 |

---

##  Authentication and Authorization

- **Students** can:
  - Register and log in
  - Apply to internships
  - Track the status of their applications
  - Withdraw or update applications

- **Admins** can:
  - Log in to manage the system
  - Post new internship listings
  - Edit or remove existing opportunities

Role-based access ensures that only admins can manage listings, and only students can apply.

---

##  Business Features (with Full CRUD)

###  Internship Listings (Admin)
- **Create** internship opportunities
- **Read** all listings
- **Update** internship details
- **Delete** expired or invalid listings

###  Student Applications (Student)
- **Create** applications to internships
- **Read** status and details of applications
- **Update** personal submissions
- **Delete** or withdraw applications

---


### Frontend (Flutter)
- Flutter SDK
- Riverpod (for state management)
- Dio (for API calls)
- Flutter Secure Storage (for tokens)

### Backend (Node.js)
- Express.js
- MySQL (for backend database)
- JWT (Authentication)
- Bcrypt (Password hashing)
- CORS enabled API

---

## 🧾 Cloning & Running the Project

### 1. Clone the backend repository

```bash
git clone https://github.com/school-project-aait/internlink-API.git
cd internlink-API
npm install
npm start
 ```
### 2. Clone the Flutter frontend repository

```bash
git clone https://github.com/school-project-aait/InternLink-Frontend-Flutter.git
cd InternLink-Frontend-Flutter
flutter pub get
flutter run
```

### Make sure your emulator or device is running and your backend API URL is correctly set in your Flutter code (e.g., using baseUrl in your dio config).
