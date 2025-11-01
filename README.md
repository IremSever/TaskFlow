# TaskFlow: Field Operations Management — Plan, Execute, Report
**TaskFlow** is a mobile application built to streamline the daily operations of field teams. From installation and maintenance to inspection tasks, TaskFlow helps teams plan, execute, and track work efficiently. Each task follows a structured lifecycle — ensuring clarity and accountability from start to finish.

Built with **SwiftUI** and the **MVVM architectural pattern**, TaskFlow delivers a responsive, modern, and reliable experience optimized for iOS devices. The app integrates **Firebase Authentication** for secure access and uses a custom **PDF generation service** to produce shareable task reports.

### Task Lifecycle
Every job in TaskFlow moves through a clearly defined process:
**Planned → To Do → In Progress → Control → Completed**
Once a task reaches the “Completed” stage, it can be exported as a professional **PDF report** for sharing or documentation purposes.

### Core Features
**Home Screen**
The home page provides a quick overview of tasks and key navigation cards. Each section is carefully designed for clarity and usability, helping users jump directly to active jobs, reports, or settings.

**Task Management**
Users can create, view, and manage tasks with required field validation. Each task contains essential details such as title, description, assigned user, SLA deadline, and status — all stored and synced via Firebase.

**Status Flow**
Tasks progress through a defined sequence: *Planned → To Do → In Progress → Control → Completed.*
This structure ensures transparent monitoring and accountability across teams.

**SLA Monitoring**
TaskFlow automatically monitors each task’s deadline (SLA). As the remaining time decreases, visual indicators change to **amber** or **red**, alerting the user of potential delays.

**PDF Report Generation**
When a task is marked as “Completed,” users can generate and share a detailed PDF report. The report includes task title, description, responsible person, completion date, and remarks — formatted through a dedicated PDF service integrated into the MVVM flow.

**Role-Based Access**
To maintain workflow integrity, only users with the *Administrator* role can create new tasks. Regular users can view and update assigned tasks.

**Settings**
A simple settings page allows users to switch app themes and log out. Firebase Authentication handles the full login and logout lifecycle securely.

### Technical Structure
TaskFlow is structured around **MVVM**, ensuring clean data flow and modular organization.

* **SwiftUI:** Declarative UI and state-driven rendering
* **Firebase Authentication:** Secure user management
* **TaskRepository:** Manages Firestore communication
* **PDFService:** Handles task data export and report creation
* **NavigationStack:** Provides smooth screen transitions

### User Flow Scenarios
**User Login**
Users log in using Firebase Authentication. Invalid credentials trigger a friendly alert message.
Once authenticated, they are directed to the home screen.

**Create New Task (Admin)**
Administrators can create a new task by entering title, description, SLA, and assigned user details. Missing fields are validated before saving.

**View or Update Task**
Users select a task from the list to view its details or change its current status. Status transitions update immediately in Firebase.

**Generate PDF Report**
Upon task completion, users tap “Generate PDF” to create and share a formatted report file.

### Architecture Overview
```
SwiftUI Views  →  ViewModels (Logic & State)  →  Services (Firebase, PDF, etc.)
```
Each component interacts independently for easier testing and scalability.
Data flows one way — from Firebase → ViewModel → View — ensuring consistent state management.

### Summary
TaskFlow demonstrates how **SwiftUI** and **MVVM** can be combined to build a functional, state-driven task management system. With features like **Firebase Authentication**, **SLA monitoring**, and **PDF reporting**, it provides a solid foundation for managing field operations digitally — efficiently and securely.

### App Screenshots

<p align="center">
  <img src="https://github.com/user-attachments/assets/90092ddc-7100-488a-8230-7e28d903c240" alt="taskflow_home" width="250"/>
  <img src="https://github.com/user-attachments/assets/dce97ffd-1463-469c-b740-73b05ea8858f" alt="taskflow_login" width="250"/>
  <img src="https://github.com/user-attachments/assets/e726d61c-4316-41dc-94ef-14eb1030f331" alt="taskflow_tasklist" width="250"/>
</p>

<p align="center">
  <img src="https://github.com/user-attachments/assets/c992d40e-cbb4-4f17-b965-7ef5471970d0" alt="taskflow_detail" width="250"/>
  <img src="https://github.com/user-attachments/assets/38909400-f3a8-4c72-b20f-627a644afdb8" alt="taskflow_pdf" width="250"/>
  <img src="https://github.com/user-attachments/assets/5966a49f-9a71-47ba-ac2b-95557dfa066f" alt="taskflow_sla" width="250"/>
</p>

<p align="center">
  <img src="https://github.com/user-attachments/assets/8959a56f-19e6-4cc3-87a7-6e9cb13fccc1" alt="taskflow_settings" width="250"/>
  <img src="https://github.com/user-attachments/assets/e2555349-690c-48be-80d8-3c231a5e6764" alt="taskflow_pdfshare" width="250"/>
  <img src="https://github.com/user-attachments/assets/a15c370e-8de0-4020-b224-1ed6161c87cf" alt="taskflow_complete" width="250"/>
</p>
