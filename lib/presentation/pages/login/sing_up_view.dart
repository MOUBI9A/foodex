import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:food_delivery/core/routing/app_router.dart';
import 'package:food_delivery/core/theme/color_system_v2.dart';
import 'package:food_delivery/core/theme/design_tokens_v2.dart';
import 'package:food_delivery/core/utils/extensions.dart';
import 'package:food_delivery/presentation/widgets/modern_button.dart';
import 'package:food_delivery/presentation/widgets/enhanced_text_field.dart';
import 'package:food_delivery/core/constants/globs.dart';
import 'package:food_delivery/core/network/service_call.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  TextEditingController txtName = TextEditingController();
  TextEditingController txtMobile = TextEditingController();
  TextEditingController txtAddress = TextEditingController();
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtPassword = TextEditingController();
  TextEditingController txtConfirmPassword = TextEditingController();

  bool _isLoading = false;
  String? _nameError;
  String? _emailError;
  String? _mobileError;
  String? _addressError;
  String? _passwordError;
  String? _confirmPasswordError;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColorV2.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: TColorV2.textPrimary),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(SpacingV2.xl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Logo
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    gradient: TColorV2.primaryGradient,
                    borderRadius: BorderRadius.circular(RadiusV2.lg),
                  ),
                  child: Icon(
                    Icons.restaurant_menu,
                    size: SizingV2.iconLg,
                    color: TColorV2.textInverse,
                  ),
                ),

                SizedBox(height: SpacingV2.lg),

                // Title
                Text(
                  "Create Account",
                  style: TextStyle(
                    color: TColorV2.textPrimary,
                    fontSize: TypographyScaleV2.xxxl,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                SizedBox(height: SpacingV2.xs),

                // Subtitle
                Text(
                  "Join FoodEx and start ordering",
                  style: TextStyle(
                    color: TColorV2.textSecondary,
                    fontSize: TypographyScaleV2.md,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                SizedBox(height: SpacingV2.xl),

                // Name Field
                EnhancedTextField(
                  controller: txtName,
                  label: "Full Name",
                  placeholder: "Enter your full name",
                  prefixIcon: Icons.person_outline,
                  errorText: _nameError,
                  onChanged: (value) {
                    if (_nameError != null) {
                      setState(() => _nameError = null);
                    }
                  },
                ),

                SizedBox(height: SpacingV2.md),

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

                SizedBox(height: SpacingV2.md),

                // Mobile Field
                EnhancedTextField(
                  controller: txtMobile,
                  label: "Mobile Number",
                  placeholder: "Enter your mobile number",
                  prefixIcon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                  errorText: _mobileError,
                  onChanged: (value) {
                    if (_mobileError != null) {
                      setState(() => _mobileError = null);
                    }
                  },
                ),

                SizedBox(height: SpacingV2.md),

                // Address Field
                EnhancedTextField(
                  controller: txtAddress,
                  label: "Address",
                  placeholder: "Enter your delivery address",
                  prefixIcon: Icons.location_on_outlined,
                  maxLines: 2,
                  errorText: _addressError,
                  onChanged: (value) {
                    if (_addressError != null) {
                      setState(() => _addressError = null);
                    }
                  },
                ),

                SizedBox(height: SpacingV2.md),

                // Password Field
                EnhancedTextField(
                  controller: txtPassword,
                  label: "Password",
                  placeholder: "Create a password",
                  prefixIcon: Icons.lock_outline,
                  obscureText: true,
                  showPasswordToggle: true,
                  errorText: _passwordError,
                  helperText: "At least 6 characters",
                  onChanged: (value) {
                    if (_passwordError != null) {
                      setState(() => _passwordError = null);
                    }
                  },
                ),

                SizedBox(height: SpacingV2.md),

                // Confirm Password Field
                EnhancedTextField(
                  controller: txtConfirmPassword,
                  label: "Confirm Password",
                  placeholder: "Re-enter your password",
                  prefixIcon: Icons.lock_outline,
                  obscureText: true,
                  showPasswordToggle: true,
                  errorText: _confirmPasswordError,
                  onChanged: (value) {
                    if (_confirmPasswordError != null) {
                      setState(() => _confirmPasswordError = null);
                    }
                  },
                ),

                SizedBox(height: SpacingV2.xl),

                // Sign Up Button
                ModernButton(
                  text: "Create Account",
                  onPressed: _isLoading ? null : () => btnSignUp(),
                  isLoading: _isLoading,
                  fullWidth: true,
                  size: ButtonSize.large,
                ),

                SizedBox(height: SpacingV2.xl),

                // Login Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account? ",
                      style: TextStyle(
                        color: TColorV2.textSecondary,
                        fontSize: TypographyScaleV2.md,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        context.go(AppRoutes.login);
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        "Sign In",
                        style: TextStyle(
                          color: TColorV2.primary,
                          fontSize: TypographyScaleV2.md,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: SpacingV2.lg),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //TODO: Action
  void btnSignUp() {
    // Clear previous errors
    setState(() {
      _nameError = null;
      _emailError = null;
      _mobileError = null;
      _addressError = null;
      _passwordError = null;
      _confirmPasswordError = null;
    });

    bool hasError = false;

    // Validate name
    if (txtName.text.isEmpty) {
      setState(() => _nameError = "Please enter your full name");
      hasError = true;
    }

    // Validate email
    if (!txtEmail.text.isEmail) {
      setState(() => _emailError = "Please enter a valid email address");
      hasError = true;
    }

    // Validate mobile
    if (txtMobile.text.isEmpty) {
      setState(() => _mobileError = "Please enter your mobile number");
      hasError = true;
    } else if (txtMobile.text.length < 10) {
      setState(() => _mobileError = "Mobile number must be at least 10 digits");
      hasError = true;
    }

    // Validate address
    if (txtAddress.text.isEmpty) {
      setState(() => _addressError = "Please enter your delivery address");
      hasError = true;
    }

    // Validate password
    if (txtPassword.text.length < 6) {
      setState(() => _passwordError = "Password must be at least 6 characters");
      hasError = true;
    }

    // Validate confirm password
    if (txtPassword.text != txtConfirmPassword.text) {
      setState(() => _confirmPasswordError = "Passwords do not match");
      hasError = true;
    }

    if (hasError) {
      return;
    }

    endEditing();

    serviceCallSignUp({
      "name": txtName.text,
      "mobile": txtMobile.text,
      "email": txtEmail.text,
      "address": txtAddress.text,
      "password": txtPassword.text,
      "push_token": "",
      "device_type": Platform.isAndroid ? "A" : "I"
    });
  }

  //TODO: ServiceCall

  void serviceCallSignUp(Map<String, dynamic> parameter) {
    setState(() => _isLoading = true);

    ServiceCall.post(parameter, SVKey.svSignUp,
        withSuccess: (responseObj) async {
      if (mounted) {
        setState(() => _isLoading = false);
      }

      if (responseObj[KKey.status] == "1") {
        Globs.udSet(responseObj[KKey.payload] as Map? ?? {}, Globs.userPayload);
        Globs.udBoolSet(true, Globs.userLogin);

        // Navigate to main app after successful signup
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
