# Banking Financial Transaction Management System (Nexus Bank)
**Academic Project for SY BSc IT, SEC (Java Programming), Academic Year 2026–27**

A secure, enterprise-grade banking financial transaction simulation developed using **Java**, **Spring Boot**, and **MySQL**, featuring **JSP frontend**, **Gmail SMTP OTP verification**, **transactional email notifications**, **transaction outbox pattern**, and **full bank management (Accounts, Loans, Branches, Audit)**.

---

## 🌟 Key Features

### 1. Robust Email OTP Registration Workflow
* **Cryptographic 6-digit OTP generation** using `java.security.SecureRandom`.
* **One-way SHA-256 Hashing**: Plaintext OTPs are never persisted in the database.
* **Security Controls**:
  * 5-minute expiry window.
  * 60-second resend cooldown timer with live UI countdown.
  * Maximum 5 verification attempts per OTP to block brute-force attacks.
  * Max 3 resend attempts per session.
  * Single-use enforcement (immediate invalidation upon verification).
* **Automatic Account Creation**: Upon successful OTP verification, the user's status is updated to `email_verified=true` and a primary savings account is automatically generated.

### 2. Reliable Transaction Processing & Payment-Success Notifications
* **Atomic Fund Transfers**: Optimistic locking, balance verification, and atomic balance updates between sender and receiver.
* **Idempotency Protection**: Unique transaction references prevent duplicate debits or credits.
* **Transaction-Aware After-Commit Notifications**:
  * Success emails are sent **only after** the database transaction has committed.
  * Rolled-back or failed transactions never trigger emails.
  * **Outbox Pattern**: Notification jobs are recorded in the `transaction_notifications` table. If SMTP experiences a temporary failure, background schedulers retry delivery without affecting money movement.
* **Privacy & Isolation**:
  * Account numbers are masked (e.g., `ACC******1234`).
  * Amounts formatted cleanly in Indian Rupees (₹).
  * Sender and recipient receive segregated emails without exposing the other party's balance or sensitive credentials.

### 3. Complete Banking Management Suite
* **Customer Management**: User registration, profile view, password protection, and account association.
* **Account Management**: Balance inquiries, multi-account overview, status management.
* **Loan Management**: Apply for Personal, Home, Education, and Vehicle loans; view EMI estimates and approval statuses.
* **Branch Management**: Search and locate bank branches with IFSC codes and contact info.
* **Admin Dashboard & Audit**: Review transaction history, monitor notification outbox delivery statuses, and manage loan applications.

---

## 🛠️ Technology Stack

| Component | Technology |
|---|---|
| Language | Java 21 / 25 / 26 |
| Backend Framework | Spring Boot 3.2.5 (Spring MVC, Spring Data JPA, Spring Security Crypto) |
| Database | MySQL 8.x / 9.x |
| Frontend | JSP (JavaServer Pages), JSTL, HTML5, CSS3, JavaScript |
| Email Engine | Spring Boot JavaMailSender with Gmail SMTP & Fallback Console Simulation |
| Build Tool | Maven (via included `mvnw` wrapper) |
| Testing | JUnit 5, AssertJ, Spring Boot Test (19 automated test scenarios) |

---

## 🚀 Getting Started & Configuration

### Prerequisites
1. **Java JDK** (version 21 or higher) installed and set in your `PATH`.
2. **MySQL Server** (8.0+) installed and running locally on port 3306.

---

### Step 1: Database Setup
Log in to your MySQL terminal or MySQL Workbench and run:

```sql
CREATE DATABASE IF NOT EXISTS banking_db;
```

---

### Step 2: Environment Configuration
Create a `.env` file in the root project folder (or copy from [`.env.example`](.env.example)):

```bash
cp .env.example .env
```

#### Configuring Gmail SMTP with an App Password
To enable real email sending via Gmail:
1. Navigate to your [Google Account Security Settings](https://myaccount.google.com/security).
2. Enable **2-Step Verification**.
3. Under *2-Step Verification*, scroll down to **App passwords** (or visit [https://myaccount.google.com/apppasswords](https://myaccount.google.com/apppasswords)).
4. Create an app password with the app name `Nexus Bank`.
5. Google will provide a 16-character code (e.g., `abcd efgh ijkl mnop`).
6. Remove any spaces and configure your environment variables:

#### Setting Environment Variables

**Windows PowerShell:**
```powershell
$env:GMAIL_USERNAME="your-email@gmail.com"
$env:GMAIL_APP_PASSWORD="your16charpassword"
$env:DB_USERNAME="root"
$env:DB_PASSWORD="your_mysql_password"
```

**Windows Command Prompt (CMD):**
```cmd
set GMAIL_USERNAME=your-email@gmail.com
set GMAIL_APP_PASSWORD=your16charpassword
set DB_USERNAME=root
set DB_PASSWORD=your_mysql_password
```

**Linux / macOS (Bash):**
```bash
export GMAIL_USERNAME="your-email@gmail.com"
export GMAIL_APP_PASSWORD="your16charpassword"
export DB_USERNAME="root"
export DB_PASSWORD="your_mysql_password"
```

> [!NOTE]
> **Development / Simulation Mode**: If `GMAIL_USERNAME` or `GMAIL_APP_PASSWORD` is not set or left blank, the application will **not crash**. Instead, it safely falls back to **Simulation Mode**, logging the simulated OTPs and payment emails cleanly in the application console logs for testing without sending real emails.

---

### Step 3: Run the Application

Execute using the Maven Wrapper:

**Windows:**
```powershell
.\mvnw.cmd spring-boot:run
```

**Linux / macOS:**
```bash
./mvnw spring-boot:run
```

Once started, access the application in your browser at:
👉 **[http://localhost:8080](http://localhost:8080)**

---

## 🧪 Running Automated Tests

The application includes an extensive test suite with **19 comprehensive test cases** verifying:
- OTP generation, hashing, rate-limiting, and verification.
- Customer registration and email activation flow.
- Balance constraints, optimistic locking, and deposit/withdrawal/transfer rules.
- Notification outbox after-commit execution and rollback safety.
- Data isolation between distinct users.

Run all tests via:
```powershell
.\mvnw.cmd test
```

---

## 👥 Default Demo Credentials

The application seeds default administrative and customer accounts on startup:

| Role | Username | Password | Notes |
|---|---|---|---|
| **Admin** | `admin` | `admin123` | Full access to Admin Panel, Loan management & Outbox audit |
| **Demo Customer 1** | `john_doe` | `password123` | Pre-funded account: ₹25,000 |
| **Demo Customer 2** | `jane_smith` | `password123` | Pre-funded account: ₹40,000 |

---

## 📁 Project Structure

```
bankappliction/
├── src/
│   ├── main/
│   │   ├── java/com/bank/
│   │   │   ├── config/              # Security, Async, Mail configurations
│   │   │   ├── controller/          # Auth, Profile, Loan, Branch, Transaction controllers
│   │   │   ├── entity/              # User, Account, Transaction, Loan, Branch, OtpVerification
│   │   │   ├── event/               # Transaction events & after-commit listener
│   │   │   ├── exception/           # BankingException & GlobalExceptionHandler
│   │   │   ├── repository/          # Spring Data JPA repositories
│   │   │   └── service/             # OtpService, EmailService, FinancialTransactionService, etc.
│   │   ├── resources/
│   │   │   ├── application.properties
│   │   │   └── templates/email/     # HTML email templates
│   │   └── webapp/WEB-INF/views/    # JSP views (login, register, otp-verify, loans, branches, etc.)
│   └── test/java/com/bank/          # 19 automated integration & unit tests
├── .env.example                     # Sample environment variable template
├── pom.xml                          # Maven build dependencies & plugins
└── README.md                        # Project documentation
```
