import 'package:flutter/material.dart';
import 'package:food_delivery/core/constants/globs.dart';
import 'package:food_delivery/core/network/service_call.dart';
import 'package:food_delivery/core/theme/color_extension.dart';
import 'package:food_delivery/core/utils/extensions.dart';
import 'package:food_delivery/presentation/pages/login/rest_password_view.dart';
import 'package:food_delivery/presentation/pages/login/sing_up_view.dart';
import 'package:food_delivery/presentation/pages/on_boarding/on_boarding_view.dart';
import 'package:food_delivery/presentation/widgets/round_button.dart';
import 'package:food_delivery/presentation/widgets/round_icon_button.dart';
import 'package:food_delivery/l10n/generated/app_localizations.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController txtEmail;
  late final TextEditingController txtPassword;

  bool _obscurePassword = true;
  bool _rememberMe = true;
  final List<String> _roleIds = ['customer', 'chef', 'driver'];
  String _activeRole = 'customer';

  @override
  void initState() {
    super.initState();
    txtEmail = TextEditingController();
    txtPassword = TextEditingController();
  }

  @override
  void dispose() {
    txtEmail.dispose();
    txtPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: const Color(0xFFF8F6F1),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeroHeader(l10n),
              const SizedBox(height: 28),
              _buildRoleSelector(l10n),
              const SizedBox(height: 16),
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
                        Text(
                          l10n.loginWelcomeBack(_roleLabel(l10n, _activeRole)),
                          style: TextStyle(
                            color: TColor.primaryText,
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          l10n.loginFormSubtitle,
                          style: TextStyle(
                            color: TColor.secondaryText,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 22),
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
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    _rememberMe = !_rememberMe;
                                  });
                                },
                                child: Row(
                                  children: [
                                    Checkbox(
                                      value: _rememberMe,
                                      onChanged: (val) {
                                        setState(() {
                                          _rememberMe = val ?? false;
                                        });
                                      },
                                      activeColor: TColor.primary,
                                      materialTapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      l10n.rememberMe,
                                      style: TextStyle(
                                        color: TColor.secondaryText,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const ResetPasswordView(),
                                  ),
                                );
                              },
                              child: Text(l10n.forgotPassword),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        RoundButton(
                          title: l10n.actionLogin,
                          onPressed: btnLogin,
                          type: RoundButtonType.bgPrimary,
                        ),
                        const SizedBox(height: 18),
                        _buildDivider(),
                        const SizedBox(height: 16),
                        RoundIconButton(
                          icon: "assets/images/google_logo.png",
                          title: l10n.continueWithGoogle,
                          color: const Color(0xffDD4B39),
                          onPressed: () {},
                        ),
                        const SizedBox(height: 12),
                        RoundIconButton(
                          icon: "assets/images/facebook_logo.png",
                          title: l10n.continueWithFacebook,
                          color: const Color(0xff367FC0),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              _buildFooter(l10n),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeroHeader(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.loginHeroTitle,
          style: TextStyle(
            color: TColor.primaryText,
            fontSize: 32,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          l10n.loginHeroSubtitle,
          style: TextStyle(
            color: TColor.secondaryText,
            fontSize: 15,
          ),
        ),
      ],
    );
  }

  Widget _buildRoleSelector(AppLocalizations l10n) {
    return SizedBox(
      height: 78,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemBuilder: (_, index) {
          final roleId = _roleIds[index];
          final isActive = _activeRole == roleId;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            width: 180,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isActive ? TColor.primary : Colors.white,
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: InkWell(
              onTap: () {
                setState(() {
                  _activeRole = roleId;
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
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _roleCaption(l10n, roleId),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: isActive
                          ? Colors.white.withOpacity(0.85)
                          : TColor.secondaryText,
                      fontSize: 12,
                    ),
                  )
                ],
              ),
            ),
          );
        },
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemCount: _roles.length,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    String? Function(String?)? validator,
    bool obscureText = false,
    Widget? trailing,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      obscureText: obscureText,
      keyboardType: keyboardType,
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

  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 1,
            color: Colors.grey.withOpacity(0.3),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            l10n.orContinueWith,
            style: TextStyle(color: TColor.secondaryText, fontSize: 12),
          ),
        ),
        Expanded(
          child: Container(
            height: 1,
            color: Colors.grey.withOpacity(0.3),
          ),
        ),
      ],
    );
  }

  Widget _buildFooter(AppLocalizations l10n) {
    return Column(
      children: [
        Text(
          l10n.loginFooterPrompt,
          style: TextStyle(color: TColor.secondaryText),
        ),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SignUpView()),
            );
          },
          child: Text(
            l10n.actionCreateAccount,
            style: TextStyle(
              color: TColor.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
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

  void btnLogin() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    endEditing();

    serviceCallLogin({
      "email": txtEmail.text.trim(),
      "password": txtPassword.text,
      "push_token": "",
    });
  }

  void serviceCallLogin(Map<String, dynamic> parameter) {
    Globs.showHUD();

    ServiceCall.post(parameter, SVKey.svLogin,
        withSuccess: (responseObj) async {
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
