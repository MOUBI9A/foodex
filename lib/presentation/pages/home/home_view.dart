import 'package:flutter/material.dart';
import 'package:food_delivery/core/theme/color_extension.dart';
import 'package:food_delivery/presentation/widgets/round_textfield.dart';
import 'package:food_delivery/presentation/widgets/modern_card.dart';

import 'package:food_delivery/core/constants/globs.dart';
import 'package:food_delivery/core/network/service_call.dart';
import 'package:food_delivery/presentation/widgets/category_cell.dart';
import 'package:food_delivery/presentation/widgets/most_popular_cell.dart';
import 'package:food_delivery/presentation/widgets/popular_resutaurant_row.dart';
import 'package:food_delivery/presentation/widgets/recent_item_row.dart';
import 'package:food_delivery/presentation/widgets/view_all_title_row.dart';
import '../more/my_order_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView>
    with SingleTickerProviderStateMixin {
  final TextEditingController txtSearch = TextEditingController();
  final FocusNode _searchFocus = FocusNode();
  int cartCount = 2;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    _animationController.forward();
    _searchFocus.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _searchFocus.dispose();
    _animationController.dispose();
    super.dispose();
  }

  List catArr = [
    {
      "image": "assets/images/dess_1.png",
      "name": "Slow Tagines",
      "count": 24,
      "featured": true
    },
    {
      "image": "assets/images/dess_2.png",
      "name": "Couscous Bowls",
      "count": 18,
      "featured": false
    },
    {
      "image": "assets/images/dess_3.png",
      "name": "Msemen & Breads",
      "count": 12,
      "featured": false
    },
    {
      "image": "assets/images/dess_4.png",
      "name": "Sweet Mint Treats",
      "count": 9,
      "featured": false
    },
  ];

  List popArr = [
    {
      "image": "assets/images/res_1.png",
      "name": "Dar Yasmine Kitchen",
      "rate": "4.9",
      "rating": "214",
      "type": "Family kitchen",
      "food_type": "Moroccan comfort"
    },
    {
      "image": "assets/images/res_2.png",
      "name": "Atelier Couscous",
      "rate": "4.8",
      "rating": "168",
      "type": "Home chef",
      "food_type": "Steam-cooked bowls"
    },
    {
      "image": "assets/images/res_3.png",
      "name": "Mamounia Table",
      "rate": "4.9",
      "rating": "189",
      "type": "Artisan baker",
      "food_type": "Wood-fired breads"
    },
  ];

  List mostPopArr = [
    {
      "image": "assets/images/m_res_1.png",
      "name": "Nour's Clay Tagine",
      "rate": "5.0",
      "rating": "98",
      "type": "slow-cooked",
      "food_type": "Preserved lemon • olives"
    },
    {
      "image": "assets/images/m_res_2.png",
      "name": "Grandma's Harira",
      "rate": "4.8",
      "rating": "120",
      "type": "supper soup",
      "food_type": "Hearty chickpeas"
    },
  ];

  List recentArr = [
    {
      "image": "assets/images/item_1.png",
      "name": "Neighborhood Rfissa",
      "rate": "4.9",
      "rating": "134",
      "type": "Saturday special",
      "food_type": "Fenugreek broth",
      "price": "95 MAD"
    },
    {
      "image": "assets/images/item_2.png",
      "name": "Bakehouse Msemen",
      "rate": "4.8",
      "rating": "201",
      "type": "Hand-folded",
      "food_type": "Honey & butter",
      "price": "42 MAD"
    },
    {
      "image": "assets/images/item_3.png",
      "name": "Berber Couscous",
      "rate": "4.9",
      "rating": "162",
      "type": "Family platter",
      "food_type": "Garden vegetables",
      "price": "80 MAD"
    },
  ];

  final List storyArr = [
    {
      "image": "assets/images/offer_1.png",
      "title": "Warm couscous steam",
      "subtitle": "Hand-rolled grains • organic carrots"
    },
    {
      "image": "assets/images/offer_2.png",
      "title": "Freshly baked msemen",
      "subtitle": "Buttery layers from Souad's griddle"
    },
    {
      "image": "assets/images/offer_3.png",
      "title": "Clay pot tagines",
      "subtitle": "Slow fire, preserved lemons, love"
    },
  ];

  final List familyStyleArr = [
    {
      "image": "assets/images/menu_1.png",
      "title": "Sunday Couscous Tray",
      "serves": "Serves 4-5",
      "time": "Ready in 45 min",
      "price": "120 MAD"
    },
    {
      "image": "assets/images/menu_2.png",
      "title": "Spiced Chickpea Bowl",
      "serves": "Serves 2",
      "time": "Ready in 25 min",
      "price": "72 MAD"
    },
    {
      "image": "assets/images/menu_3.png",
      "title": "Mint Tea + Pastry Set",
      "serves": "Perfect for 3",
      "time": "Brewed on demand",
      "price": "60 MAD"
    },
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 800;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: SingleChildScrollView(
            child: Column(
              children: [
                // ENHANCED HEADER with gradient and better visual hierarchy
                _buildEnhancedHeader(context, isDesktop),

                const SizedBox(height: 20),

                // LOCATION CARD with better design
                _buildLocationCard(context),

                const SizedBox(height: 24),

                // SEARCH BAR with better styling
                _buildEnhancedSearchBar(context),

                const SizedBox(height: 28),

                _buildStoryStrip(),

                const SizedBox(height: 28),

                // CATEGORIES with better spacing
                _buildCategoriesSection(context),

                const SizedBox(height: 32),

                // POPULAR RESTAURANTS with enhanced cards
                _buildPopularRestaurantsSection(context),

                const SizedBox(height: 28),

                // MOST POPULAR with better horizontal scroll
                _buildMostPopularSection(context),

                const SizedBox(height: 28),

                // RECENT ITEMS
                _buildRecentItemsSection(context),

                const SizedBox(height: 28),

                // FAMILY STYLE
                _buildFamilyStyleSection(context),

                // Extra padding for bottom navigation bar (70px height + 16px padding + extra space)
                const SizedBox(height: 120),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // PSYCHOLOGY: Personalized greeting creates emotional connection
  // MARKETING: Time-based greeting shows attention to detail
  Widget _buildEnhancedHeader(BuildContext context, bool isDesktop) {
    final hour = DateTime.now().hour;
    String greeting = "Good morning";
    IconData greetingIcon = Icons.wb_sunny;

    if (hour >= 12 && hour < 17) {
      greeting = "Good afternoon";
      greetingIcon = Icons.wb_sunny_outlined;
    } else if (hour >= 17) {
      greeting = "Good evening";
      greetingIcon = Icons.nights_stay;
    }

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            TColor.primary,
            TColor.primary.withOpacity(0.8),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: TColor.primary.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 18),
          child: Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 26,
                    backgroundColor: Colors.white.withOpacity(0.2),
                    child: Icon(
                      Icons.person,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          greeting,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.85),
                            fontSize: 13,
                          ),
                        ),
                        Row(
                          children: [
                            Icon(greetingIcon,
                                color: Colors.white, size: 18),
                            const SizedBox(width: 6),
                            Text(
                              ServiceCall.userPayload[KKey.name] ?? "Guest",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  _buildCartButton(context),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCartButton(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MyOrderView()),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.25),
                  blurRadius: 18,
                  offset: const Offset(0, 10),
                )
              ],
            ),
            child: Icon(
              Icons.shopping_bag_outlined,
              color: TColor.primary,
            ),
          ),
        ),
        if (cartCount > 0)
          Positioned(
            right: -2,
            top: -2,
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: const Color(0xFF27AE60),
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: Text(
                cartCount.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }

  // PSYCHOLOGY: Clarity reduces cognitive load
  // UX: Easy-to-tap, clear visual hierarchy
  Widget _buildLocationCard(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, 4),
              spreadRadius: 2,
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: TColor.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.location_on,
                color: TColor.primary,
                size: 24,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Delivering to",
                    style: TextStyle(
                      color: TColor.secondaryText.withOpacity(0.6),
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        "Current Location",
                        style: TextStyle(
                          color: TColor.primaryText,
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF3E0),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.explore, size: 14, color: TColor.primary),
                            const SizedBox(width: 4),
                            Text(
                              "Change",
                              style: TextStyle(
                                color: TColor.primary,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Icon(Icons.my_location, color: TColor.primary),
          ],
        ),
      ),
    );
  }

  // PSYCHOLOGY: Anticipation - search bar promises discovery
  // UX: Prominent, easy to focus
  Widget _buildEnhancedSearchBar(BuildContext context) {
    final hasFocus = _searchFocus.hasFocus;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: hasFocus
                  ? TColor.primary.withOpacity(0.25)
                  : Colors.black.withOpacity(0.05),
              blurRadius: hasFocus ? 24 : 12,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: Row(
          children: [
            Icon(Icons.search, color: TColor.primary),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                focusNode: _searchFocus,
                controller: txtSearch,
                decoration: const InputDecoration(
                  hintText: "Search for dishes, restaurants or chefs…",
                  border: InputBorder.none,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: TColor.primary.withOpacity(0.12),
                borderRadius: BorderRadius.circular(16),
              ),
              child: IconButton(
                icon: const Icon(Icons.tune_rounded, size: 20),
                color: TColor.primary,
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStoryStrip() {
    return SizedBox(
      height: 150,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: storyArr.length,
        itemBuilder: (context, index) {
          final story = storyArr[index];
          return Container(
            width: 250,
            margin: EdgeInsets.only(right: index == storyArr.length - 1 ? 0 : 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.18),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Stack(
                children: [
                  Image.asset(
                    story["image"].toString(),
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withOpacity(0.75),
                          Colors.transparent,
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          story["title"].toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          story["subtitle"].toString(),
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.85),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // PSYCHOLOGY: Visual variety increases engagement
  // MARKETING: Categories guide user journey
  Widget _buildCategoriesSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Container(
                width: 4,
                height: 24,
                decoration: BoxDecoration(
                  color: TColor.primary,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                "Explore Categories",
                style: TextStyle(
                  color: TColor.primaryText,
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            itemCount: catArr.length,
            itemBuilder: (context, index) {
              var cObj = catArr[index] as Map? ?? {};
              return TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: Duration(milliseconds: 400 + (index * 100)),
                curve: Curves.easeOutCubic,
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: value,
                    child: Opacity(
                      opacity: value,
                      child: child,
                    ),
                  );
                },
                child: CategoryCell(
                  cObj: cObj,
                  onTap: () {},
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // PSYCHOLOGY: Social proof (ratings) builds trust
  // MARKETING: "Popular" triggers FOMO (fear of missing out)
  Widget _buildPopularRestaurantsSection(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ViewAllTitleRow(
            title: "Popular Restaurants",
            onView: () {},
          ),
        ),
        const SizedBox(height: 16),
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          itemCount: popArr.length,
          itemBuilder: (context, index) {
            var pObj = popArr[index] as Map? ?? {};
            return TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: Duration(milliseconds: 500 + (index * 100)),
              curve: Curves.easeOutCubic,
              builder: (context, value, child) {
                return Transform.translate(
                  offset: Offset(30 * (1 - value), 0),
                  child: Opacity(
                    opacity: value,
                    child: child,
                  ),
                );
              },
              child: PopularRestaurantRow(
                pObj: pObj,
                onTap: () {},
              ),
            );
          },
        ),
      ],
    );
  }

  // PSYCHOLOGY: Scarcity principle - limited visible items create desire
  // UX: Horizontal scroll encourages exploration
  Widget _buildMostPopularSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Icon(
                Icons.star,
                color: Colors.amber[600],
                size: 26,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ViewAllTitleRow(
                  title: "Most Popular",
                  onView: () {},
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 260,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            itemCount: mostPopArr.length,
            itemBuilder: (context, index) {
              var mObj = mostPopArr[index] as Map? ?? {};
              return TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: Duration(milliseconds: 600 + (index * 100)),
                curve: Curves.easeOutCubic,
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: 0.8 + (0.2 * value),
                    child: Opacity(
                      opacity: value,
                      child: child,
                    ),
                  );
                },
                child: MostPopularCell(
                  mObj: mObj,
                  onTap: () {},
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // PSYCHOLOGY: Personalization - "Recent" suggests tailored experience
  // UX: Encourages repeat ordering
  Widget _buildRecentItemsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Icon(
                Icons.history,
                color: TColor.primary,
                size: 26,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ViewAllTitleRow(
                  title: "Recent Items",
                  onView: () {},
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(horizontal: 15),
          itemCount: recentArr.length,
          itemBuilder: (context, index) {
            var rObj = recentArr[index] as Map? ?? {};
            return TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: Duration(milliseconds: 700 + (index * 100)),
              curve: Curves.easeOutCubic,
              builder: (context, value, child) {
                return Transform.translate(
                  offset: Offset(-30 * (1 - value), 0),
                  child: Opacity(
                    opacity: value,
                    child: child,
                  ),
                );
              },
              child: RecentItemRow(
                rObj: rObj,
                onTap: () {},
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildFamilyStyleSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Icon(Icons.group, color: TColor.primary),
              const SizedBox(width: 8),
              Text(
                'Plateaux à partager',
                style: TextStyle(
                  color: TColor.primaryText,
                  fontWeight: FontWeight.w800,
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 240,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            scrollDirection: Axis.horizontal,
            itemCount: familyStyleArr.length,
            itemBuilder: (context, index) {
              final plan = familyStyleArr[index];
              return _FamilyStyleCard(plan: plan);
            },
          ),
        ),
      ],
    );
  }
}

class _FamilyStyleCard extends StatelessWidget {
  final Map plan;
  const _FamilyStyleCard({required this.plan});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(26)),
            child: Image.asset(
              plan["image"].toString(),
              height: 120,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  plan["title"].toString(),
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: TColor.primaryText,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  plan["serves"].toString(),
                  style: TextStyle(color: TColor.secondaryText, fontSize: 12),
                ),
                Text(
                  plan["time"].toString(),
                  style: TextStyle(color: TColor.secondaryText, fontSize: 12),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Text(
                      plan["price"].toString(),
                      style: TextStyle(
                        color: TColor.primary,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: TColor.primary,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                      ),
                      onPressed: () {},
                      child: const Text('Order Now'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
