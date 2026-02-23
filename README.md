# 🔗 URL Shortener - System Design (Day 1)

## 📌 Problem Statement
Design a scalable URL shortening service like Bitly.

## 🎯 Requirements

### Functional Requirements
- User can submit a long URL.
- System returns a short URL.
- Short URL redirects to original URL.
- Track number of clicks.

### Non-Functional Requirements
- High availability
- Low latency
- Scalable to millions of users
- Reliable redirect

---

## 🏗️ High-Level Architecture

Client → Load Balancer → App Server → Database → Cache (Redis)

### Components:
- REST API (Flask / Node)
- Database (PostgreSQL / MySQL)
- Redis for caching
- Base62 encoding for short codes

---

## 🗂️ Database Schema

```sql
CREATE TABLE urls (
    id SERIAL PRIMARY KEY,
    original_url TEXT NOT NULL,
    short_code VARCHAR(10) UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    click_count INT DEFAULT 0
);
```

---

## 🔐 Short Code Generation

We use Base62 encoding for generating unique short URLs.

Example:
ID: 125 → Encoded → cb

---

## ⚡ Scaling Strategy

- Use Redis caching for frequently accessed links
- Horizontal scaling using multiple app servers
- Read replicas for database
- Partitioning if data becomes large

---

## 🚀 Future Improvements
- User accounts
- Custom short URLs
- Expiry time
- Rate limiting
- Analytics dashboard

---

## 🧠 Learning Outcome
- System design fundamentals
- Database modeling
- Caching strategy
- Scalability planning
