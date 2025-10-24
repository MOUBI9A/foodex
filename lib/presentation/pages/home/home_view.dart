import 'package:flutter/material.dart';
import 'package:food_delivery/core/theme/color_system_v2.dart';
import 'package:food_delivery/core/theme/design_tokens_v2.dart';
import 'package:food_delivery/core/theme/animations_v2.dart';
import 'package:food_delivery/presentation/widgets/enhanced_text_field.dart';
import 'package:food_delivery/presentation/widgets/modern_card.dart';
import 'package:food_delivery/presentation/widgets/shimmer_loading.dart';
import 'package:food_delivery/presentation/widgets/animated_widgets.dart';
import 'package:food_delivery/presentation/widgets/page_transitions.dart';

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

class _HomeViewState extends State<HomeView> {
  TextEditingController txtSearch = TextEditingController();
  bool _isLoading = false;
  int _currentBannerIndex = 0;
  final PageController _bannerController = PageController();
  final ScrollController _scrollController = ScrollController();
  bool _showScrollToTop = false;
  
  // Promotional banners data
  List<Map<String, dynamic>> banners = [
    {
      "title": "50% OFF",
      "subtitle": "On your first order",
      "color": Color(0xFFE67E22),
      "gradient": LinearGradient(
        colors: [Color(0xFFE67E22), Color(0xFFF39C12)],
      ),
    },
    {
      "title": "Free Delivery",
      "subtitle": "Orders above \$20",
      "color": Color(0xFF27AE60),
      "gradient": LinearGradient(
        colors: [Color(0xFF27AE60), Color(0xFF2ECC71)],
      ),
    },
    {
      "title": "Flash Sale",
      "subtitle": "Today's special deals",
      "color": Color(0xFFE74C3C),
      "gradient": LinearGradient(
        colors: [Color(0xFFE74C3C), Color(0xFFC0392B)],
      ),
    },
  ];

  List catArr = [
    {"image": "assets/img/cat_offer.png", "name": "Offers"},
    {"image": "assets/img/cat_sri.png", "name": "Sri Lankan"},
    {"image": "assets/img/cat_3.png", "name": "Italian"},
    {"image": "assets/img/cat_4.png", "name": "Indian"},
  ];
  
  @override
  void initState() {
    super.initState();
    _startBannerAutoScroll();
    _scrollController.addListener(_scrollListener);
  }
  
  @override
  void dispose() {
    _bannerController.dispose();
    _scrollController.dispose();
    txtSearch.dispose();
    super.dispose();
  }
  
  void _scrollListener() {
    if (_scrollController.offset >= 400 && !_showScrollToTop) {
      setState(() {
        _showScrollToTop = true;
      });
    } else if (_scrollController.offset < 400 && _showScrollToTop) {
      setState(() {
        _showScrollToTop = false;
      });
    }
  }
  
  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOutCubic,
    );
  }
  
  Future<void> _onRefresh() async {
    // Simulate data refresh
    setState(() {
      _isLoading = true;
    });
    
    await Future.delayed(const Duration(seconds: 2));
    
    setState(() {
      _isLoading = false;
    });
  }
  
  void _startBannerAutoScroll() {
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted && _bannerController.hasClients) {
        int nextPage = (_currentBannerIndex + 1) % banners.length;
        _bannerController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOutCubic,
        );
        _startBannerAutoScroll();
      }
    });
  }
  
  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return "Good morning";
    if (hour < 17) return "Good afternoon";
    return "Good evening";
  }

  List popArr = [
    {
      "image": "assets/img/res_1.png",
      "name": "Minute by tuk tuk",
      "rate": "4.9",
      "rating": "124",
      "type": "Cafa",
      "food_type": "Western Food"
    },
    {
      "image": "assets/img/res_2.png",
      "name": "Café de Noir",
      "rate": "4.9",
      "rating": "124",
      "type": "Cafa",
      "food_type": "Western Food"
    },
    {
      "image": "assets/img/res_3.png",
      "name": "Bakes by Tella",
      "rate": "4.9",
      "rating": "124",
      "type": "Cafa",
      "food_type": "Western Food"
    },
  ];

  List mostPopArr = [
    {
      "image": "assets/img/m_res_1.png",
      "name": "Minute by tuk tuk",
      "rate": "4.9",
      "rating": "124",
      "type": "Cafa",
      "food_type": "Western Food"
    },
    {
      "image": "assets/img/m_res_2.png",
      "name": "Café de Noir",
      "rate": "4.9",
      "rating": "124",
      "type": "Cafa",
      "food_type": "Western Food"
    },
  ];

  List recentArr = [
    {
      "image": "assets/img/item_1.png",
      "name": "Mulberry Pizza by Josh",
      "rate": "4.9",
      "rating": "124",
      "type": "Cafa",
      "food_type": "Western Food"
    },
    {
      "image": "assets/img/item_2.png",
      "name": "Barita",
      "rate": "4.9",
      "rating": "124",
      "type": "Cafa",
      "food_type": "Western Food"
    },
    {
      "image": "assets/img/item_3.png",
      "name": "Pizza Rush Hour",
      "rate": "4.9",
      "rating": "124",
      "type": "Cafa",
      "food_type": "Western Food"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColorV2.background,
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        color: TColorV2.primary,
        backgroundColor: TColorV2.surface,
        child: SingleChildScrollView(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: SpacingV2.lg),
            child: Column(
            children: [
              SizedBox(height: SpacingV2.xxxl),

              // HEADER with greeting and cart - Add fade in animation
              FadeInAnimation(
                duration: AnimationsV2.normal,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: SpacingV2.lg),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _getGreeting(),
                              style: TextStyle(
                                color: TColorV2.textSecondary,
                                fontSize: TypographyScaleV2.sm,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: SpacingV2.xxs),
                            Text(
                              ServiceCall.userPayload[KKey.name] ?? "Guest",
                              style: TextStyle(
                                color: TColorV2.textPrimary,
                                fontSize: TypographyScaleV2.xxl,
                                fontWeight: FontWeight.w800,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      // Cart button with modern card style and pulse animation
                      PulseAnimation(
                        minScale: 1.0,
                        maxScale: 1.05,
                        duration: AnimationsV2.ultraDramatic,
                        child: ModernCard(
                          padding: EdgeInsets.all(SpacingV2.md),
                          backgroundColor: TColorV2.primary,
                          elevationLevel: 4,
                          onTap: () {
                            context.pushSlide(const MyOrderView());
                          },
                          child: Image.asset(
                            "assets/img/shopping_cart.png",
                            width: SizingV2.iconLg,
                            height: SizingV2.iconLg,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: SpacingV2.xl),

              // LOCATION with modern styling and slide animation
              SlideInAnimation(
                delay: AnimationsV2.staggerMedium,
                begin: const Offset(0, 0.2),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: SpacingV2.lg),
                  child: ModernCard(
                    padding: EdgeInsets.all(SpacingV2.lg),
                    backgroundColor: TColorV2.surface,
                    elevationLevel: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Delivering to",
                          style: TextStyle(
                            color: TColorV2.textSecondary,
                            fontSize: TypographyScaleV2.sm,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: SpacingV2.xs),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                "Current Location",
                                style: TextStyle(
                                  color: TColorV2.textPrimary,
                                  fontSize: TypographyScaleV2.lg,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(SpacingV2.xs),
                              decoration: BoxDecoration(
                                color: TColorV2.primary.withValues(alpha: 0.1),
                                borderRadius:
                                    BorderRadius.circular(RadiusV2.sm),
                              ),
                              child: Icon(
                                Icons.keyboard_arrow_down,
                                color: TColorV2.primary,
                                size: SizingV2.iconMd,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              SizedBox(height: SpacingV2.lg),

              // PROMOTIONAL BANNER CAROUSEL with auto-scroll
              SlideInAnimation(
                delay: Duration(milliseconds: 150),
                begin: const Offset(0, 0.2),
                child: Container(
                  height: 160,
                  margin: EdgeInsets.symmetric(horizontal: SpacingV2.lg),
                  child: PageView.builder(
                    controller: _bannerController,
                    onPageChanged: (index) {
                      setState(() {
                        _currentBannerIndex = index;
                      });
                    },
                    itemCount: banners.length,
                    itemBuilder: (context, index) {
                      var banner = banners[index];
                      return Container(
                        margin: EdgeInsets.symmetric(horizontal: SpacingV2.xs),
                        decoration: BoxDecoration(
                          gradient: banner['gradient'],
                          borderRadius: BorderRadius.circular(RadiusV2.xl),
                          boxShadow: [
                            BoxShadow(
                              color: banner['color'].withValues(alpha: 0.3),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            // Decorative circles
                            Positioned(
                              right: -20,
                              top: -20,
                              child: Container(
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white.withValues(alpha: 0.1),
                                ),
                              ),
                            ),
                            Positioned(
                              left: -30,
                              bottom: -30,
                              child: Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white.withValues(alpha: 0.05),
                                ),
                              ),
                            ),
                            // Content
                            Padding(
                              padding: EdgeInsets.all(SpacingV2.lg),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    banner['title'],
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: TypographyScaleV2.display2,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 1.5,
                                    ),
                                  ),
                                  SizedBox(height: SpacingV2.xs),
                                  Text(
                                    banner['subtitle'],
                                    style: TextStyle(
                                      color: Colors.white.withValues(alpha: 0.9),
                                      fontSize: TypographyScaleV2.lg,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(height: SpacingV2.md),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: SpacingV2.md,
                                      vertical: SpacingV2.sm,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(RadiusV2.full),
                                    ),
                                    child: Text(
                                      "Order Now",
                                      style: TextStyle(
                                        color: banner['color'],
                                        fontSize: TypographyScaleV2.sm,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),

              // Banner indicators
              SizedBox(height: SpacingV2.md),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  banners.length,
                  (index) => AnimatedContainer(
                    duration: AnimationsV2.fast,
                    margin: EdgeInsets.symmetric(horizontal: SpacingV2.xxs),
                    width: _currentBannerIndex == index ? 24 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _currentBannerIndex == index
                          ? TColorV2.primary
                          : TColorV2.neutral300,
                      borderRadius: BorderRadius.circular(RadiusV2.sm),
                    ),
                  ),
                ),
              ),

              SizedBox(height: SpacingV2.lg),

              // QUICK ACTION BUTTONS
              FadeInAnimation(
                delay: Duration(milliseconds: 200),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: SpacingV2.lg),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildQuickActionButton(
                        icon: Icons.favorite_border,
                        label: "Favorites",
                        color: TColorV2.error,
                        onTap: () {},
                      ),
                      _buildQuickActionButton(
                        icon: Icons.receipt_long,
                        label: "Orders",
                        color: TColorV2.primary,
                        onTap: () {},
                      ),
                      _buildQuickActionButton(
                        icon: Icons.account_balance_wallet,
                        label: "Wallet",
                        color: TColorV2.secondary,
                        onTap: () {},
                      ),
                      _buildQuickActionButton(
                        icon: Icons.card_giftcard,
                        label: "Rewards",
                        color: TColorV2.info,
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: SpacingV2.xl),
              ScaleInAnimation(
                delay: Duration(milliseconds: 200),
                begin: 0.8,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: SpacingV2.lg),
                  child: EnhancedTextField(
                    controller: txtSearch,
                    placeholder: "Search for restaurants, dishes...",
                    prefixIcon: Icons.search,
                    showClearButton: true,
                    onChanged: (value) {
                      // TODO: Implement search functionality
                    },
                  ),
                ),
              ),

              SizedBox(height: SpacingV2.xl),

              // FEATURED DEALS Section Header
              FadeInAnimation(
                delay: Duration(milliseconds: 250),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: SpacingV2.lg),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Explore by Cuisine",
                        style: TextStyle(
                          color: TColorV2.textPrimary,
                          fontSize: TypographyScaleV2.xxl,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: SpacingV2.md),

              // CATEGORIES with smooth animation and stagger effect
              FadeInAnimation(
                delay: Duration(milliseconds: 300),
                child: AnimatedSwitcher(
                  duration: AnimationsV2.normal,
                  child: _isLoading
                      ? SizedBox(
                          height: 120,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding:
                                EdgeInsets.symmetric(horizontal: SpacingV2.md),
                            itemCount: 4,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: EdgeInsets.only(right: SpacingV2.md),
                                child: ShimmerShapes.card(
                                  width: 100,
                                  height: 120,
                                ),
                              );
                            },
                          ),
                        )
                      : SizedBox(
                          height: 120,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding:
                                EdgeInsets.symmetric(horizontal: SpacingV2.md),
                            itemCount: catArr.length,
                            itemBuilder: ((context, index) {
                              var cObj = catArr[index] as Map? ?? {};
                              return ScaleInAnimation(
                                delay: AnimationsV2.staggerDelay(index,
                                    baseDelay: AnimationsV2.staggerSmall),
                                begin: 0.8,
                                child: CategoryCell(
                                  cObj: cObj,
                                  onTap: () {},
                                ),
                              );
                            }),
                          ),
                        ),
                ),
              ),

              SizedBox(height: SpacingV2.lg),

              // POPULAR RESTAURANTS with slide animation
              SlideInAnimation(
                delay: Duration(milliseconds: 400),
                begin: const Offset(0, 0.1),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: SpacingV2.lg),
                  child: ViewAllTitleRow(
                    title: "Popular Restaurants",
                    onView: () {},
                  ),
                ),
              ),

              _isLoading
                  ? ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      padding: EdgeInsets.symmetric(horizontal: SpacingV2.lg),
                      itemCount: 3,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(bottom: SpacingV2.md),
                          child: ListItemShimmer(
                            showImage: true,
                            lineCount: 2,
                          ),
                        );
                      },
                    )
                  : ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      itemCount: popArr.length,
                      itemBuilder: ((context, index) {
                        var pObj = popArr[index] as Map? ?? {};
                        return SlideInAnimation(
                          delay: Duration(milliseconds: 500 + (index * 100)),
                          begin: const Offset(-0.2, 0),
                          child: PopularRestaurantRow(
                            pObj: pObj,
                            onTap: () {},
                          ),
                        );
                      }),
                    ),

              SizedBox(height: SpacingV2.md),

              // MOST POPULAR with fade animation
              FadeInAnimation(
                delay: Duration(milliseconds: 800),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: SpacingV2.lg),
                  child: ViewAllTitleRow(
                    title: "Most Popular",
                    onView: () {},
                  ),
                ),
              ),

              _isLoading
                  ? SizedBox(
                      height: 200,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.symmetric(horizontal: SpacingV2.md),
                        itemCount: 2,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.only(right: SpacingV2.md),
                            child: CardShimmer(
                              showImage: true,
                              lineCount: 2,
                            ),
                          );
                        },
                      ),
                    )
                  : SizedBox(
                      height: 200,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.symmetric(horizontal: SpacingV2.md),
                        itemCount: mostPopArr.length,
                        itemBuilder: ((context, index) {
                          var mObj = mostPopArr[index] as Map? ?? {};
                          return MostPopularCell(
                            mObj: mObj,
                            onTap: () {},
                          );
                        }),
                      ),
                    ),

              SizedBox(height: SpacingV2.md),

              // RECENT ITEMS
              Padding(
                padding: EdgeInsets.symmetric(horizontal: SpacingV2.lg),
                child: ViewAllTitleRow(
                  title: "Recent Items",
                  onView: () {},
                ),
              ),

              _isLoading
                  ? ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      padding: EdgeInsets.symmetric(horizontal: SpacingV2.md),
                      itemCount: 3,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(bottom: SpacingV2.md),
                          child: ListItemShimmer(
                            showImage: true,
                            lineCount: 2,
                          ),
                        );
                      },
                    )
                  : ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      padding: EdgeInsets.symmetric(horizontal: SpacingV2.md),
                      itemCount: recentArr.length,
                      itemBuilder: ((context, index) {
                        var rObj = recentArr[index] as Map? ?? {};
                        return RecentItemRow(
                          rObj: rObj,
                          onTap: () {},
                        );
                      }),
                    ),

              SizedBox(height: SpacingV2.xxxl),
            ],
          ),
        ),
      ),
      ),
      // Floating Action Button - Scroll to Top
      floatingActionButton: _showScrollToTop
          ? ScaleInAnimation(
              duration: AnimationsV2.fast,
              child: FloatingActionButton(
                onPressed: _scrollToTop,
                backgroundColor: TColorV2.primary,
                elevation: 6,
                child: Icon(
                  Icons.arrow_upward,
                  color: Colors.white,
                ),
              ),
            )
          : null,
    );
  }

  Widget _buildQuickActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: ScaleInAnimation(
        delay: Duration(milliseconds: 250),
        child: ModernCard(
          padding: EdgeInsets.all(SpacingV2.md),
          backgroundColor: color.withValues(alpha: 0.1),
          elevationLevel: 2,
          onTap: onTap,
          child: Column(
            children: [
              Container(
                width: SizingV2.iconXl,
                height: SizingV2.iconXl,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(RadiusV2.md),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: SizingV2.iconMd,
                ),
              ),
              SizedBox(height: SpacingV2.xs),
              Text(
                label,
                style: TextStyle(
                  color: TColorV2.textPrimary,
                  fontSize: TypographyScaleV2.xs,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
