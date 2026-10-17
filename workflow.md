# Doctor Hunt - MVP Feature Scope
**Product Specification & Architecture Blueprint**

---

## 1. Project Overview & Single Core Journey

### Locked MVP Scope
Doctor Hunt is a streamlined doctor discovery and appointment booking system focused strictly on solving a single linear patient journey without operational overhead:

$$\text{1. Find Doctor} \longrightarrow \text{2. Doctor Details} \longrightarrow \text{3. Book Slot} \longrightarrow \text{4. Manage Booking} \longrightarrow \text{5. Rate Doctor}$$

### System Composition
* **Patient App:** Doctor discovery, slot booking, status tracking & reviews.
* **Admin App:** Doctor management, availability rules & appointment control.
* **Shared Architecture:** 1 central clinic location set by Admin.

### Core Architectural Invariants
* **No Doctor App / Login:** Managed entirely by the Clinic Admin.
* **No Doctor-Specific Location:** All doctors inherit Admin Clinic Location.
* **No Complex States:** Strictly `Upcoming`, `Completed`, and `Cancelled`.

---

## 2. Explicitly Out of Scope (Locked Matrix)

The original design contains extensive modules intentionally removed to keep the MVP agile and stable:

* [x] Live Doctors
* [x] Medical Records
* [x] Diagnostic Tests
* [x] Medicines / Orders
* [x] My Doctors
* [x] Health Packages
* [x] Online Consultation
* [x] In-App Chat
* [x] Payments / Gateways
* [x] Multiple Profiles
* [x] Facebook / Apple Login
* [x] Admin Roles & Permissions
* [x] Doctor Experience Years
* [x] Doctor-Specific Location
* [x] Admin Analytics Dashboard
* [x] Admin Self-Registration *(Future)*

---

## 3. Onboarding, Role Selection & Authentication

### 1. Onboarding & Role Selection
* **Screens:** Splash Screen & Onboarding Screens (`Skip` / `Get Started`).
* **Choose Role:** Select **Patient** vs **Admin** before entering Auth.
* **Role Architecture:** Kept at entry point to support future Admin self-registration without changing app navigation.

### 2. Authentication (Email/Password + Google)
* **Patient:** Sign Up, Login, Google Sign-In, Forgot / Reset Password.
* **Admin:** Login only (Email + Password). Self Sign-Up is marked as *Future-Ready*.
* **Session:** Secure Logout via App Settings.

---

## 4. Discovery, Favorites & Single Location Architecture

### 1. Patient Home Screen
* Patient Greeting & Profile Avatar.
* Doctor Search Bar & Specialty Chips.
* **Popular Doctors:** Sorted by `reviewsCount` descending (Active doctors only). *"See All"* $\rightarrow$ Doctors list sorted by popularity.
* **Top Rated Doctors:** Sorted by `rating` descending (Active doctors only). *"See All"* $\rightarrow$ Doctors list sorted by rating.

### 2. Doctor Discovery & Card Data
* **Listing:** Search by name, filter by medical specialty.
* **Doctor Card Components:** Image, Full Name, Specialty, Rating & Review Count, Fee, Favorite Heart, "Book Now" CTA.
* **Favorites:** Save/remove doctor for rapid 1-tap access.

### 3. Doctor Details, Rating & Location Rule
* **Doctor Details:** Profile photo, Name, Specialty, Fee, Rating summary (e.g., 4.7 - 24 Reviews), Recent Reviews, Clinic Location, and Available slots.
* **Admin Central Location:** Doctor location is not entered per doctor. Displays the single Admin Location. Changing it in Admin updates all doctors globally.

---

## 5. The 4-Step Booking Flow

```
[ Doctor Details ]
       │
       ▼ (Book Now)
[ Step 1: Select Date ]
       │ Calendar displays dates generated from doctor's active working days
       ▼
[ Step 2: Select Time Slot ]
       │ Presents generated slots (e.g., 09:00 AM, 09:30 AM, 10:00 AM)
       ▼
[ Step 3: Review Appointment ]
       │ Doctor Name, Specialty, Date & Time, Fee, Central Clinic Location
       ▼
[ Step 4: Confirm Booking ]
       │ Click Confirm → Status set to Upcoming
       ▼
[ Success Confirmation Dialog ]
```

---

## 6. Appointment States (3-State Rule)

```
                       ┌────────────────┐
                       │    Upcoming    │
                       └───────┬────────┘
                               │
            ┌──────────────────┴──────────────────┐
            ▼                                     ▼
     ┌─────────────┐                       ┌─────────────┐
     │  Cancelled  │                       │  Completed  │
     └─────────────┘                       └──────┬──────┘
                                                  ▼
                                           [ Rate Doctor ]
```

1. **Upcoming:**
   * Patient can **Cancel**.
   * Admin can **Cancel** or **Mark Completed**.
2. **Completed:**
   * Consultation concluded.
   * Unlocks doctor review & rating eligibility for the patient.
3. **Cancelled:**
   * Terminated by patient or admin.
   * View only. Cannot review.

---

## 7. Reviews & Ratings Engine (Post-Appointment)

### Review Flow & Strict Eligibility
* **Eligibility Condition:** Strictly `Appointment.status == completed`. Patients cannot review Upcoming or Cancelled visits.
* **Submission Flow:** `Completed` $\rightarrow$ `Rate Doctor` $\rightarrow$ Select 1–5 Stars $\rightarrow$ Optional Comment $\rightarrow$ `Submit` $\rightarrow$ Review Added.
* **Doctor Aggregation:** Doctor document maintains aggregated rating (`rating`) & `reviewsCount`. Full review records reside in the `reviews` collection.

### Review Schema & Exclusions
* **Schema Definition:**
  ```typescript
  interface Review {
    id: string;
    appointmentId: string;
    patientId: string;
    doctorId: string;
    rating: number; // 1 - 5
    comment?: string;
    createdAt: string; // ISO Timestamp
  }
  ```
* **Doctor Details Display:** Displays aggregate rating (e.g., 4.7 - 24 Reviews) and recent patient comments.
* **Strict Exclusions:** No doctor replies, likes, review reports, photos, moderation dashboard, or edit history.

---

## 8. Patient Profile & Navigation Structure

### Profile & Minimal Settings
* **Profile Fields:** Photo, Full Name, Email (view only, cannot be changed), Phone, DOB, Gender (View / Edit). The photo is uploaded by the user; without one a person icon is shown.
* **Settings:** Change Password, Notifications toggle, Language, Logout confirmation modal.

### Patient App 4-Tab Navigation
| Tab | Key Screens & Actions |
| :--- | :--- |
| **Home** | Search bar, Specialties, Popular & Top Rated Doctors. |
| **Doctors** | Discovery list, Specialty filters, Favorites. |
| **Appointments** | Upcoming (Cancel action), Completed (Rate Doctor action), Cancelled. |
| **Profile** | Edit info, Security, Settings & Logout. |

---

## 9. Admin Operations & Detailed Workflows

### 1. Admin Login Flow
Admin authentication is strictly Email + Password. No self-registration in MVP (*Future-ready architecture*).
$$\text{Choose Role} \longrightarrow \text{Admin Login (Email + Password)} \longrightarrow \text{Success} \longrightarrow \text{Doctors List}$$

### 2. Create Doctor Flow
* **Strict Rule:** No Location or Experience fields in Create Doctor. Location is inherited centrally from Admin.
$$\text{Admin Doctors} \longrightarrow \text{Add Doctor} \longrightarrow \text{Enter [Photo, Name, Specialty, Fee]} \longrightarrow \text{Create} \longrightarrow \text{Doctors List}$$

### 3. Doctors Management Directory
Controls doctor discovery listing, filtering, and live operational status:
* **Listing & Filtering:** Total / Active counters, search by name, filter by specialty.
* **Edit Profile:** Update Doctor Photo, Name, Specialty, Fee.
* **Status Switch:** Activate / Deactivate toggle instead of permanent deletion to preserve booking histories.
$$\text{Admin Doctors} \longrightarrow \text{Search / Filter} \longrightarrow \text{Select Doctor Details} \longrightarrow \text{[Edit | Availability | Status]}$$

### 4. Doctor Availability Engine
Defines doctor schedule so the system can generate valid patient booking slots:
* **Working Days:** Monday through Sunday toggle flags.
* **Working Hours:** Start & End time (e.g., 09:00 AM – 05:00 PM).
* **Slot Duration:** Configurable interval (e.g., 30 Minutes).
$$\text{Doctor Details} \longrightarrow \text{Availability} \longrightarrow \text{Select Days} \longrightarrow \text{Set Hours} \longrightarrow \text{Set Slot Duration} \longrightarrow \text{Save} \longrightarrow \text{Generates Booking Slots}$$

### 5. Appointments Operations
Admin manages all patient bookings across 4 primary tabs:
* **Tabs:** `All`, `Upcoming`, `Completed`, `Cancelled`.
* **Upcoming Actions:** Cancel or Mark Completed.
* **Completed / Cancelled:** View Only.
* **Patient Data:** Basic contact info is displayed inside appointment details (*no standalone Patients module in MVP*).

### 6. Admin Profile & Central Location
The single source of truth for the physical clinic location across the entire platform:
* **Admin Data:** Photo, Full Name, Email, Clinic Location.
* **Location Propagation:** When Admin updates the Clinic Location, it instantly updates on Doctor Details, Slot Review & Appointment Details for all doctors.
$$\text{Admin Settings} \longrightarrow \text{Admin Profile Edit [Photo, Name, Email, Clinic Location]} \longrightarrow \text{Save} \longrightarrow \text{Central Location Updated}$$

---

## 10. Complete Admin Workflow Architecture

```
[ ADMIN LOGIN ] (Email + Password)
       │
       ▼
[ DOCTORS LIST ] (Search / Specialties / Counters)
       │
       ├───► [ + Add / Create Doctor ] ──► Enter [Photo, Name, Specialty, Fee]
       │
       └───► [ Doctor Details ]
                   │
                   ├───► [ Edit Doctor Profile ]
                   │
                   ├───► [ Active / Inactive Status ]
                   │
                   └───► [ Manage Availability ]
                               │
                               ▼
                       [ GENERATED SLOTS ] (Open for Patient Booking)
                               │
                               ▼
[ ADMIN APPOINTMENTS ] (All / Upcoming / Completed / Cancelled)
       │
       ▼
[ Appointment Details ] (Embedded Patient Info)
       │
       ├───► [ CANCEL ]
       │
       └───► [ MARK COMPLETED ]
                   │
                   ▼
           [ PATIENT RATES ] (Unlocks 1-5 Star Rating & Review)
```

---

## 11. Final Master Feature Checklist

### Patient App Feature Checklist
- [x] Onboarding & Splash
- [x] Choose Role Entry Flow
- [x] Email/Password Auth
- [x] Google Sign-In
- [x] Reset Password
- [x] Home Screen & Search
- [x] Popular Doctors
- [x] Top Rated Doctors
- [x] Specialty Filters
- [x] Doctor Details & Location
- [x] Favorites Add/Remove
- [x] Select Booking Date / Slot
- [x] Review & Confirm Booking
- [x] Upcoming / Completed / Cancelled Tabs
- [x] Cancel Upcoming Booking
- [x] Rate Doctor (1–5 Stars)
- [x] Optional Review Comment
- [x] View Doctor Ratings & Reviews

### Admin App Feature Checklist
- [x] Choose Role $\rightarrow$ Admin
- [x] Admin Login Auth
- [x] Doctor List & Counters
- [x] Search & Filter Doctors
- [x] Create Doctor Profile
- [x] Edit Doctor Profile
- [x] Activate / Deactivate Switch
- [x] Working Days Setup
- [x] Working Hours & Slots Configuration
- [x] 4 Appointment Tabs (All / Upcoming / Completed / Cancelled)
- [x] Embedded Patient Info in Appointments
- [x] Mark Appointment Completed
- [x] Cancel Appointment
- [x] View Rating & Review Count
- [x] Update Central Clinic Location
- [x] Admin Settings & Logout