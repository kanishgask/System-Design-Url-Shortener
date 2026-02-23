# 🔗 Scalable URL Shortener - System Design + Backend Implementation

> Day 1 of High-Package Software Engineer Journey 🚀

---

## 📌 Problem Statement

Design a production-ready URL shortening service similar to Bitly or TinyURL that can handle millions of requests per day with low latency and high availability.

---

## 🎯 Functional Requirements

- User can shorten a long URL
- Short URL redirects to original URL
- Track click count
- Handle duplicate URL submissions
- Provide REST API endpoints

---

## ⚙️ Non-Functional Requirements

- High availability (99.9% uptime)
- Low latency (<100ms redirect)
- Horizontal scalability
- Fault tolerance
- Unique short codes
- Secure API endpoints

---

# 🏗️ High-Level Architecture

Client  
   ↓  
Load Balancer  
   ↓  
Application Servers  
   ↓  
Cache Layer (Redis)  
   ↓  
Primary Database  
   ↓  
Read Replicas  

---

# 🧠 Design Decisions

## 1️⃣ Short Code Generation Strategy

Options Considered:
- Hashing (MD5/SHA)
- Base62 Encoding of Auto-Increment ID
- Random String Generation

✔ Selected Approach: Base62 Encoding  
Reason:
- Short URLs
- Avoids collisions
- Easy to scale

---

## 2️⃣ Database Design

```sql
CREATE TABLE urls (
    id BIGSERIAL PRIMARY KEY,
    original_url TEXT NOT NULL,
    short_code VARCHAR(10) UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    click_count BIGINT DEFAULT 0,
    expiry_date TIMESTAMP NULL
);
```

### Indexing Strategy
- Index on short_code
- Optional index on created_at for analytics queries

---

## 3️⃣ Caching Strategy

- Frequently accessed URLs stored in Redis
- TTL (Time To Live) option
- Reduces DB load
- Improves redirect performance

Flow:
Check Redis → If miss → Check DB → Store in Redis → Redirect

---

## 4️⃣ API Design

### Shorten URL
```
POST /api/v1/shorten
```

Request:
```json
{
    "url": "https://example.com/very-long-url"
}
```

Response:
```json
{
    "short_url": "https://myapp.com/abc123"
}
```

---

### Redirect
```
GET /{short_code}
```

---

## 📈 Scaling Strategy

### Horizontal Scaling
- Multiple application servers behind load balancer

### Database Scaling
- Read replicas
- Sharding based on ID range (if extremely large scale)

### Handling 10M+ Users
- CDN for static assets
- Async analytics logging
- Background workers for click processing

---

## 🔐 Security Considerations

- URL validation to avoid malicious URLs
- Rate limiting (prevent abuse)
- HTTPS enforcement
- API key authentication
- Protection against brute force short-code scanning

---

## ⚡ Performance Optimization

- Lazy click count updates using async processing
- Use connection pooling
- Proper DB indexing
- Compression for API responses

---

## 🚀 Future Enhancements

- Custom short URLs
- Expiry management
- Dashboard for analytics
- User authentication system
- QR code generation
- Geo-analytics

---

## 🧩 Trade-offs Considered

| Approach | Pros | Cons |
|----------|------|------|
| Random code generation | Easy | Collision risk |
| Hashing | Deterministic | Long string |
| Base62 from ID | Short & scalable | Requires DB roundtrip |

---

## 🧠 Concepts Demonstrated

- System Design Fundamentals
- REST API Design
- Database Modeling
- Caching Layer Integration
- Scaling Techniques
- Backend Architecture Thinking

---

## 🛠️ Tech Stack

- Python (Flask)
- PostgreSQL
- Redis
- Docker (optional)
- Nginx (for reverse proxy)

---

## 📚 Learning Outcome

This project demonstrates understanding of:

- Distributed systems basics
- Scalability principles
- CAP theorem awareness
- Backend optimization techniques
- Production-ready application design

---

⭐ This project is part of a 30-day high-impact GitHub engineering challenge.
