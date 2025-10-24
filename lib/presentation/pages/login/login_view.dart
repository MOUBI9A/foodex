import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:food_delivery/core/routing/app_router.dart';
import 'package:food_delivery/core/theme/color_system_v2.dart';
import 'package:food_delivery/core/theme/design_tokens_v2.dart';
import 'package:food_delivery/core/utils/extensions.dart';
import 'package:food_delivery/core/constants/globs.dart';
import 'package:food_delivery/presentation/widgets/modern_button.dart';
import 'package:food_delivery/presentation/widgets/enhanced_text_field.dart';
import 'package:food_delivery/core/network/service_call.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtPassword = TextEditingController();
  bool _isLoading = false;
  String? _emailError;
  String? _passwordError;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColorV2.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(SpacingV2.xl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: SpacingV2.xxxl),

                // Logo or App Icon (optional)
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    gradient: TColorV2.primaryGradient,
                    borderRadius: BorderRadius.circular(RadiusV2.xl),
                  ),
                  child: Icon(
                    Icons.restaurant_menu,
                    size: SizingV2.iconXl,
                    color: TColorV2.textInverse,
                  ),
                ),

                SizedBox(height: SpacingV2.xl),

                // Title
                Text(
                  "Welcome Back",
                  style: TextStyle(
                    color: TColorV2.textPrimary,
                    fontSize: TypographyScaleV2.xxxl,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                SizedBox(height: SpacingV2.xs),

                // Subtitle
                Text(
                  "Sign in to continue to FoodEx",
                  style: TextStyle(
                    color: TColorV2.textSecondary,
                    fontSize: TypographyScaleV2.md,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                SizedBox(height: SpacingV2.xxxl),

                // Email Field
                EnhancedTextField(
                  controller: txtEmail,
                  label: "Email Address",
                  placeholder: "Enter your email",
                  prefixIcon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  errorText: _emailError,
                  onChanged: (value) {
                    if (_emailError != null) {
                      setState(() => _emailError = null);
                    }
                  },
                ),

                SizedBox(height: SpacingV2.lg),

                // Password Field
                EnhancedTextField(
                  controller: txtPassword,
                  label: "Password",
                  placeholder: "Enter your password",
                  prefixIcon: Icons.lock_outline,
                  obscureText: true,
                  showPasswordToggle: true,
                  errorText: _passwordError,
                  onChanged: (value) {
                    if (_passwordError != null) {
                      setState(() => _passwordError = null);
                    }
                  },
                ),

                SizedBox(height: SpacingV2.sm),

                // Forgot Password
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      context.go(AppRoutes.resetPassword);
                    },
                    child: Text(
                      "Forgot Password?",
                      style: TextStyle(
                        color: TColorV2.primary,
                        fontSize: TypographyScaleV2.sm,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: SpacingV2.lg),

                // Login Button
                ModernButton(
                  text: "Sign In",
                  onPressed: _isLoading ? null : () => btnLogin(),
                  isLoading: _isLoading,
                  fullWidth: true,
                  size: ButtonSize.large,
                ),

                SizedBox(height: SpacingV2.xl),

                // Divider with "or"
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: TColorV2.neutral300,
                        thickness: 1,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: SpacingV2.md),
                      child: Text(
                        "OR",
                        style: TextStyle(
                          color: TColorV2.textSecondary,
                          fontSize: TypographyScaleV2.sm,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: TColorV2.neutral300,
                        thickness: 1,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: SpacingV2.xl),

                // Social Login Buttons
                ModernButton(
                  text: "Continue with Facebook",
                  leadingIcon: Icons.facebook,
                  onPressed: () {},
                  variant: ButtonVariant.secondary,
                  fullWidth: true,
                ),

                SizedBox(height: SpacingV2.md),

                ModernButton(
                  text: "Continue with Google",
                  leadingIcon: Icons.g_mobiledata,
                  onPressed: () {},
                  variant: ButtonVariant.secondary,
                  fullWidth: true,
                ),

                SizedBox(height: SpacingV2.xxxl),

                // Sign Up Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: TextStyle(
                        color: TColorV2.textSecondary,
                        fontSize: TypographyScaleV2.md,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        context.go(AppRoutes.signUp);
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        "Sign Up",
                        style: TextStyle(
                          color: TColorV2.primary,
                          fontSize: TypographyScaleV2.md,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: SpacingV2.xl),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //TODO: Action
  void btnLogin() {
    // Clear previous errors
    setState(() {
      _emailError = null;
      _passwordError = null;
    });

    // Validate email
    if (!txtEmail.text.isEmail) {
      setState(() {
        _emailError = "Please enter a valid email address";
      });
      return;
    }

    // Validate password
    if (txtPassword.text.length < 6) {
      setState(() {
        _passwordError = "Password must be at least 6 characters";
      });
      return;
    }

    endEditing();

    serviceCallLogin({
      "email": txtEmail.text,
      "password": txtPassword.text,
      "push_token": ""
    });
  }

  //TODO: ServiceCall

  void serviceCallLogin(Map<String, dynamic> parameter) {
    setState(() => _isLoading = true);

    ServiceCall.post(parameter, SVKey.svLogin,
        withSuccess: (responseObj) async {
      if (mounted) {
        setState(() => _isLoading = false);
      }

      if (responseObj[KKey.status] == "1") {
        Globs.udSet(responseObj[KKey.payload] as Map? ?? {}, Globs.userPayload);
        Globs.udBoolSet(true, Globs.userLogin);

        // Navigate to main app after successful login
        if (mounted) {
          context.go(AppRoutes.main);
        }
      } else {
        mdShowAlert(Globs.appName,
            responseObj[KKey.message] as String? ?? MSG.fail, () {});
      }
    }, failure: (err) async {
      if (mounted) {
        setState(() => _isLoading = false);
      }
      mdShowAlert(Globs.appName, err.toString(), () {});
    });
  }
}
