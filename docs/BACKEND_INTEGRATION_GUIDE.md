# 🔗 Backend Integration Guide for FoodEx Flutter App

## 📋 Table of Contents
1. [Project Overview](#project-overview)
2. [API Architecture](#api-architecture)
3. [Authentication System](#authentication-system)
4. [Data Models & Endpoints](#data-models--endpoints)
5. [Request/Response Format](#requestresponse-format)
6. [Error Handling](#error-handling)
7. [File Upload Specifications](#file-upload-specifications)
8. [Real-time Features](#real-time-features)
9. [Testing & Development](#testing--development)
10. [Deployment Guidelines](#deployment-guidelines)

---

## 🏗️ Project Overview

### Flutter App Structure
The FoodEx app follows **Clean Architecture** with these layers:
- **Core Layer**: Network, themes, constants, utilities
- **Data Layer**: Models, repositories, data sources
- **Presentation Layer**: UI screens and widgets

### User Types Supported
1. **Customer** - Orders food, manages profile, wallet
2. **Chef** - Manages restaurant, menu, orders
3. **Driver** - Handles delivery orders, tracking

---

## 🌐 API Architecture

### Base Configuration
```dart
// Current Flutter HTTP setup
class ServiceCall {
  static void post(Map<String, dynamic> parameter, String path,
      {bool isToken = false, ResSuccess? withSuccess, ResFailure? failure})
}
```

### Required Base URL Structure
```
https://your-api-domain.com/api/v1/
```

### HTTP Headers Required
```json
{
  "Content-Type": "application/json",
  "Accept": "application/json",
  "Authorization": "Bearer {jwt_token}",
  "User-Agent": "FoodEx-Flutter/1.0.0"
}
```

---

## 🔐 Authentication System

### 1. User Registration
**Endpoint**: `POST /auth/register`

**Request Body**:
```json
{
  "name": "John Doe",
  "email": "john@example.com",
  "phone": "+1234567890",
  "password": "securePassword123",
  "user_type": "customer", // "customer", "chef", "driver"
  "address": "123 Main St, City, Country"
}
```

**Success Response**:
```json
{
  "success": true,
  "message": "Registration successful",
  "data": {
    "user": {
      "id": "user_123",
      "name": "John Doe",
      "email": "john@example.com",
      "phone": "+1234567890",
      "user_type": "customer",
      "profile_image": null,
      "created_at": "2025-09-14T10:30:00Z",
      "is_active": true,
      "address": "123 Main St, City, Country",
      "wallet": {
        "id": "wallet_123",
        "balance": 0.00,
        "currency": "USD"
      }
    },
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "refresh_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
  }
}
```

### 2. User Login
**Endpoint**: `POST /auth/login`

**Request Body**:
```json
{
  "email": "john@example.com",
  "password": "securePassword123"
}
```

### 3. Password Reset
**Endpoint**: `POST /auth/forgot-password`

**Request Body**:
```json
{
  "email": "john@example.com"
}
```

**Endpoint**: `POST /auth/reset-password`

**Request Body**:
```json
{
  "email": "john@example.com",
  "otp": "123456",
  "new_password": "newSecurePassword123"
}
```

### 4. OTP Verification
**Endpoint**: `POST /auth/verify-otp`

**Request Body**:
```json
{
  "email": "john@example.com",
  "otp": "123456"
}
```

---

## 📊 Data Models & Endpoints

### 1. User Management

#### Get User Profile
**Endpoint**: `GET /users/profile`
**Headers**: Authorization required

#### Update User Profile
**Endpoint**: `PUT /users/profile`

**Request Body**:
```json
{
  "name": "John Doe Updated",
  "phone": "+1234567890",
  "address": "456 New St, City, Country"
}
```

#### Upload Profile Image
**Endpoint**: `POST /users/profile/image`
**Content-Type**: `multipart/form-data`

### 2. Menu & Restaurant Management

#### Get Restaurants
**Endpoint**: `GET /restaurants`

**Query Parameters**:
```
?page=1&limit=20&category=italian&search=pizza&latitude=40.7128&longitude=-74.0060&radius=5
```

**Response**:
```json
{
  "success": true,
  "data": {
    "restaurants": [
      {
        "id": "rest_123",
        "name": "Pizza Palace",
        "description": "Best pizza in town",
        "image": "https://example.com/restaurant.jpg",
        "rating": 4.5,
        "delivery_time": "30-45 mins",
        "delivery_fee": 3.99,
        "minimum_order": 15.00,
        "is_open": true,
        "categories": ["Italian", "Pizza"],
        "location": {
          "latitude": 40.7128,
          "longitude": -74.0060,
          "address": "123 Restaurant St"
        }
      }
    ],
    "pagination": {
      "current_page": 1,
      "total_pages": 5,
      "total_items": 50,
      "items_per_page": 20
    }
  }
}
```

#### Get Restaurant Menu
**Endpoint**: `GET /restaurants/{restaurant_id}/menu`

**Response**:
```json
{
  "success": true,
  "data": {
    "categories": [
      {
        "id": "cat_123",
        "name": "Appetizers",
        "items": [
          {
            "id": "item_123",
            "name": "Caesar Salad",
            "description": "Fresh romaine lettuce with caesar dressing",
            "price": 12.99,
            "image": "https://example.com/caesar-salad.jpg",
            "is_available": true,
            "preparation_time": 15,
            "ingredients": ["Lettuce", "Parmesan", "Croutons"],
            "allergens": ["Gluten", "Dairy"],
            "nutrition": {
              "calories": 250,
              "protein": 8,
              "carbs": 15,
              "fat": 18
            }
          }
        ]
      }
    ]
  }
}
```

### 3. Order Management

#### Create Order
**Endpoint**: `POST /orders`

**Request Body**:
```json
{
  "restaurant_id": "rest_123",
  "items": [
    {
      "menu_item_id": "item_123",
      "quantity": 2,
      "special_instructions": "No onions please"
    }
  ],
  "delivery_address": {
    "street": "123 Main St",
    "city": "New York",
    "state": "NY",
    "zip_code": "10001",
    "latitude": 40.7128,
    "longitude": -74.0060
  },
  "payment_method": "card", // "card", "wallet", "cash"
  "delivery_type": "delivery", // "delivery", "pickup"
  "coupon_code": "SAVE10"
}
```

**Response**:
```json
{
  "success": true,
  "data": {
    "order": {
      "id": "order_123",
      "order_number": "FEX-2025-001",
      "status": "pending", // "pending", "confirmed", "preparing", "ready", "out_for_delivery", "delivered", "cancelled"
      "restaurant": {
        "id": "rest_123",
        "name": "Pizza Palace"
      },
      "items": [
        {
          "menu_item_id": "item_123",
          "name": "Caesar Salad",
          "quantity": 2,
          "unit_price": 12.99,
          "total_price": 25.98,
          "special_instructions": "No onions please"
        }
      ],
      "subtotal": 25.98,
      "delivery_fee": 3.99,
      "tax": 2.60,
      "discount": 2.60,
      "total": 29.97,
      "estimated_delivery_time": "2025-09-14T11:30:00Z",
      "created_at": "2025-09-14T10:30:00Z"
    }
  }
}
```

#### Get User Orders
**Endpoint**: `GET /orders`

**Query Parameters**:
```
?page=1&limit=20&status=active&from_date=2025-09-01&to_date=2025-09-14
```

#### Get Order Details
**Endpoint**: `GET /orders/{order_id}`

#### Update Order Status (Chef/Driver only)
**Endpoint**: `PUT /orders/{order_id}/status`

**Request Body**:
```json
{
  "status": "preparing",
  "estimated_time": "25 minutes",
  "notes": "Order is being prepared"
}
```

### 4. Wallet Management

#### Get Wallet Balance
**Endpoint**: `GET /wallet`

**Response**:
```json
{
  "success": true,
  "data": {
    "wallet": {
      "id": "wallet_123",
      "balance": 125.50,
      "currency": "USD",
      "transactions": [
        {
          "id": "txn_123",
          "type": "credit", // "credit", "debit"
          "amount": 50.00,
          "description": "Wallet top-up",
          "reference": "stripe_pi_123",
          "created_at": "2025-09-14T10:00:00Z"
        }
      ]
    }
  }
}
```

#### Add Money to Wallet
**Endpoint**: `POST /wallet/topup`

**Request Body**:
```json
{
  "amount": 50.00,
  "payment_method": "stripe", // "stripe", "paypal", "apple_pay"
  "payment_token": "stripe_payment_intent_token"
}
```

### 5. Driver Features

#### Get Available Orders (Driver only)
**Endpoint**: `GET /driver/orders/available`

#### Accept Order (Driver only)
**Endpoint**: `POST /driver/orders/{order_id}/accept`

#### Update Location (Driver only)
**Endpoint**: `PUT /driver/location`

**Request Body**:
```json
{
  "latitude": 40.7128,
  "longitude": -74.0060,
  "heading": 90.0,
  "speed": 25.5
}
```

---

## 📨 Request/Response Format

### Standard Success Response
```json
{
  "success": true,
  "message": "Operation completed successfully",
  "data": {
    // Response data here
  },
  "meta": {
    "timestamp": "2025-09-14T10:30:00Z",
    "version": "v1",
    "request_id": "req_123456"
  }
}
```

### Standard Error Response
```json
{
  "success": false,
  "message": "Error description",
  "errors": {
    "field_name": ["Field specific error message"],
    "email": ["Email is required", "Email must be valid"]
  },
  "error_code": "VALIDATION_ERROR", // VALIDATION_ERROR, AUTH_ERROR, SERVER_ERROR, etc.
  "meta": {
    "timestamp": "2025-09-14T10:30:00Z",
    "version": "v1",
    "request_id": "req_123456"
  }
}
```

---

## ⚠️ Error Handling

### HTTP Status Codes
- **200**: Success
- **201**: Created
- **400**: Bad Request (Validation errors)
- **401**: Unauthorized (Invalid/expired token)
- **403**: Forbidden (Insufficient permissions)
- **404**: Not Found
- **422**: Unprocessable Entity (Validation errors)
- **429**: Too Many Requests (Rate limiting)
- **500**: Internal Server Error

### Error Codes
```dart
class ApiErrorCodes {
  static const String VALIDATION_ERROR = "VALIDATION_ERROR";
  static const String AUTH_ERROR = "AUTH_ERROR";
  static const String PERMISSION_ERROR = "PERMISSION_ERROR";
  static const String NOT_FOUND = "NOT_FOUND";
  static const String SERVER_ERROR = "SERVER_ERROR";
  static const String RATE_LIMIT = "RATE_LIMIT";
  static const String PAYMENT_ERROR = "PAYMENT_ERROR";
  static const String ORDER_ERROR = "ORDER_ERROR";
}
```

---

## 📁 File Upload Specifications

### Profile Images
- **Max Size**: 5MB
- **Formats**: JPG, PNG, WebP
- **Dimensions**: Min 200x200px, Max 2000x2000px
- **Quality**: 80% compression

### Restaurant/Menu Images
- **Max Size**: 10MB
- **Formats**: JPG, PNG, WebP
- **Dimensions**: Min 400x300px, Max 3000x2000px
- **Aspect Ratio**: 4:3 or 16:9 recommended

### Upload Response
```json
{
  "success": true,
  "data": {
    "file": {
      "id": "file_123",
      "url": "https://cdn.example.com/uploads/file_123.jpg",
      "thumbnail": "https://cdn.example.com/uploads/file_123_thumb.jpg",
      "size": 1048576,
      "mime_type": "image/jpeg",
      "dimensions": {
        "width": 1200,
        "height": 800
      }
    }
  }
}
```

---

## 📡 Real-time Features

### WebSocket Endpoints
```
wss://your-api-domain.com/ws/orders/{user_id}
wss://your-api-domain.com/ws/tracking/{order_id}
```

### Order Status Updates
```json
{
  "type": "order_status_update",
  "data": {
    "order_id": "order_123",
    "status": "preparing",
    "estimated_time": "20 minutes",
    "message": "Your order is being prepared"
  }
}
```

### Driver Location Updates
```json
{
  "type": "driver_location_update",
  "data": {
    "order_id": "order_123",
    "driver": {
      "name": "John Driver",
      "phone": "+1234567890",
      "vehicle": "Honda Civic - ABC123"
    },
    "location": {
      "latitude": 40.7128,
      "longitude": -74.0060,
      "heading": 90.0,
      "eta": "12 minutes"
    }
  }
}
```

---

## 🧪 Testing & Development

### Test Environment
- **Base URL**: `https://api-staging.foodex.com/api/v1/`
- **WebSocket**: `wss://api-staging.foodex.com/ws/`

### Test Credentials
```json
{
  "customer": {
    "email": "customer@test.com",
    "password": "test123"
  },
  "chef": {
    "email": "chef@test.com",
    "password": "test123"
  },
  "driver": {
    "email": "driver@test.com",
    "password": "test123"
  }
}
```

### API Rate Limits
- **Authentication**: 5 requests/minute
- **General API**: 100 requests/minute per user
- **File Upload**: 10 requests/minute

---

## 🚀 Deployment Guidelines

### Production Requirements
1. **HTTPS**: SSL certificate required
2. **CORS**: Configure for Flutter web domain
3. **Rate Limiting**: Implement rate limiting
4. **Logging**: Comprehensive API logging
5. **Monitoring**: Health checks and performance monitoring

### Environment Variables
```bash
# Database
DB_HOST=your-db-host
DB_USER=your-db-user
DB_PASS=your-db-password
DB_NAME=foodex_production

# JWT
JWT_SECRET=your-super-secret-jwt-key
JWT_REFRESH_SECRET=your-refresh-token-secret
JWT_EXPIRE=24h
JWT_REFRESH_EXPIRE=7d

# File Storage
AWS_S3_BUCKET=foodex-uploads
AWS_ACCESS_KEY=your-aws-key
AWS_SECRET_KEY=your-aws-secret

# Payment
STRIPE_SECRET_KEY=sk_live_...
STRIPE_WEBHOOK_SECRET=whsec_...

# Notifications
FCM_SERVER_KEY=your-fcm-server-key

# Email
SMTP_HOST=smtp.your-provider.com
SMTP_USER=noreply@foodex.com
SMTP_PASS=your-email-password
```

### Database Schema Considerations
```sql
-- Users table with user_type enum
CREATE TABLE users (
    id UUID PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    phone VARCHAR(20),
    password_hash VARCHAR(255) NOT NULL,
    user_type ENUM('customer', 'chef', 'driver') NOT NULL,
    profile_image VARCHAR(255),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Add indexes for performance
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_user_type ON users(user_type);
CREATE INDEX idx_users_created_at ON users(created_at);
```

---

## 📞 Support & Integration

### Flutter Integration Points
1. **Service Call Class**: `lib/core/network/service_call.dart`
2. **Data Models**: `lib/data/models/`
3. **Constants**: `lib/core/constants/globs.dart`
4. **Authentication**: Currently bypassed for testing

### Next Steps for Backend Developer
1. ✅ Set up base API structure with authentication
2. ✅ Implement user management endpoints
3. ✅ Create restaurant and menu management
4. ✅ Build order management system
5. ✅ Add payment integration
6. ✅ Implement real-time features
7. ✅ Set up file upload handling
8. ✅ Deploy to staging environment

### Contact Information
- **Frontend Developer**: [Your contact info]
- **Project Repository**: https://github.com/MOUBI9A/foodex
- **Documentation**: This file will be updated as integration progresses

---

**📋 This documentation provides everything needed to build a compatible backend API for the FoodEx Flutter application. Please follow the exact request/response formats to ensure seamless integration.**
