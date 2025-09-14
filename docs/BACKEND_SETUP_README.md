# FoodEx Backend Development Setup

Welcome to the FoodEx backend development documentation! This guide will help you set up and develop the backend API for the FoodEx Flutter application.

## 📋 Prerequisites

- Node.js 18+ or Python 3.8+ (depending on your preferred tech stack)
- MongoDB or PostgreSQL database
- Redis for caching
- Stripe account for payments
- Firebase account for push notifications
- AWS S3 or similar for file storage

## 🚀 Quick Start

### 1. Environment Setup

Create a `.env` file with the following variables:

```env
# Database
DATABASE_URL=mongodb://localhost:27017/foodex
# or for PostgreSQL: postgresql://user:password@localhost/foodex

# JWT
JWT_SECRET=your-super-secure-jwt-secret-key
JWT_EXPIRES_IN=24h

# Redis
REDIS_URL=redis://localhost:6379

# Stripe
STRIPE_SECRET_KEY=sk_test_your_stripe_secret_key
STRIPE_WEBHOOK_SECRET=whsec_your_webhook_secret

# Firebase
FIREBASE_PROJECT_ID=your-firebase-project
FIREBASE_PRIVATE_KEY=your-firebase-private-key
FIREBASE_CLIENT_EMAIL=your-firebase-client-email

# File Storage
AWS_ACCESS_KEY_ID=your-aws-access-key
AWS_SECRET_ACCESS_KEY=your-aws-secret-key
AWS_BUCKET_NAME=foodex-uploads
AWS_REGION=us-east-1

# App Config
API_BASE_URL=http://localhost:3000/api/v1
PORT=3000
NODE_ENV=development

# Email (Optional)
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USER=your-email@gmail.com
SMTP_PASS=your-app-password

# Push Notifications
FCM_SERVER_KEY=your-fcm-server-key

# Geolocation
GOOGLE_MAPS_API_KEY=your-google-maps-api-key
```

### 2. Project Structure (Recommended)

```
backend/
├── src/
│   ├── controllers/
│   │   ├── auth.controller.js
│   │   ├── user.controller.js
│   │   ├── restaurant.controller.js
│   │   ├── order.controller.js
│   │   ├── wallet.controller.js
│   │   └── driver.controller.js
│   ├── models/
│   │   ├── User.js
│   │   ├── Restaurant.js
│   │   ├── MenuItem.js
│   │   ├── Order.js
│   │   ├── Wallet.js
│   │   └── Transaction.js
│   ├── middleware/
│   │   ├── auth.middleware.js
│   │   ├── validation.middleware.js
│   │   └── upload.middleware.js
│   ├── routes/
│   │   ├── auth.routes.js
│   │   ├── user.routes.js
│   │   ├── restaurant.routes.js
│   │   ├── order.routes.js
│   │   └── wallet.routes.js
│   ├── services/
│   │   ├── auth.service.js
│   │   ├── payment.service.js
│   │   ├── notification.service.js
│   │   └── geolocation.service.js
│   ├── utils/
│   │   ├── jwt.utils.js
│   │   ├── email.utils.js
│   │   └── validation.utils.js
│   └── app.js
├── package.json
├── .env
└── README.md
```

### 3. Installation Commands

#### For Node.js/Express:
```bash
npm init -y
npm install express mongoose bcryptjs jsonwebtoken
npm install cors helmet morgan express-rate-limit
npm install multer aws-sdk stripe firebase-admin
npm install nodemailer joi socket.io redis
npm install --save-dev nodemon jest supertest
```

#### For Python/FastAPI:
```bash
pip install fastapi uvicorn
pip install pymongo motor bcrypt PyJWT
pip install python-multipart boto3 stripe-python
pip install firebase-admin python-socketio redis
pip install pytest pytest-asyncio
```

## 📱 Flutter App Integration Points

### Key Service Call Implementation

The Flutter app uses this service call structure:

```dart
// lib/core/network/service_call.dart
static Future<http.Response> post(
  Map<String, dynamic> parameter,
  String path, {
  bool isToken = false,
}) async {
  var headers = {
    'Content-Type': 'application/json; charset=UTF-8',
  };
  
  if (isToken) {
    headers['Authorization'] = 'Bearer ${SharedPreferences token}';
  }
  
  return await http.post(
    Uri.parse('${Globs.baseURL}$path'),
    headers: headers,
    body: jsonEncode(parameter),
  );
}
```

### Required API Endpoints

Based on the Flutter app analysis, you need to implement these endpoints:

#### Authentication Endpoints
- `POST /api/v1/auth/register`
- `POST /api/v1/auth/login`
- `POST /api/v1/auth/forgot-password`
- `POST /api/v1/auth/reset-password`
- `POST /api/v1/auth/verify-otp`

#### User Management
- `GET /api/v1/users/profile`
- `PUT /api/v1/users/profile`
- `POST /api/v1/users/profile/image`

#### Restaurant & Menu
- `GET /api/v1/restaurants`
- `GET /api/v1/restaurants/:id`
- `GET /api/v1/restaurants/:id/menu`
- `GET /api/v1/restaurants/search`

#### Orders
- `POST /api/v1/orders`
- `GET /api/v1/orders`
- `GET /api/v1/orders/:id`
- `PUT /api/v1/orders/:id/status`

#### Wallet
- `GET /api/v1/wallet`
- `POST /api/v1/wallet/topup`
- `GET /api/v1/wallet/transactions`

## 🔧 Essential Features to Implement

### 1. Authentication System
```javascript
// Example JWT middleware
const authMiddleware = (req, res, next) => {
  const token = req.header('Authorization')?.replace('Bearer ', '');
  
  if (!token) {
    return res.status(401).json({ message: 'Access denied' });
  }
  
  try {
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    req.user = decoded;
    next();
  } catch (error) {
    res.status(401).json({ message: 'Invalid token' });
  }
};
```

### 2. Real-time Order Tracking
```javascript
// Socket.io implementation for real-time updates
io.on('connection', (socket) => {
  socket.on('join_order_room', (orderId) => {
    socket.join(`order_${orderId}`);
  });
  
  socket.on('join_driver_room', (driverId) => {
    socket.join(`driver_${driverId}`);
  });
});

// Emit order status updates
const updateOrderStatus = (orderId, status) => {
  io.to(`order_${orderId}`).emit('order_status_update', {
    orderId,
    status,
    timestamp: new Date()
  });
};
```

### 3. Payment Integration
```javascript
// Stripe payment processing
const processPayment = async (amount, paymentMethodId) => {
  const paymentIntent = await stripe.paymentIntents.create({
    amount: amount * 100, // Convert to cents
    currency: 'usd',
    payment_method: paymentMethodId,
    confirmation_method: 'manual',
    confirm: true,
  });
  
  return paymentIntent;
};
```

### 4. Geolocation Services
```javascript
// Calculate distance between coordinates
const calculateDistance = (lat1, lon1, lat2, lon2) => {
  const R = 6371; // Earth's radius in km
  const dLat = (lat2 - lat1) * Math.PI / 180;
  const dLon = (lon2 - lon1) * Math.PI / 180;
  
  const a = Math.sin(dLat/2) * Math.sin(dLat/2) +
    Math.cos(lat1 * Math.PI / 180) * Math.cos(lat2 * Math.PI / 180) *
    Math.sin(dLon/2) * Math.sin(dLon/2);
  
  const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));
  return R * c;
};
```

## 📋 Testing with Postman

1. Import the Postman collection: `docs/FoodEx_API_Postman_Collection.json`
2. Set up environment variables:
   - `base_url`: Your API base URL
   - `auth_token`: Will be set automatically after login
3. Start with authentication endpoints
4. Test all CRUD operations for each module

## 🔍 Key Integration Requirements

### Flutter App Expects These Response Formats:

#### Success Response:
```json
{
  "status": "success",
  "message": "Operation completed successfully",
  "data": {
    // Your response data here
  }
}
```

#### Error Response:
```json
{
  "status": "error",
  "message": "Error description",
  "errors": {
    "field": ["Validation error message"]
  }
}
```

### User Object Structure:
```json
{
  "id": "user_123",
  "name": "John Doe",
  "email": "john@example.com",
  "phone": "+1234567890",
  "user_type": "customer",
  "address": "123 Main St",
  "profile_image": "https://bucket.s3.com/profile.jpg",
  "is_verified": true,
  "wallet": {
    "balance": 50.00,
    "currency": "USD"
  },
  "created_at": "2024-01-01T00:00:00Z",
  "updated_at": "2024-01-01T00:00:00Z"
}
```

## 🚦 Deployment Checklist

- [ ] Environment variables configured
- [ ] Database migrations completed
- [ ] Redis cache configured
- [ ] File upload storage configured
- [ ] Payment webhooks set up
- [ ] Push notification service configured
- [ ] SSL certificates installed
- [ ] Rate limiting configured
- [ ] Error logging set up
- [ ] Health check endpoint working
- [ ] API documentation deployed

## 📞 Support

- Check the complete API documentation: `docs/BACKEND_INTEGRATION_GUIDE.md`
- Review technical specifications: `docs/API_TECHNICAL_SPECIFICATIONS.md`
- Test with Postman collection: `docs/FoodEx_API_Postman_Collection.json`

## 🎯 Next Steps

1. Set up your development environment
2. Implement authentication endpoints first
3. Test with the Flutter app login flow
4. Gradually implement other features
5. Set up real-time features with WebSocket
6. Configure payment processing
7. Deploy to staging environment
8. Coordinate with the Flutter team for integration testing

Happy coding! 🚀
