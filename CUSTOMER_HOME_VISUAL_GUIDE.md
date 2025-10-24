# 🎨 Customer Home Screen - Visual Feature Guide

## 📱 Screen Layout Overview

```
┌─────────────────────────────────────────┐
│  ⬅  Good [morning/afternoon/evening]   │  ← Dynamic greeting
│      [User Name]                    🛒  │  ← Cart button (animated)
├─────────────────────────────────────────┤
│  📍 Delivering to                       │  ← Location card
│  📍 Current Location              ▼     │
├─────────────────────────────────────────┤
│  ┌───────────────────────────────────┐  │
│  │  🎉 50% OFF                       │  │  ← Promotional Banner
│  │  On your first order              │  │    (Auto-scrolling)
│  │  [Order Now]                      │  │
│  └───────────────────────────────────┘  │
│         ● ○ ○                           │  ← Page indicators
├─────────────────────────────────────────┤
│  ❤️ Favorites  📋 Orders  💳 Wallet  🎁 │  ← Quick Actions
├─────────────────────────────────────────┤
│  🔍 Search for restaurants, dishes...   │  ← Search bar
├─────────────────────────────────────────┤
│  Explore by Cuisine                     │  ← Section title
│  [🎁][🍛][🍕][🍛]                     │  ← Categories (horizontal)
├─────────────────────────────────────────┤
│  Popular Restaurants            View All│  ← Section header
│  ┌─────────────────────────────────┐    │
│  │ 🏪 [Image with gradient overlay] │    │
│  │ ⏰ 20-30 min     ⭐ Top Rated    │    │  ← Restaurant card
│  │ Restaurant Name                   │    │    with badges
│  │ ⭐ 4.9  (124 reviews)            │    │
│  │ 🍽️ Type • Food Type             │    │
│  └─────────────────────────────────┘    │
├─────────────────────────────────────────┤
│  Most Popular                   View All│
│  [Card 1] [Card 2] [Card 3] →          │  ← Horizontal scroll
├─────────────────────────────────────────┤
│  Recent Items                   View All│
│  ┌─────────────────────────────────┐    │
│  │ [Img] Item Name            🛒   │    │  ← Recent item
│  │       🍽️ Type • Cuisine        │    │    with cart icon
│  │       ⭐ 4.9 (124 reviews)      │    │
│  └─────────────────────────────────┘    │
└─────────────────────────────────────────┘
                                      ⬆️    ← Scroll to top FAB
```

---

## 🎯 Key Interactive Elements

### 1. **Promotional Banner Carousel**
```
┌─────────────────────────────────────────┐
│  ○ ○ ●                                   │  ← Decorative circles
│                                         ○│    (background)
│  50% OFF                                 │  ← Large bold title
│  On your first order                     │  ← Subtitle
│                                          │
│  [Order Now] ←── CTA Button (white)     │
│                                          │
└─────────────────────────────────────────┘
   ● ○ ○  ← Active page indicator
```

**Features:**
- Auto-scrolls every 3 seconds
- Smooth page transition animation
- Gradient background (Orange/Green/Red)
- Page indicators show active banner
- Decorative circles for depth

---

### 2. **Quick Action Buttons**
```
┌──────┐  ┌──────┐  ┌──────┐  ┌──────┐
│  ❤️  │  │  📋  │  │  💳  │  │  🎁  │
│      │  │      │  │      │  │      │
│ Fav. │  │Order │  │Wallet│  │Reward│
└──────┘  └──────┘  └──────┘  └──────┘
  Red      Orange    Green     Blue
```

**Design:**
- Color-coded backgrounds (10% opacity)
- Icon containers (20% opacity)
- Tap animation (scale effect)
- Equal width distribution

---

### 3. **Enhanced Restaurant Card**
```
┌─────────────────────────────────────────┐
│ ⏰ 20-30 min          ⭐ Top Rated   │  ← Badges overlay
│                                         │
│    [Restaurant Image]                   │  ← Image with gradient
│        ▒▒▒▒▒▒▒▒                         │    overlay at top/bottom
│                                         │
├─────────────────────────────────────────┤
│  Restaurant Name (Bold)                 │  ← Details section
│  ⭐ 4.9  (124 reviews)                  │    with proper padding
│  🍽️ Type • Food Type                   │
└─────────────────────────────────────────┘
```

**Smart Badges:**
- **"⭐ Top Rated"** - For ratings ≥ 4.8 (Green)
- **"🚀 Fast"** - For quick delivery (Orange)
- **"⏰ 20-30 min"** - Delivery time (White bg)

---

### 4. **Most Popular Card**
```
┌───────────────────────┐
│ ⭐ 4.9         │  ← Floating rating badge
│                       │
│   [Restaurant Image]  │  ← Card with gradient
│      ▒▒▒▒▒▒           │    at bottom
│                       │
├───────────────────────┤
│  Restaurant Name      │
│  🍽️ Type • Cuisine   │
└───────────────────────┘
```

**Features:**
- Fixed 240px width
- Floating star badge (top-right)
- Bottom gradient for text contrast
- Horizontal scrolling

---

### 5. **Recent Item Row**
```
┌───────────────────────────────────────┐
│  [Image]  Item Name              🛒   │  ← Add to cart
│           🍽️ Type • Food Type        │
│           ⭐ 4.9 (124 reviews)        │
└───────────────────────────────────────┘
```

**Features:**
- Modern card container
- 80x80 image with shadow
- Green rating badge
- Cart icon for quick add
- Better text hierarchy

---

## 🎨 Color Coding System

```
Primary (Orange)   - CTAs, Important actions, Brand elements
Secondary (Green)  - Ratings, Success states, Positive actions  
Error (Red)        - Urgent items, Warnings, Favorites
Info (Blue)        - Information, Help, Rewards
```

---

## 📊 Animation Timeline

```
Time    Element                     Animation Type
─────────────────────────────────────────────────────
0ms     Header                      Fade In
50ms    Location Card               Slide In (up)
150ms   Banner Carousel             Slide In (up)
200ms   Quick Actions               Scale In
200ms   Search Bar                  Scale In
250ms   Categories Title            Fade In
300ms   Category Items              Stagger Scale
400ms   Popular Restaurants Title   Slide In
500ms   Restaurant Card 1           Slide In (left)
600ms   Restaurant Card 2           Slide In (left)
700ms   Restaurant Card 3           Slide In (left)
800ms   Most Popular Title          Fade In
```

---

## 🔄 Interactive States

### Pull-to-Refresh:
```
┌─────────────────────┐
│         ↓           │  1. Pull down gesture
│      Loading...     │  2. Show spinner (2s)
│         ↓           │  3. Refresh data
└─────────────────────┘  4. Reset scroll
```

### Scroll-to-Top FAB:
```
Scroll Position    FAB State
─────────────────────────────
< 400px            Hidden
≥ 400px            Visible (scale in)
                   
On Tap:            Smooth scroll to top (800ms)
```

---

## 📐 Spacing & Sizing Reference

```
Element              Size           Spacing
──────────────────────────────────────────────
Screen Padding       24px           -
Section Spacing      32px           Between sections
Card Padding         16-24px        Inside cards
Icon Size (Small)    20px           -
Icon Size (Medium)   24px           Quick actions
Icon Size (Large)    32px           Featured
Button Height        44-56px        Touch target
Card Elevation       2-4dp          Subtle to Medium
Border Radius        12-20px        Modern rounded
```

---

## ✨ Micro-interactions

1. **Category Tap**: Scale down (0.95) → Scale up (1.0)
2. **Banner Auto-scroll**: Cubic bezier smooth transition
3. **Quick Action**: Scale pulse on load
4. **Card Hover** (web): Elevation increase
5. **Search Focus**: Border color change
6. **FAB Appear**: Scale from 0 to 1 with fade
7. **Pull Indicator**: Rotate and scale

---

## 🎯 User Flow Examples

### Finding Food:
```
1. View Banner → See 50% OFF deal
2. Tap Quick Action "Favorites" → Quick access
3. Search Bar → Type cuisine
4. Browse Categories → Tap Italian
5. Scroll Popular → See ratings & badges
6. Tap Restaurant → View menu
```

### Reordering:
```
1. Quick Action "Orders" → Past orders
2. Recent Items → See previous order
3. Tap item → Add to cart (🛒 icon)
4. Cart button → Checkout
```

### Exploring:
```
1. Scroll down → See all sections
2. Scroll back up → FAB appears
3. Tap FAB → Smooth return to top
4. Pull down → Refresh content
```

---

## 🔧 Technical Notes

### Performance:
- Shimmer loading for async operations
- Image caching with AssetImage
- Smooth 60fps animations
- Efficient list builders (lazy loading)

### Accessibility:
- Minimum touch targets: 44x44 points
- Color contrast: WCAG AAA compliant
- Semantic labels on all interactive elements
- Screen reader compatible

### Responsive:
- Works on all screen sizes
- Adaptive spacing based on screen width
- Horizontal scrolling for constrained width
- Safe area handling for notched devices

---

## 📈 Success Indicators

**Visual Engagement:**
✅ Increased time on home screen  
✅ More category exploration  
✅ Higher promo click-through rate  

**User Actions:**
✅ Quick action usage  
✅ Search bar utilization  
✅ Restaurant card taps  

**Satisfaction:**
✅ Reduced bounce rate  
✅ Higher app ratings  
✅ Positive user feedback  

---

**Note**: This guide shows the visual structure and interactions. Actual screenshots would be taken when running the app in a Flutter environment.
