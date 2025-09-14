# 🔧 API Technical Specifications

## 📐 Database Models & Relationships

### Core Entity Relationships
```
User (1) -----> (1) Wallet
User (1) -----> (M) Orders
User (1) -----> (M) Reviews
Restaurant (1) -> (M) MenuItems
Restaurant (1) -> (M) Orders
Order (1) -----> (M) OrderItems
Order (1) -----> (1) Driver (optional)
```

### Detailed Database Schema

#### Users Table
```sql
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    phone VARCHAR(20),
    password_hash VARCHAR(255) NOT NULL,
    user_type ENUM('customer', 'chef', 'driver') NOT NULL,
    profile_image VARCHAR(500),
    address TEXT,
    latitude DECIMAL(10, 8),
    longitude DECIMAL(11, 8),
    is_active BOOLEAN DEFAULT TRUE,
    is_verified BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    INDEX idx_email (email),
    INDEX idx_user_type (user_type),
    INDEX idx_location (latitude, longitude)
);
```

#### Restaurants Table
```sql
CREATE TABLE restaurants (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    owner_id UUID NOT NULL,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    image VARCHAR(500),
    phone VARCHAR(20),
    address TEXT NOT NULL,
    latitude DECIMAL(10, 8) NOT NULL,
    longitude DECIMAL(11, 8) NOT NULL,
    cuisine_type VARCHAR(100),
    delivery_fee DECIMAL(10, 2) DEFAULT 0.00,
    minimum_order DECIMAL(10, 2) DEFAULT 0.00,
    delivery_time_min INT DEFAULT 30,
    delivery_time_max INT DEFAULT 60,
    rating DECIMAL(3, 2) DEFAULT 0.00,
    total_reviews INT DEFAULT 0,
    is_open BOOLEAN DEFAULT TRUE,
    is_active BOOLEAN DEFAULT TRUE,
    opening_time TIME,
    closing_time TIME,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (owner_id) REFERENCES users(id),
    INDEX idx_location (latitude, longitude),
    INDEX idx_cuisine (cuisine_type),
    INDEX idx_rating (rating)
);
```

#### Menu Categories Table
```sql
CREATE TABLE menu_categories (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    restaurant_id UUID NOT NULL,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    sort_order INT DEFAULT 0,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (restaurant_id) REFERENCES restaurants(id) ON DELETE CASCADE,
    INDEX idx_restaurant_sort (restaurant_id, sort_order)
);
```

#### Menu Items Table
```sql
CREATE TABLE menu_items (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    restaurant_id UUID NOT NULL,
    category_id UUID,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    price DECIMAL(10, 2) NOT NULL,
    image VARCHAR(500),
    preparation_time INT DEFAULT 15,
    is_available BOOLEAN DEFAULT TRUE,
    is_vegetarian BOOLEAN DEFAULT FALSE,
    is_vegan BOOLEAN DEFAULT FALSE,
    is_gluten_free BOOLEAN DEFAULT FALSE,
    calories INT,
    ingredients JSON,
    allergens JSON,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (restaurant_id) REFERENCES restaurants(id) ON DELETE CASCADE,
    FOREIGN KEY (category_id) REFERENCES menu_categories(id) ON DELETE SET NULL,
    INDEX idx_restaurant (restaurant_id),
    INDEX idx_category (category_id),
    INDEX idx_price (price),
    FULLTEXT idx_search (name, description)
);
```

#### Orders Table
```sql
CREATE TABLE orders (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    order_number VARCHAR(50) UNIQUE NOT NULL,
    customer_id UUID NOT NULL,
    restaurant_id UUID NOT NULL,
    driver_id UUID NULL,
    status ENUM('pending', 'confirmed', 'preparing', 'ready', 'out_for_delivery', 'delivered', 'cancelled') DEFAULT 'pending',
    order_type ENUM('delivery', 'pickup') DEFAULT 'delivery',
    payment_method ENUM('card', 'wallet', 'cash', 'online') NOT NULL,
    payment_status ENUM('pending', 'paid', 'failed', 'refunded') DEFAULT 'pending',
    
    -- Address information
    delivery_address TEXT,
    delivery_latitude DECIMAL(10, 8),
    delivery_longitude DECIMAL(11, 8),
    
    -- Pricing
    subtotal DECIMAL(10, 2) NOT NULL,
    delivery_fee DECIMAL(10, 2) DEFAULT 0.00,
    tax_amount DECIMAL(10, 2) DEFAULT 0.00,
    discount_amount DECIMAL(10, 2) DEFAULT 0.00,
    total_amount DECIMAL(10, 2) NOT NULL,
    
    -- Timing
    estimated_delivery_time TIMESTAMP,
    actual_delivery_time TIMESTAMP,
    
    -- Additional info
    special_instructions TEXT,
    coupon_code VARCHAR(50),
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (customer_id) REFERENCES users(id),
    FOREIGN KEY (restaurant_id) REFERENCES restaurants(id),
    FOREIGN KEY (driver_id) REFERENCES users(id),
    INDEX idx_customer (customer_id),
    INDEX idx_restaurant (restaurant_id),
    INDEX idx_driver (driver_id),
    INDEX idx_status (status),
    INDEX idx_created_at (created_at)
);
```

#### Order Items Table
```sql
CREATE TABLE order_items (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    order_id UUID NOT NULL,
    menu_item_id UUID NOT NULL,
    quantity INT NOT NULL DEFAULT 1,
    unit_price DECIMAL(10, 2) NOT NULL,
    total_price DECIMAL(10, 2) NOT NULL,
    special_instructions TEXT,
    
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
    FOREIGN KEY (menu_item_id) REFERENCES menu_items(id),
    INDEX idx_order (order_id)
);
```

#### Wallets Table
```sql
CREATE TABLE wallets (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID UNIQUE NOT NULL,
    balance DECIMAL(15, 2) DEFAULT 0.00,
    currency VARCHAR(3) DEFAULT 'USD',
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);
```

#### Wallet Transactions Table
```sql
CREATE TABLE wallet_transactions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    wallet_id UUID NOT NULL,
    transaction_type ENUM('credit', 'debit') NOT NULL,
    amount DECIMAL(15, 2) NOT NULL,
    description VARCHAR(255),
    reference_type ENUM('topup', 'order_payment', 'refund', 'commission') NOT NULL,
    reference_id UUID,
    payment_gateway VARCHAR(50),
    gateway_transaction_id VARCHAR(255),
    status ENUM('pending', 'completed', 'failed') DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (wallet_id) REFERENCES wallets(id) ON DELETE CASCADE,
    INDEX idx_wallet (wallet_id),
    INDEX idx_type (transaction_type),
    INDEX idx_status (status),
    INDEX idx_created_at (created_at)
);
```

---

## 🔐 Authentication & Security

### JWT Token Structure
```json
{
  "header": {
    "alg": "HS256",
    "typ": "JWT"
  },
  "payload": {
    "user_id": "user_123",
    "email": "user@example.com",
    "user_type": "customer",
    "iat": 1641234567,
    "exp": 1641321067,
    "jti": "token_unique_id"
  }
}
```

### Security Headers
```http
X-Content-Type-Options: nosniff
X-Frame-Options: DENY
X-XSS-Protection: 1; mode=block
Strict-Transport-Security: max-age=31536000; includeSubDomains
Content-Security-Policy: default-src 'self'
```

### Password Requirements
- Minimum 8 characters
- At least 1 uppercase letter
- At least 1 lowercase letter  
- At least 1 number
- At least 1 special character

### Rate Limiting
```yaml
Authentication Endpoints:
  - Login: 5 requests/5 minutes per IP
  - Register: 3 requests/hour per IP
  - Password Reset: 3 requests/hour per email

General API:
  - Authenticated Users: 1000 requests/hour
  - File Uploads: 50 requests/hour
  - Search: 200 requests/hour
```

---

## 📊 API Response Pagination

### Standard Pagination Parameters
```http
GET /api/v1/restaurants?page=1&limit=20&sort=rating&order=desc
```

### Pagination Response Format
```json
{
  "success": true,
  "data": {
    "items": [...],
    "pagination": {
      "current_page": 1,
      "per_page": 20,
      "total": 150,
      "total_pages": 8,
      "has_next": true,
      "has_prev": false,
      "next_page": 2,
      "prev_page": null
    }
  }
}
```

---

## 🔍 Search & Filtering

### Restaurant Search
```http
GET /api/v1/restaurants/search?
  q=pizza&
  cuisine=italian&
  min_rating=4.0&
  max_delivery_fee=5.00&
  latitude=40.7128&
  longitude=-74.0060&
  radius=10&
  delivery_time=45&
  sort=rating&
  order=desc
```

### Menu Item Search
```http
GET /api/v1/restaurants/{id}/menu/search?
  q=chicken&
  category=main-course&
  vegetarian=false&
  max_price=25.00&
  allergens_exclude=nuts,dairy
```

---

## 📱 Push Notifications

### FCM Payload Structure
```json
{
  "to": "user_fcm_token",
  "data": {
    "type": "order_status_update",
    "order_id": "order_123",
    "status": "preparing",
    "title": "Order Update",
    "body": "Your order is being prepared"
  },
  "notification": {
    "title": "Order Update",
    "body": "Your order is being prepared",
    "icon": "ic_notification",
    "sound": "default",
    "click_action": "FLUTTER_NOTIFICATION_CLICK"
  }
}
```

### Notification Types
1. **order_status_update** - Order status changes
2. **driver_assigned** - Driver assigned to order
3. **delivery_update** - Delivery progress updates
4. **promotion** - Marketing notifications
5. **wallet_transaction** - Wallet balance updates

---

## 💳 Payment Integration

### Stripe Integration
```javascript
// Backend - Create Payment Intent
const paymentIntent = await stripe.paymentIntents.create({
  amount: amount * 100, // Convert to cents
  currency: 'usd',
  customer: customer_id,
  metadata: {
    user_id: user_id,
    order_id: order_id
  }
});
```

### Payment Webhook Handling
```http
POST /webhooks/stripe
Content-Type: application/json
Stripe-Signature: webhook_signature

{
  "type": "payment_intent.succeeded",
  "data": {
    "object": {
      "id": "pi_1234567890",
      "amount": 2997,
      "currency": "usd",
      "metadata": {
        "user_id": "user_123",
        "order_id": "order_123"
      }
    }
  }
}
```

---

## 📍 Geolocation Features

### Distance Calculation Function
```sql
DELIMITER //
CREATE FUNCTION calculate_distance(
    lat1 DECIMAL(10,8), 
    lng1 DECIMAL(11,8), 
    lat2 DECIMAL(10,8), 
    lng2 DECIMAL(11,8)
) 
RETURNS DECIMAL(10,2)
READS SQL DATA
DETERMINISTIC
BEGIN
    DECLARE distance DECIMAL(10,2);
    SET distance = (
        6371 * acos(
            cos(radians(lat1)) * 
            cos(radians(lat2)) * 
            cos(radians(lng2) - radians(lng1)) + 
            sin(radians(lat1)) * 
            sin(radians(lat2))
        )
    );
    RETURN distance;
END //
DELIMITER ;
```

### Nearby Restaurants Query
```sql
SELECT 
    r.*,
    calculate_distance(?, ?, r.latitude, r.longitude) AS distance
FROM restaurants r
WHERE 
    calculate_distance(?, ?, r.latitude, r.longitude) <= ?
    AND r.is_active = TRUE
    AND r.is_open = TRUE
ORDER BY distance ASC, rating DESC
LIMIT ? OFFSET ?;
```

---

## 📈 Analytics & Monitoring

### Key Metrics to Track
```yaml
Business Metrics:
  - Total Orders per day/week/month
  - Revenue per restaurant
  - Average order value
  - Customer retention rate
  - Driver efficiency metrics

Technical Metrics:
  - API response times
  - Error rates by endpoint
  - Database query performance
  - File upload success rates
  - WebSocket connection stability
```

### Logging Structure
```json
{
  "timestamp": "2025-09-14T10:30:00Z",
  "level": "INFO",
  "service": "api",
  "endpoint": "/api/v1/orders",
  "method": "POST",
  "user_id": "user_123",
  "request_id": "req_123456",
  "response_time": 245,
  "status_code": 201,
  "ip_address": "192.168.1.100",
  "user_agent": "FoodEx-Flutter/1.0.0"
}
```

---

## 🧪 Testing Requirements

### Unit Test Coverage
- Minimum 80% code coverage
- All API endpoints tested
- Database operations tested
- Payment integration tested

### Integration Test Scenarios
```yaml
Authentication Flow:
  - User registration and email verification
  - Login with valid/invalid credentials
  - Password reset flow
  - Token refresh mechanism

Order Flow:
  - Browse restaurants and menu
  - Add items to cart
  - Place order with different payment methods
  - Track order status updates
  - Complete delivery

Driver Flow:
  - Accept/reject orders
  - Update location during delivery
  - Mark order as delivered

Payment Flow:
  - Wallet top-up
  - Order payment via different methods
  - Refund processing
  - Failed payment handling
```

### Load Testing
```yaml
Concurrent Users: 1000
Peak Load: 5000 requests/minute
Response Time: <500ms for 95% of requests
Uptime: 99.9%
```

---

## 🔧 Development Setup

### Required Environment
```bash
# Backend Technology Stack
Node.js: v18+ or Python 3.9+ or PHP 8.1+
Database: MySQL 8.0+ or PostgreSQL 13+
Redis: v6+ (for caching and sessions)
Storage: AWS S3 or equivalent
```

### Environment Configuration
```env
# API Configuration
API_PORT=3000
API_VERSION=v1
NODE_ENV=development

# Database
DB_TYPE=mysql
DB_HOST=localhost
DB_PORT=3306
DB_NAME=foodex_dev
DB_USER=foodex_user
DB_PASS=secure_password

# Redis
REDIS_HOST=localhost
REDIS_PORT=6379
REDIS_PASSWORD=redis_password

# JWT Configuration
JWT_SECRET=your-super-secret-jwt-key-minimum-32-characters
JWT_EXPIRE=24h
JWT_REFRESH_SECRET=your-refresh-secret-key
JWT_REFRESH_EXPIRE=7d

# File Storage
STORAGE_TYPE=s3
AWS_REGION=us-east-1
AWS_S3_BUCKET=foodex-uploads-dev
AWS_ACCESS_KEY_ID=your-access-key
AWS_SECRET_ACCESS_KEY=your-secret-key

# Payment Gateways
STRIPE_PUBLISHABLE_KEY=pk_test_...
STRIPE_SECRET_KEY=sk_test_...
STRIPE_WEBHOOK_SECRET=whsec_...

# Notifications
FCM_SERVER_KEY=your-fcm-server-key
FCM_SENDER_ID=your-sender-id

# Email Service
MAIL_DRIVER=smtp
MAIL_HOST=smtp.mailtrap.io
MAIL_PORT=2525
MAIL_USERNAME=your-username
MAIL_PASSWORD=your-password
MAIL_FROM_ADDRESS=noreply@foodex.com
MAIL_FROM_NAME=FoodEx

# SMS Service (Optional)
TWILIO_SID=your-twilio-sid
TWILIO_TOKEN=your-twilio-token
TWILIO_FROM=+1234567890

# Google Maps (for location services)
GOOGLE_MAPS_API_KEY=your-google-maps-key

# Rate Limiting
RATE_LIMIT_WINDOW=15
RATE_LIMIT_MAX_REQUESTS=100
```

---

## 🚀 Deployment Checklist

### Pre-deployment
- [ ] All environment variables configured
- [ ] Database migrations completed
- [ ] SSL certificates installed
- [ ] Rate limiting configured
- [ ] Error logging setup
- [ ] Backup strategy implemented
- [ ] Monitoring tools configured

### Post-deployment
- [ ] Health checks passing
- [ ] API documentation updated
- [ ] Load testing completed
- [ ] Security scan performed
- [ ] Backup restore tested
- [ ] Monitoring alerts configured

---

**📋 This technical specification complements the main backend integration guide and provides detailed implementation requirements for building the FoodEx API backend.**
