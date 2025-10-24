import 'package:flutter/material.dart';
import 'package:food_delivery/core/theme/color_system_v2.dart';
import 'package:food_delivery/core/theme/design_tokens_v2.dart';
import 'package:food_delivery/core/theme/animations_v2.dart';
import 'package:food_delivery/presentation/widgets/animated_widgets.dart';
import 'package:food_delivery/presentation/widgets/modern_button.dart';
import 'package:food_delivery/presentation/widgets/page_transitions.dart';

/// Animation Demo Screen
///
/// Showcases all available animations and effects in the FoodEx app.
/// Use this screen to test and demonstrate the animation system.
class AnimationDemoView extends StatefulWidget {
  const AnimationDemoView({super.key});

  @override
  State<AnimationDemoView> createState() => _AnimationDemoViewState();
}

class _AnimationDemoViewState extends State<AnimationDemoView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColorV2.background,
      appBar: AppBar(
        title: const Text('Animation Showcase'),
        backgroundColor: TColorV2.primary,
        foregroundColor: TColorV2.textInverse,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(SpacingV2.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section 1: Fade Animations
            _buildSectionTitle('Fade Animations'),
            FadeInAnimation(
              duration: AnimationsV2.normal,
              child: _buildDemoCard('Fade In Animation', TColorV2.primary),
            ),
            SizedBox(height: SpacingV2.lg),

            // Section 2: Scale Animations
            _buildSectionTitle('Scale Animations'),
            ScaleInAnimation(
              duration: AnimationsV2.fast,
              curve: AnimationsV2.overshoot,
              child: _buildDemoCard('Scale with Overshoot', TColorV2.secondary),
            ),
            SizedBox(height: SpacingV2.lg),

            // Section 3: Slide Animations
            _buildSectionTitle('Slide Animations'),
            SlideInAnimation(
              begin: const Offset(0, 0.3),
              child: _buildDemoCard('Slide from Bottom', TColorV2.accent),
            ),
            SizedBox(height: SpacingV2.lg),

            // Section 4: Bounce Animation
            _buildSectionTitle('Bounce Animation'),
            BounceAnimation(
              child: _buildDemoCard('Bouncing Card', TColorV2.success),
            ),
            SizedBox(height: SpacingV2.lg),

            // Section 5: Pulse Animation
            _buildSectionTitle('Pulse Animation'),
            PulseAnimation(
              minScale: 1.0,
              maxScale: 1.05,
              child: _buildDemoCard('Pulsing Card', TColorV2.warning),
            ),
            SizedBox(height: SpacingV2.lg),

            // Section 6: Floating Animation
            _buildSectionTitle('Floating Animation'),
            FloatingAnimation(
              offset: 10.0,
              child: _buildDemoCard('Floating Card', TColorV2.info),
            ),
            SizedBox(height: SpacingV2.lg),

            // Section 7: Glowing Effect
            _buildSectionTitle('Glowing Effect'),
            GlowingEffect(
              color: TColorV2.primary,
              child: _buildDemoCard('Glowing Card', TColorV2.primary),
            ),
            SizedBox(height: SpacingV2.lg),

            // Section 8: Staggered List
            _buildSectionTitle('Staggered List Animation'),
            StaggeredListAnimation(
              staggerDelay: AnimationsV2.staggerMedium,
              children: [
                _buildDemoCard('Item 1', TColorV2.primary),
                SizedBox(height: SpacingV2.sm),
                _buildDemoCard('Item 2', TColorV2.secondary),
                SizedBox(height: SpacingV2.sm),
                _buildDemoCard('Item 3', TColorV2.accent),
              ],
            ),
            SizedBox(height: SpacingV2.lg),

            // Section 9: Modern Buttons
            _buildSectionTitle('Enhanced Buttons'),
            ModernButton(
              text: 'Primary Button',
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Button Pressed!')),
                );
              },
              variant: ButtonVariant.primary,
              size: ButtonSize.large,
              fullWidth: true,
              enableRipple: true,
              enableShine: true,
            ),
            SizedBox(height: SpacingV2.md),
            ModernButton(
              text: 'Secondary Button',
              onPressed: () {},
              variant: ButtonVariant.secondary,
              size: ButtonSize.large,
              fullWidth: true,
            ),
            SizedBox(height: SpacingV2.md),
            ModernButton(
              text: 'Loading Button',
              onPressed: () {},
              variant: ButtonVariant.primary,
              size: ButtonSize.large,
              fullWidth: true,
              isLoading: true,
            ),
            SizedBox(height: SpacingV2.lg),

            // Section 10: Page Transitions
            _buildSectionTitle('Page Transitions'),
            Wrap(
              spacing: SpacingV2.sm,
              runSpacing: SpacingV2.sm,
              children: [
                _buildTransitionButton(
                    'Fade', () => context.pushFade(_demoPage())),
                _buildTransitionButton(
                    'Slide', () => context.pushSlide(_demoPage())),
                _buildTransitionButton(
                    'Zoom', () => context.pushZoom(_demoPage())),
                _buildTransitionButton(
                    'Bounce', () => context.pushBounce(_demoPage())),
                _buildTransitionButton(
                    'Scale+Fade', () => context.pushScaleFade(_demoPage())),
              ],
            ),
            SizedBox(height: SpacingV2.xxxl),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: SpacingV2.md),
      child: Text(
        title,
        style: TextStyle(
          fontSize: TypographyScaleV2.xl,
          fontWeight: FontWeight.w700,
          color: TColorV2.textPrimary,
        ),
      ),
    );
  }

  Widget _buildDemoCard(String text, Color color) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(SpacingV2.lg),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(RadiusV2.md),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: TypographyScaleV2.lg,
          fontWeight: FontWeight.w600,
          color: TColorV2.textInverse,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildTransitionButton(String label, VoidCallback onPressed) {
    return ModernButton(
      text: label,
      onPressed: onPressed,
      variant: ButtonVariant.secondary,
      size: ButtonSize.small,
    );
  }

  Widget _demoPage() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Demo Page'),
        backgroundColor: TColorV2.primary,
        foregroundColor: TColorV2.textInverse,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FadeInAnimation(
              child: Icon(
                Icons.check_circle,
                size: 100,
                color: TColorV2.success,
              ),
            ),
            SizedBox(height: SpacingV2.lg),
            Text(
              'Page Transition Success!',
              style: TextStyle(
                fontSize: TypographyScaleV2.xxl,
                fontWeight: FontWeight.w700,
                color: TColorV2.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
