import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/localization/localization_controller.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/styles.dart';
import 'package:ride_sharing_user_app/common_widgets/country_picker_widget.dart';

class TextFieldWidget extends StatefulWidget {
  final String? hintText;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final FocusNode? nextFocus;
  final TextInputType inputType;
  final TextInputAction inputAction;
  final bool isPassword;
  final bool isAmount;
  final Function(String text)? onChanged;
  final bool isEnabled;
  final int maxLines;
  final TextCapitalization capitalization;
  final double borderRadius;
  final String? prefixIcon;
  final bool showBorder;
  final String? countryDialCode;
  final double prefixHeight;
  final bool showCountryCode;
  final Function(CountryCode countryCode)? onCountryChanged;


  const TextFieldWidget(
      {super.key,
        this.hintText = 'Write something...',
        this.controller,
        this.focusNode,
        this.nextFocus,
        this.isEnabled = true,
        this.inputType = TextInputType.text,
        this.inputAction = TextInputAction.next,
        this.maxLines = 1,
        this.onChanged,
        this.prefixIcon,
        this.capitalization = TextCapitalization.none,
        this.isPassword = false,
        this.isAmount = false,
        this.borderRadius=50,
        this.showBorder = false,
        this.prefixHeight = 50,
        this.countryDialCode,
        this.onCountryChanged,
        this.showCountryCode = true,
      });

  @override
  State<TextFieldWidget> createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLines: widget.maxLines,
      controller: widget.controller,
      focusNode: widget.focusNode,
      style: textRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodyMedium?.color),
      textInputAction: widget.inputAction,
      keyboardType: (widget.isAmount || widget.inputType == TextInputType.phone) ? const TextInputType.numberWithOptions(
        signed: false, decimal: true,
      ) : widget.inputType,
      cursorColor: Theme.of(context).primaryColor,
      textCapitalization: widget.capitalization,
      enabled: widget.isEnabled,
      autofocus: false,
      autofillHints: widget.inputType == TextInputType.name ? [AutofillHints.name]
          : widget.inputType == TextInputType.emailAddress ? [AutofillHints.email]
          : widget.inputType == TextInputType.phone ? [AutofillHints.telephoneNumber]
          : widget.inputType == TextInputType.streetAddress ? [AutofillHints.fullStreetAddress]
          : widget.inputType == TextInputType.url ? [AutofillHints.url]
          : widget.inputType == TextInputType.visiblePassword ? [AutofillHints.password] : null,
      obscureText: widget.isPassword ? _obscureText : false,
      inputFormatters: widget.inputType == TextInputType.phone ? <TextInputFormatter>[FilteringTextInputFormatter.allow(RegExp(r'[0-9+]'))]
          : widget.isAmount ? [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))] : null,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          borderSide:  BorderSide(width: widget.showBorder? 0.5 : 0.5,
              color: Theme.of(context).hintColor.withOpacity(0.5)),
        ),

        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          borderSide:  BorderSide(width: widget.showBorder? 0.5 : 0.5,
              color: Theme.of(context).hintColor.withOpacity(0.5)),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          borderSide:  BorderSide(width: widget.showBorder? 0.5 : 0.5,
              color: Theme.of(context).primaryColor),
        ),
        hintText: widget.hintText,
        fillColor: Theme.of(context).cardColor,
        hintStyle: textRegular.copyWith(
            fontSize: Dimensions.fontSizeSmall,
            color: Theme.of(context).textTheme.bodyMedium!.color!.withOpacity(0.5),
        ),
        filled: true,
        contentPadding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall, vertical: widget.isEnabled?0:13),

        prefixIcon: widget.prefixIcon!=null ?
        Container(
          margin: EdgeInsets.only(right: Get.find<LocalizationController>().isLtr?10:0, left: Get.find<LocalizationController>().isLtr? 0 : 10),
          width: widget.prefixHeight,
          padding: const EdgeInsets.all(1),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.only(
              topRight: Get.find<LocalizationController>().isLtr?  const Radius.circular(0):Radius.circular(widget.borderRadius),
              bottomRight: Get.find<LocalizationController>().isLtr?  const Radius.circular(0):Radius.circular(widget.borderRadius),
              topLeft: Get.find<LocalizationController>().isLtr? Radius.circular(widget.borderRadius):const Radius.circular(0),
              bottomLeft: Get.find<LocalizationController>().isLtr? Radius.circular(widget.borderRadius):const Radius.circular(0),
            ),
          ),
          child: Center(child: Image.asset(widget.prefixIcon!, height: 20, width: 20)),):
        SizedBox(width: widget.showCountryCode? 125 : 80,
          child: Row(
            children: [
              Container(width: 70,height: 50,
                decoration: BoxDecoration(
                  color:Theme.of(context).primaryColor.withOpacity(0.1) ,
                  borderRadius: BorderRadius.only(
                    topRight: Get.find<LocalizationController>().isLtr?  const Radius.circular(0):Radius.circular(widget.borderRadius),
                    bottomRight: Get.find<LocalizationController>().isLtr?  const Radius.circular(0):Radius.circular(widget.borderRadius),
                    topLeft: Get.find<LocalizationController>().isLtr? Radius.circular(widget.borderRadius): const Radius.circular(0),
                    bottomLeft: Get.find<LocalizationController>().isLtr? Radius.circular(widget.borderRadius): const Radius.circular(0),
                  ),
                ),
                margin:  EdgeInsets.only(right: Get.find<LocalizationController>().isLtr? 10 : 0, left: Get.find<LocalizationController>().isLtr? 0 : 10),
                padding:  EdgeInsets.only(left: Get.find<LocalizationController>().isLtr?15:0 , right: Get.find<LocalizationController>().isLtr?0:15),
                child: Center(
                  child: CodePickerWidget(
                    enabled: false,
                    searchStyle: textRegular.copyWith(
                      fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodyMedium!.color,
                    ),
                    flagWidth: 25,
                    padding: EdgeInsets.zero,
                    onChanged: widget.onCountryChanged,
                    initialSelection: widget.countryDialCode,
                    showDropDownButton: true,
                    showCountryOnly: true,
                    showOnlyCountryWhenClosed: true,
                    showFlagDialog: true,
                    hideMainText: true,
                    showFlagMain: true,
                    dialogBackgroundColor: Theme.of(context).cardColor,
                    barrierColor: Get.isDarkMode?Colors.black.withOpacity(0.4):null,
                    textStyle: textRegular.copyWith(
                      fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodyMedium!.color,
                    ),
                  ),
                ),
              ),
              if(widget.showCountryCode)
              Padding(
                padding: const EdgeInsets.only(bottom: 2.0),
                child: Text(widget.countryDialCode??'', style: textRegular.copyWith(fontSize: Dimensions.fontSizeDefault),),
              ),
            ],
          ),
        ),

        suffixIcon: widget.isPassword ? IconButton(
          icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility, color: Theme.of(context).hintColor.withOpacity(0.5)),
          onPressed: _toggle,
        ) : null,
      ),
      onSubmitted: (text) => widget.nextFocus != null ? FocusScope.of(context).requestFocus(widget.nextFocus)
          : null,
      onChanged: widget.onChanged,
    );
  }

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }
}