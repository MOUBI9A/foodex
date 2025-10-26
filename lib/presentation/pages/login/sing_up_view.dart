import 'dart:io';

import 'package:flutter/material.dart';
import 'package:food_delivery/core/constants/globs.dart';
import 'package:food_delivery/core/network/service_call.dart';
import 'package:food_delivery/core/theme/color_extension.dart';
import 'package:food_delivery/core/utils/extensions.dart';
import 'package:food_delivery/presentation/pages/login/login_view.dart';
import 'package:food_delivery/presentation/pages/on_boarding/on_boarding_view.dart';
import 'package:food_delivery/presentation/widgets/round_button.dart';
import 'package:food_delivery/l10n/generated/app_localizations.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController txtName;
  late final TextEditingController txtMobile;
  late final TextEditingController txtAddress;
  late final TextEditingController txtEmail;
  late final TextEditingController txtPassword;
  late final TextEditingController txtConfirmPassword;

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _acceptTerms = true;
  String _selectedRole = 'customer';
  final List<String> _roleIds = ['customer', 'chef', 'driver'];

  @override
  void initState() {
    super.initState();
    txtName = TextEditingController();
    txtMobile = TextEditingController();
    txtAddress = TextEditingController();
    txtEmail = TextEditingController();
    txtPassword = TextEditingController();
    txtConfirmPassword = TextEditingController();
  }

  @override
  void dispose() {
    txtName.dispose();
    txtMobile.dispose();
    txtAddress.dispose();
    txtEmail.dispose();
    txtPassword.dispose();
    txtConfirmPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: const Color(0xFFF8F6F1),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
          child: Column(
            children: [
              _buildHeader(l10n),
              const SizedBox(height: 22),
              _buildRoleCards(l10n),
              const SizedBox(height: 20),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
                elevation: 6,
                shadowColor: Colors.black12,
                child: Padding(
                  padding: const EdgeInsets.all(22),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildTextField(
                          controller: txtName,
                          label: l10n.fullNameLabel,
                          hint: l10n.fullNameHint,
                          icon: Icons.person_outline,
                          textCapitalization: TextCapitalization.words,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return l10n.errorNameRequired;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          controller: txtEmail,
                          label: l10n.emailLabel,
                          hint: l10n.emailHint,
                          icon: Icons.mail_outline,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return l10n.errorEmailRequired;
                            }
                            if (!value.trim().isEmail) {
                              return l10n.errorEmailInvalid;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          controller: txtMobile,
                          label: l10n.mobileLabel,
                          hint: l10n.mobileHint,
                          icon: Icons.phone_outlined,
                          keyboardType: TextInputType.phone,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return l10n.errorMobileRequired;
                            }
                            if (value.trim().length < 8) {
                              return l10n.errorMobileLength;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          controller: txtAddress,
                          label: l10n.addressLabel,
                          hint: l10n.addressHint,
                          icon: Icons.location_on_outlined,
                          textCapitalization: TextCapitalization.sentences,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return l10n.errorAddressRequired;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          controller: txtPassword,
                          label: l10n.passwordLabel,
                          hint: l10n.passwordHint,
                          icon: Icons.lock_outline,
                          obscureText: _obscurePassword,
                          validator: (value) {
                            if (value == null || value.length < 6) {
                              return l10n.errorPasswordLength;
                            }
                            return null;
                          },
                          trailing: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: TColor.secondaryText,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          controller: txtConfirmPassword,
                          label: l10n.confirmPasswordLabel,
                          hint: l10n.confirmPasswordHint,
                          icon: Icons.lock_outline,
                          obscureText: _obscureConfirmPassword,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return l10n.errorConfirmPasswordRequired;
                            }
                            if (value != txtPassword.text) {
                              return l10n.errorPasswordMismatch;
                            }
                            return null;
                          },
                          trailing: IconButton(
                            icon: Icon(
                              _obscureConfirmPassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: TColor.secondaryText,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureConfirmPassword =
                                    !_obscureConfirmPassword;
                              });
                            },
                          ),
                        ),
                        const SizedBox(height: 18),
                        Row(
                          children: [
                            Checkbox(
                              value: _acceptTerms,
                              onChanged: (value) {
                                setState(() {
                                  _acceptTerms = value ?? false;
                                });
                              },
                              activeColor: TColor.primary,
                            ),
                            Expanded(
                              child: RichText(
                                text: TextSpan(
                                  style: TextStyle(
                                    color: TColor.secondaryText,
                                    fontSize: 13,
                                  ),
                                  children: [
                                    TextSpan(text: l10n.termsAgreementPrefix),
                                    TextSpan(
                                      text: l10n.termsPolicyLink,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        RoundButton(
                          title: l10n.actionCreateAccount,
                          onPressed: btnSignUp,
                          type: RoundButtonType.bgPrimary,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    l10n.signupAlreadyPrompt,
                    style: TextStyle(color: TColor.secondaryText),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginView()),
                      );
                    },
                    child: Text(
                      l10n.actionLogin,
                      style: TextStyle(
                        color: TColor.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            color: TColor.primary,
            onPressed: () => Navigator.pop(context),
          ),
        ),
        Text(
          l10n.signupTitle,
          style: TextStyle(
            color: TColor.primaryText,
            fontSize: 30,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          l10n.signupSubtitle,
          style: TextStyle(
            color: TColor.secondaryText,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildRoleCards(AppLocalizations l10n) {
    return SizedBox(
      height: 120,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final roleId = _roleIds[index];
          final isActive = _selectedRole == roleId;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            width: 170,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isActive ? TColor.primary : Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 12,
                  offset: const Offset(0, 8),
                )
              ],
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(24),
              onTap: () {
                setState(() {
                  _selectedRole = roleId;
                });
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _roleLabel(l10n, roleId),
                    style: TextStyle(
                      color: isActive ? Colors.white : TColor.primaryText,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _roleCaption(l10n, roleId),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: isActive
                          ? Colors.white.withOpacity(0.85)
                          : TColor.secondaryText,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        separatorBuilder: (_, __) => const SizedBox(width: 14),
        itemCount: _roleIds.length,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    bool obscureText = false,
    Widget? trailing,
    TextCapitalization textCapitalization = TextCapitalization.none,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      obscureText: obscureText,
      textCapitalization: textCapitalization,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: TColor.primary),
        suffixIcon: trailing,
        filled: true,
        fillColor: Colors.grey[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: TColor.primary, width: 1.6),
        ),
      ),
    );
  }

  void btnSignUp() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (!_acceptTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.errorAcceptTerms),
        ),
      );
      return;
    }

    endEditing();

    serviceCallSignUp({
      "name": txtName.text.trim(),
      "mobile": txtMobile.text.trim(),
      "email": txtEmail.text.trim(),
      "address": txtAddress.text.trim(),
      "password": txtPassword.text,
      "push_token": "",
      "user_type": _selectedRole,
      "device_type": Platform.isAndroid ? "A" : "I"
    });
  }

  String _roleLabel(AppLocalizations l10n, String roleId) {
    switch (roleId) {
      case 'chef':
        return l10n.roleChef;
      case 'driver':
        return l10n.roleDriver;
      default:
        return l10n.roleCustomer;
    }
  }

  String _roleCaption(AppLocalizations l10n, String roleId) {
    switch (roleId) {
      case 'chef':
        return l10n.roleChefCaption;
      case 'driver':
        return l10n.roleDriverCaption;
      default:
        return l10n.roleCustomerCaption;
    }
  }

  void serviceCallSignUp(Map<String, dynamic> parameter) {
    Globs.showHUD();
    ServiceCall.post(parameter, SVKey.svSignUp, withSuccess: (responseObj) {
      Globs.hideHUD();
      if (responseObj[KKey.status] == "1") {
        Globs.udSet(responseObj[KKey.payload] as Map? ?? {}, Globs.userPayload);
        Globs.udBoolSet(true, Globs.userLogin);

        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const OnBoardingView(),
            ),
            (route) => false);
      } else {
        mdShowAlert(Globs.appName,
            responseObj[KKey.message] as String? ?? MSG.fail, () {});
      }
    }, failure: (p0) {
      Globs.hideHUD();
      mdShowAlert(Globs.appName, p0 as String? ?? MSG.fail, () {});
    });
  }
}
