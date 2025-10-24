import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/color_system_v2.dart';
import '../../core/theme/design_tokens_v2.dart';
import '../../core/theme/animations_v2.dart';

/// Enhanced TextField with Professional Design
///
/// Features:
/// - Floating label animation
/// - Validation states (success, error)
/// - Character counter
/// - Prefix/suffix icons
/// - Smooth border transitions
/// - Clear button
/// - Password visibility toggle
class EnhancedTextField extends StatefulWidget {
  /// Text field controller
  final TextEditingController? controller;

  /// Label text
  final String? label;

  /// Placeholder text
  final String? placeholder;

  /// Helper text (below field)
  final String? helperText;

  /// Error text (validation message)
  final String? errorText;

  /// Success message
  final String? successText;

  /// Prefix icon
  final IconData? prefixIcon;

  /// Suffix icon
  final IconData? suffixIcon;

  /// Suffix icon callback
  final VoidCallback? onSuffixIconTap;

  /// Show clear button when text is entered
  final bool showClearButton;

  /// Obscure text (password field)
  final bool obscureText;

  /// Show password toggle button
  final bool showPasswordToggle;

  /// Keyboard type
  final TextInputType? keyboardType;

  /// Input formatters
  final List<TextInputFormatter>? inputFormatters;

  /// Max lines
  final int maxLines;

  /// Max length
  final int? maxLength;

  /// Show character counter
  final bool showCharacterCount;

  /// Enabled state
  final bool enabled;

  /// On changed callback
  final ValueChanged<String>? onChanged;

  /// On submitted callback
  final ValueChanged<String>? onSubmitted;

  /// Validation mode
  final ValidationMode validationMode;

  /// Autofocus
  final bool autofocus;

  const EnhancedTextField({
    super.key,
    this.controller,
    this.label,
    this.placeholder,
    this.helperText,
    this.errorText,
    this.successText,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixIconTap,
    this.showClearButton = true,
    this.obscureText = false,
    this.showPasswordToggle = false,
    this.keyboardType,
    this.inputFormatters,
    this.maxLines = 1,
    this.maxLength,
    this.showCharacterCount = false,
    this.enabled = true,
    this.onChanged,
    this.onSubmitted,
    this.validationMode = ValidationMode.auto,
    this.autofocus = false,
  });

  @override
  State<EnhancedTextField> createState() => _EnhancedTextFieldState();
}

class _EnhancedTextFieldState extends State<EnhancedTextField>
    with SingleTickerProviderStateMixin {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  late AnimationController _animationController;
  bool _obscureText = false;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _focusNode = FocusNode();
    _obscureText = widget.obscureText;

    _animationController = AnimationController(
      duration: AnimationsV2.normal,
      vsync: this,
    );

    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
      if (_isFocused) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });

    _controller.addListener(() {
      setState(() {});
    });

    if (widget.autofocus) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _focusNode.requestFocus();
      });
    }
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    _focusNode.dispose();
    _animationController.dispose();
    super.dispose();
  }

  bool get _hasText => _controller.text.isNotEmpty;
  bool get _hasError =>
      widget.errorText != null && widget.errorText!.isNotEmpty;
  bool get _hasSuccess =>
      widget.successText != null &&
      widget.successText!.isNotEmpty &&
      !_hasError;

  Color get _borderColor {
    if (!widget.enabled) return TColorV2.neutral300;
    if (_hasError) return TColorV2.error;
    if (_hasSuccess) return TColorV2.success;
    if (_isFocused) return TColorV2.primary;
    return TColorV2.neutral300;
  }

  Color get _labelColor {
    if (!widget.enabled) return TColorV2.neutral400;
    if (_hasError) return TColorV2.error;
    if (_hasSuccess) return TColorV2.success;
    if (_isFocused) return TColorV2.primary;
    return TColorV2.textSecondary;
  }

  Widget? _buildSuffixIcon() {
    if (!widget.enabled) return null;

    // Priority: Password toggle > Clear button > Custom suffix icon
    if (widget.showPasswordToggle && widget.obscureText) {
      return IconButton(
        icon: Icon(
          _obscureText ? Icons.visibility_off : Icons.visibility,
          size: SizingV2.iconSm,
        ),
        color: TColorV2.neutral500,
        onPressed: () {
          setState(() {
            _obscureText = !_obscureText;
          });
        },
      );
    }

    if (widget.showClearButton && _hasText && _isFocused) {
      return IconButton(
        icon: Icon(
          Icons.clear,
          size: SizingV2.iconSm,
        ),
        color: TColorV2.neutral500,
        onPressed: () {
          _controller.clear();
          widget.onChanged?.call('');
        },
      );
    }

    if (widget.suffixIcon != null) {
      return IconButton(
        icon: Icon(
          widget.suffixIcon,
          size: SizingV2.iconSm,
        ),
        color: _labelColor,
        onPressed: widget.onSuffixIconTap,
      );
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedContainer(
          duration: AnimationsV2.normal,
          curve: AnimationsV2.emphasized,
          decoration: BoxDecoration(
            color: widget.enabled ? TColorV2.surface : TColorV2.neutral100,
            borderRadius: BorderRadius.circular(RadiusV2.input),
            border: Border.all(
              color: _borderColor,
              width: _isFocused ? 2 : 1.5,
            ),
          ),
          child: TextField(
            controller: _controller,
            focusNode: _focusNode,
            enabled: widget.enabled,
            obscureText: _obscureText,
            keyboardType: widget.keyboardType,
            inputFormatters: widget.inputFormatters,
            maxLines: widget.maxLines,
            maxLength: widget.maxLength,
            autofocus: widget.autofocus,
            style: TextStyle(
              fontSize: TypographyScaleV2.md,
              color:
                  widget.enabled ? TColorV2.textPrimary : TColorV2.neutral500,
            ),
            decoration: InputDecoration(
              labelText: widget.label,
              labelStyle: TextStyle(
                fontSize: TypographyScaleV2.md,
                color: _labelColor,
              ),
              floatingLabelStyle: TextStyle(
                fontSize: TypographyScaleV2.sm,
                color: _labelColor,
                fontWeight: FontWeight.w500,
              ),
              hintText: widget.placeholder,
              hintStyle: TextStyle(
                fontSize: TypographyScaleV2.md,
                color: TColorV2.neutral400,
              ),
              prefixIcon: widget.prefixIcon != null
                  ? Icon(
                      widget.prefixIcon,
                      size: SizingV2.iconSm,
                      color: _labelColor,
                    )
                  : null,
              suffixIcon: _buildSuffixIcon(),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: SpacingV2.lg,
                vertical: SpacingV2.md,
              ),
              counterText: '', // Hide default counter
            ),
            onChanged: widget.onChanged,
            onSubmitted: widget.onSubmitted,
          ),
        ),

        // Helper/Error/Success text and character count
        if (_hasError ||
            _hasSuccess ||
            (widget.helperText != null) ||
            (widget.showCharacterCount && widget.maxLength != null))
          Padding(
            padding: EdgeInsets.only(
              left: SpacingV2.md,
              right: SpacingV2.md,
              top: SpacingV2.xs,
            ),
            child: Row(
              children: [
                Expanded(
                  child: AnimatedSwitcher(
                    duration: AnimationsV2.fast,
                    child: _hasError
                        ? Row(
                            children: [
                              Icon(
                                Icons.error_outline,
                                size: SizingV2.iconXs,
                                color: TColorV2.error,
                              ),
                              SizedBox(width: SpacingV2.xxs),
                              Expanded(
                                child: Text(
                                  widget.errorText!,
                                  style: TextStyle(
                                    fontSize: TypographyScaleV2.xs,
                                    color: TColorV2.error,
                                  ),
                                ),
                              ),
                            ],
                          )
                        : _hasSuccess
                            ? Row(
                                children: [
                                  Icon(
                                    Icons.check_circle_outline,
                                    size: SizingV2.iconXs,
                                    color: TColorV2.success,
                                  ),
                                  SizedBox(width: SpacingV2.xxs),
                                  Expanded(
                                    child: Text(
                                      widget.successText!,
                                      style: TextStyle(
                                        fontSize: TypographyScaleV2.xs,
                                        color: TColorV2.success,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : widget.helperText != null
                                ? Text(
                                    widget.helperText!,
                                    style: TextStyle(
                                      fontSize: TypographyScaleV2.xs,
                                      color: TColorV2.textSecondary,
                                    ),
                                  )
                                : SizedBox.shrink(),
                  ),
                ),
                if (widget.showCharacterCount && widget.maxLength != null) ...[
                  SizedBox(width: SpacingV2.sm),
                  Text(
                    '${_controller.text.length}/${widget.maxLength}',
                    style: TextStyle(
                      fontSize: TypographyScaleV2.xs,
                      color: _controller.text.length >= widget.maxLength!
                          ? TColorV2.error
                          : TColorV2.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
          ),
      ],
    );
  }
}

/// Validation mode for text field
enum ValidationMode {
  /// Validate on every change
  auto,

  /// Validate only when focus is lost
  onBlur,

  /// Validate only when form is submitted
  manual,
}
