# FoodEx Admin Dashboard

A modern, responsive admin dashboard for the FoodEx food delivery platform built with Flutter and Riverpod.

## 🌟 Features

### Dashboard Analytics
- **Real-time Metrics**: Total orders, revenue, active chefs, and couriers with growth indicators
- **Interactive Charts**: Weekly revenue visualization with multiple data views
- **Performance Tracking**: Monitor platform growth and trends
- **Order Management**: Visual breakdown of order statuses with donut chart

### Data Visualization
- **Revenue Chart**: Line chart showing weekly revenue, orders, and new users
- **Orders Donut Chart**: Visual distribution of pending, in-progress, delivered, and cancelled orders
- **Top Chefs Table**: Sortable table with pagination, showing chef performance metrics
- **Growth Indicators**: Trending arrows and percentages for all KPIs

### UI/UX
- **Dark/Light Theme**: Toggle between themes with smooth transitions
- **Responsive Design**: Optimized for desktop (4-col), tablet (2-col), and mobile (1-col)
- **Smooth Animations**: ElasticOut scale effects, number counters, hover states
- **Navigation**: Sidebar with 7 menu items (Desktop: Rail, Mobile: Drawer)

### Quick Actions
- Add New Chef
- View All Orders
- Export Reports
- Manage Users

## 📂 Structure

```
lib/features/admin/
├── common/theme/
│   └── admin_theme.dart                # Theme configuration
├── dashboard/
│   ├── data/
│   │   └── dashboard_metrics_provider.dart  # Riverpod providers
│   ├── widgets/
│   │   ├── metric_card.dart            # KPI cards
│   │   ├── revenue_chart.dart          # Line chart
│   │   ├── top_chefs_table.dart        # Data table
│   │   ├── orders_status_summary.dart  # Donut chart
│   │   ├── quick_actions_bar.dart      # Action buttons
│   │   └── app_sidebar.dart            # Navigation
│   └── dashboard_page.dart             # Main container
```

## 🎨 Design

### Color Palette
- **Primary**: FoodEx Orange (#F24E1E)
- **Success**: Green (#10B981)
- **Warning**: Yellow (#F59E0B)
- **Info**: Blue (#3B82F6)
- **Error**: Red (#EF4444)

### Typography
- **Font**: Poppins (Regular, Medium, SemiBold, Bold)
- **Sizes**: 12px - 32px

### Responsive Breakpoints
- **Mobile**: < 900px (1 column)
- **Tablet**: 900px - 1199px (2 columns)
- **Desktop**: ≥ 1200px (4 columns)

## 🚀 Getting Started

### Prerequisites
- Flutter 3.32.5 or higher
- Dart SDK
- flutter_riverpod
- fl_chart v0.69.0

### Installation

1. **Install dependencies**
   ```bash
   flutter pub get
   ```

2. **Run the app**
   ```bash
   # Web
   flutter run -d chrome
   
   # Desktop (macOS)
   flutter run -d macos
   
   # Desktop (Windows)
   flutter run -d windows
   
   # Desktop (Linux)
   flutter run -d linux
   ```

3. **Navigate to Dashboard**
   ```dart
   import 'package:food_delivery/features/admin/dashboard/dashboard_page.dart';
   
   // Use in your routing
   Navigator.push(
     context,
     MaterialPageRoute(builder: (context) => const DashboardPage()),
   );
   ```

## 📊 Components

### 1. Metric Cards
Displays key performance indicators with animated counters and growth trends.

```dart
MetricCard(
  label: 'Total Orders',
  value: '12,847',
  icon: Icons.shopping_bag,
  iconColor: AdminTheme.infoBlue,
  growthPercentage: 8.3,
)
```

### 2. Revenue Chart
Interactive line chart with three data view modes.

```dart
const RevenueChart()
```

### 3. Top Chefs Table
Sortable, paginated table showing chef performance.

```dart
const TopChefsTable()
```

### 4. Orders Status Summary
Donut chart showing order distribution by status.

```dart
const OrdersStatusSummary()
```

### 5. Quick Actions Bar
Row of primary action buttons.

```dart
const QuickActionsBar()
```

### 6. App Sidebar
Navigation menu (NavigationRail on desktop, Drawer on mobile).

```dart
AppSidebar(
  isMobile: false,
  selectedIndex: 0,
  onDestinationSelected: (index) {
    // Handle navigation
  },
)
```

## 🧪 Testing

### Run Widget Tests
```bash
flutter test test/widget/admin_dashboard_test.dart
```

### Run with Coverage
```bash
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

### Test Coverage
- **Metric Cards**: 4 test cases
- **Sidebar**: 6 test cases
- **Theme**: 2 test cases
- **Integration**: 1 test case

## 🎯 Mock Data

Currently using mock data for development. Replace with real API in production:

```dart
// Location: dashboard_metrics_provider.dart
DashboardMetrics _getMockDashboardData() {
  return DashboardMetrics(
    totalOrders: 12847,
    totalRevenue: 284950.50,
    // ... more mock data
  );
}
```

## 🔧 Customization

### Change Theme Colors
Edit `lib/features/admin/common/theme/admin_theme.dart`:

```dart
static const primaryOrange = Color(0xFFF24E1E);  // Your primary color
static const successGreen = Color(0xFF10B981);   // Your success color
// ... more colors
```

### Update Mock Data
Edit `lib/features/admin/dashboard/data/dashboard_metrics_provider.dart`:

```dart
DashboardMetrics _getMockDashboardData() {
  return DashboardMetrics(
    totalOrders: 15000,  // Your data
    // ... more fields
  );
}
```

### Add Navigation Items
Edit `lib/features/admin/dashboard/widgets/app_sidebar.dart`:

```dart
final List<NavigationItem> _navigationItems = [
  NavigationItem(
    icon: Icons.new_icon,
    activeIcon: Icons.new_icon_filled,
    label: 'New Section',
  ),
  // ... more items
];
```

## 📱 Screenshots

### Desktop View
- 4-column metric grid
- Full sidebar (280px NavigationRail)
- Two-column layout (table + chart)

### Tablet View
- 2-column metric grid
- Full sidebar
- Responsive charts

### Mobile View
- 1-column stack
- Hamburger menu → Drawer
- Compact layout

## 🌐 Browser Support

### Recommended
- Chrome 90+
- Edge 90+
- Safari 14+
- Firefox 88+

### Testing
```bash
# Chrome
flutter run -d chrome

# Edge
flutter run -d edge
```

## 🐛 Troubleshooting

### Issue: Charts not rendering
**Solution**: Ensure `fl_chart: ^0.69.0` is in `pubspec.yaml`

### Issue: Theme not applying
**Solution**: Wrap with `MaterialApp` and set theme:
```dart
MaterialApp(
  theme: AdminTheme.lightTheme,
  darkTheme: AdminTheme.darkTheme,
  themeMode: ThemeMode.light,
  // ...
)
```

### Issue: Sidebar not showing on mobile
**Solution**: Add GlobalKey to Scaffold:
```dart
final _scaffoldKey = GlobalKey<ScaffoldState>();

Scaffold(
  key: _scaffoldKey,
  drawer: AppSidebar(isMobile: true, ...),
  // ...
)
```

## 📝 Roadmap

### Phase 4.2: Navigation (Upcoming)
- [ ] GoRouter integration
- [ ] Users management page
- [ ] Chefs management page
- [ ] Orders management page
- [ ] Settings page

### Phase 4.3: API Integration (Future)
- [ ] Real-time data from backend
- [ ] WebSocket for live updates
- [ ] Authentication (Firebase/Supabase)
- [ ] Image uploads
- [ ] Export functionality

### Phase 4.4: Advanced Features (Future)
- [ ] Multi-language support
- [ ] Advanced charts (bar, heatmap)
- [ ] Notification system
- [ ] Role-based access control
- [ ] Audit logs

## 🤝 Contributing

This is part of the FoodEx platform. For contributions:

1. Follow Flutter/Dart style guide
2. Write widget tests for new components
3. Update documentation
4. Ensure zero compilation errors

## 📄 License

Part of the FoodEx food delivery platform.

## 📞 Support

For issues or questions about the admin dashboard, please refer to the main project documentation.

---

**Built with ❤️ using Flutter & Riverpod**

**Status**: ✅ Phase 4.1 Complete | 🚀 Ready for Phase 4.2
