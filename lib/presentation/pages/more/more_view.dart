import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:food_delivery/presentation/pages/more/about_us_view.dart';
import 'package:food_delivery/presentation/pages/more/inbox_view.dart';
import 'package:food_delivery/presentation/pages/more/payment_details_view.dart';
import 'package:food_delivery/core/constants/routes.dart';

import 'package:food_delivery/core/theme/color_extension.dart';
import 'my_order_view.dart';
import 'notification_view.dart';

class MoreView extends StatelessWidget {
  const MoreView({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> moreArr = [
      {
        "name": "Payment Details",
        "image": "assets/images/more_payment.png",
        "onTap": () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const PaymentDetailsView()),
        ),
      },
      {
        "name": "My Orders",
        "image": "assets/images/more_my_order.png",
        "onTap": () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const MyOrderView()),
        ),
      },
      {
        "name": "Notifications",
        "image": "assets/images/more_notification.png",
        "base": 15,
        "onTap": () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const NotificationsView()),
        ),
      },
      {
        "name": "Inbox",
        "image": "assets/images/more_inbox.png",
        "onTap": () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const InboxView()),
        ),
      },
      {
        "name": "About Us",
        "image": "assets/images/more_info.png",
        "onTap": () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AboutUsView()),
        ),
      },
      {
        "name": "Taste Profile",
        "image": "assets/images/more_info.png",
        "onTap": () => context.push(AppRouteNames.customerTasteProfile),
      },
      {
        "name": "Recommendations",
        "image": "assets/images/more_info.png",
        "onTap": () => context.push(AppRouteNames.customerRecommendations),
      },
      {
        "name": "Suivi en direct",
        "image": "assets/images/more_info.png",
        "onTap": () => context.push(AppRouteNames.customerOrderTracking),
      },
    ];

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 46,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "More",
                      style: TextStyle(
                          color: TColor.primaryText,
                          fontSize: 20,
                          fontWeight: FontWeight.w800),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const MyOrderView()));
                      },
                      icon: Image.asset(
                        "assets/images/shopping_cart.png",
                        width: 25,
                        height: 25,
                      ),
                    ),
                  ],
                ),
              ),
              ListView.builder(
                  padding: EdgeInsets.zero,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: moreArr.length,
                  itemBuilder: (context, index) {
                    var mObj = moreArr[index];
                    var countBase = mObj["base"] as int? ?? 0;
                    return InkWell(
                      onTap: mObj["onTap"],
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 20),
                        child: Stack(
                          alignment: Alignment.centerRight,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 12),
                              decoration: BoxDecoration(
                                  color: TColor.textfield,
                                  borderRadius: BorderRadius.circular(5)),
                              margin: const EdgeInsets.only(right: 15),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 50,
                                    height: 50,
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                        color: TColor.placeholder,
                                        borderRadius:
                                            BorderRadius.circular(25)),
                                    alignment: Alignment.center,
                                    child: Image.asset(mObj["image"].toString(),
                                        width: 25,
                                        height: 25,
                                        fit: BoxFit.contain),
                                  ),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  Expanded(
                                    child: Text(
                                      mObj["name"].toString(),
                                      style: TextStyle(
                                          color: TColor.primaryText,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  if (countBase > 0)
                                    Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius:
                                              BorderRadius.circular(12.5)),
                                      alignment: Alignment.center,
                                      child: Text(
                                        countBase.toString(),
                                        style: TextStyle(
                                            color: TColor.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  color: TColor.textfield,
                                  borderRadius: BorderRadius.circular(15)),
                              child: Image.asset("assets/images/btn_next.png",
                                  width: 10,
                                  height: 10,
                                  color: TColor.primaryText),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
              const SizedBox(height: 120),
            ],
          ),
        ),
      ),
    );
  }
}
