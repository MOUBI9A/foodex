import 'package:flutter/material.dart';
import '../widgets/modern_button.dart';
import '../widgets/modern_card.dart';
import '../widgets/enhanced_text_field.dart';
import '../widgets/shimmer_loading.dart';
import '../../core/theme/color_system_v2.dart';
import '../../core/theme/design_tokens_v2.dart';

/// Design System V2 Showcase
///
/// This screen demonstrates all the new design components:
/// - ModernButton with variants and states
/// - ModernCard with hover effects
/// - EnhancedTextField with validation
/// - ShimmerLoading for loading states
class DesignShowcaseView extends StatefulWidget {
  const DesignShowcaseView({super.key});

  @override
  State<DesignShowcaseView> createState() => _DesignShowcaseViewState();
}

class _DesignShowcaseViewState extends State<DesignShowcaseView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _emailError;

  void _simulateLoading() {
    setState(() {
      _isLoading = true;
    });

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  void _validateEmail() {
    final email = _emailController.text;
    if (email.isEmpty) {
      setState(() {
        _emailError = 'Email is required';
      });
    } else if (!email.contains('@')) {
      setState(() {
        _emailError = 'Please enter a valid email';
      });
    } else {
      setState(() {
        _emailError = null;
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColorV2.background,
      appBar: AppBar(
        title: const Text('Design System V2 Showcase'),
        backgroundColor: TColorV2.primary,
        foregroundColor: TColorV2.textInverse,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(SpacingV2.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // SECTION: Buttons
            _buildSectionTitle('Buttons'),
            SizedBox(height: SpacingV2.md),

            // Primary buttons
            ModernButton(
              text: 'Primary Button',
              onPressed: _simulateLoading,
              fullWidth: true,
            ),
            SizedBox(height: SpacingV2.md),

            ModernButton(
              text: 'Primary with Icon',
              leadingIcon: Icons.shopping_cart,
              onPressed: _simulateLoading,
              fullWidth: true,
            ),
            SizedBox(height: SpacingV2.md),

            ModernButton(
              text: 'Loading State',
              onPressed: () {},
              isLoading: _isLoading,
              fullWidth: true,
            ),
            SizedBox(height: SpacingV2.md),

            // Secondary and other variants
            Row(
              children: [
                Expanded(
                  child: ModernButton(
                    text: 'Secondary',
                    variant: ButtonVariant.secondary,
                    onPressed: _simulateLoading,
                  ),
                ),
                SizedBox(width: SpacingV2.md),
                Expanded(
                  child: ModernButton(
                    text: 'Danger',
                    variant: ButtonVariant.danger,
                    leadingIcon: Icons.delete,
                    onPressed: _simulateLoading,
                  ),
                ),
              ],
            ),
            SizedBox(height: SpacingV2.md),

            ModernButton(
              text: 'Ghost Button',
              variant: ButtonVariant.ghost,
              onPressed: _simulateLoading,
              fullWidth: true,
            ),
            SizedBox(height: SpacingV2.md),

            // Different sizes
            Row(
              children: [
                ModernButton(
                  text: 'Small',
                  size: ButtonSize.small,
                  onPressed: _simulateLoading,
                ),
                SizedBox(width: SpacingV2.md),
                ModernButton(
                  text: 'Medium',
                  size: ButtonSize.medium,
                  onPressed: _simulateLoading,
                ),
                SizedBox(width: SpacingV2.md),
                ModernButton(
                  text: 'Large',
                  size: ButtonSize.large,
                  onPressed: _simulateLoading,
                ),
              ],
            ),

            SizedBox(height: SpacingV2.xl),

            // SECTION: Cards
            _buildSectionTitle('Cards'),
            SizedBox(height: SpacingV2.md),

            ModernCard(
              onTap: () {
                debugPrint('Card tapped');
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Basic Card',
                    style: TextStyle(
                      fontSize: TypographyScaleV2.lg,
                      fontWeight: FontWeight.w600,
                      color: TColorV2.textPrimary,
                    ),
                  ),
                  SizedBox(height: SpacingV2.sm),
                  Text(
                    'This is a basic card with hover effect and tap feedback.',
                    style: TextStyle(
                      fontSize: TypographyScaleV2.md,
                      color: TColorV2.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: SpacingV2.md),

            InfoCard(
              icon: Icons.restaurant,
              title: 'Info Card',
              subtitle: 'Card with icon and title',
              onTap: () {
                debugPrint('Info card tapped');
              },
            ),
            SizedBox(height: SpacingV2.md),

            InfoCard(
              icon: Icons.delivery_dining,
              title: 'Delivery Service',
              subtitle: 'Fast and reliable',
              iconColor: TColorV2.secondary,
              onTap: () {},
            ),

            SizedBox(height: SpacingV2.xl),

            // SECTION: Text Fields
            _buildSectionTitle('Text Fields'),
            SizedBox(height: SpacingV2.md),

            EnhancedTextField(
              controller: _emailController,
              label: 'Email',
              placeholder: 'Enter your email',
              prefixIcon: Icons.email,
              keyboardType: TextInputType.emailAddress,
              errorText: _emailError,
              onChanged: (value) {
                if (_emailError != null) {
                  _validateEmail();
                }
              },
            ),
            SizedBox(height: SpacingV2.md),

            EnhancedTextField(
              controller: _passwordController,
              label: 'Password',
              placeholder: 'Enter your password',
              prefixIcon: Icons.lock,
              obscureText: true,
              showPasswordToggle: true,
              helperText: 'At least 8 characters',
            ),
            SizedBox(height: SpacingV2.md),

            EnhancedTextField(
              label: 'Success State',
              placeholder: 'Email address',
              successText: 'Email is available!',
              prefixIcon: Icons.check_circle,
            ),
            SizedBox(height: SpacingV2.md),

            EnhancedTextField(
              label: 'With Character Count',
              placeholder: 'Enter bio',
              maxLength: 120,
              maxLines: 3,
              showCharacterCount: true,
              helperText: 'Tell us about yourself',
            ),

            SizedBox(height: SpacingV2.xl),

            // SECTION: Loading States
            _buildSectionTitle('Loading States (Shimmer)'),
            SizedBox(height: SpacingV2.md),

            // List shimmer
            ListItemShimmer(showAvatar: true),
            SizedBox(height: SpacingV2.md),
            ListItemShimmer(showImage: true),
            SizedBox(height: SpacingV2.md),

            // Card shimmer
            CardShimmer(showImage: true),
            SizedBox(height: SpacingV2.md),

            // Individual shapes
            Row(
              children: [
                ShimmerShapes.avatar(size: 60),
                SizedBox(width: SpacingV2.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShimmerShapes.text(width: double.infinity),
                      SizedBox(height: SpacingV2.sm),
                      ShimmerShapes.text(width: 200),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: SpacingV2.xl),

            // SECTION: Color System
            _buildSectionTitle('Color System'),
            SizedBox(height: SpacingV2.md),

            Wrap(
              spacing: SpacingV2.md,
              runSpacing: SpacingV2.md,
              children: [
                _buildColorChip('Primary', TColorV2.primary),
                _buildColorChip('Secondary', TColorV2.secondary),
                _buildColorChip('Accent', TColorV2.accent),
                _buildColorChip('Success', TColorV2.success),
                _buildColorChip('Warning', TColorV2.warning),
                _buildColorChip('Error', TColorV2.error),
                _buildColorChip('Info', TColorV2.info),
              ],
            ),

            SizedBox(height: SpacingV2.xxxl),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _simulateLoading,
        backgroundColor: TColorV2.primary,
        icon: const Icon(Icons.add),
        label: const Text('Create New'),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: TypographyScaleV2.xxl,
        fontWeight: FontWeight.bold,
        color: TColorV2.textPrimary,
      ),
    );
  }

  Widget _buildColorChip(String label, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: SpacingV2.md,
        vertical: SpacingV2.sm,
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(RadiusV2.chip),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: TypographyScaleV2.sm,
          fontWeight: FontWeight.w600,
          color: _isLightColor(color)
              ? TColorV2.textPrimary
              : TColorV2.textInverse,
        ),
      ),
    );
  }

  bool _isLightColor(Color color) {
    final luminance = color.computeLuminance();
    return luminance > 0.5;
  }
}
