# 📊 ER Diagram - Scalable URL Shortener

## 🧠 Overview

This document describes the Entity-Relationship (ER) design for the URL Shortener System.

The system is designed following normalization principles and supports scalable analytics logging.

---

# 🧱 Entities

## 1️⃣ URLs

Represents all shortened URLs stored in the system.

### Attributes:

- id (Primary Key)
- original_url
- short_code (Unique)
- created_at
- click_count
- expiry_date

---

## 2️⃣ CLICK_LOGS

Stores every click event for analytics and reporting.

### Attributes:

- id (Primary Key)
- short_code (Foreign Key → URLs.short_code)
- clicked_at

---

# 🔗 Relationship

• One URL can have multiple click logs  
• Relationship Type: ONE-TO-MANY (1:N)  
• short_code acts as linking attribute  

---

# 📐 ER Diagram (Visual Representation - ASCII)

<img width="746" height="345" alt="image" src="https://github.com/user-attachments/assets/905a8cdf-aaf4-41d9-b815-70452637861f" />




---

# 🧩 Design Decisions

### ✔ Why Separate Click Logs?

Instead of storing click timestamps in the URLs table:

- Improves scalability
- Prevents table bloating
- Enables detailed analytics (time-based queries)
- Supports future geo/IP tracking

---

### ✔ Normalization

The design follows Third Normal Form (3NF):

- No repeating groups
- No redundant storage
- Proper separation of transactional and analytics data

---

# ⚡ Performance Considerations

- short_code is indexed for fast lookup
- click_logs.short_code optimized for reporting
- click_count maintained in URLs for quick reads
- Detailed logging handled separately

---

# 🚀 Future Extensibility

This ER design can be easily extended to support:

- User Accounts table
- Custom short URL mapping
- QR code generation
- Geo-location tracking
- Device analytics
- API key management

---

# 🎯 Learning Outcome

This ER model demonstrates:

- Database normalization
- One-to-Many relationship modeling
- Scalable analytics separation
- Backend data architecture thinking

---

⭐ This is part of Day 1 of the High-Package Engineer GitHub Challenge.
