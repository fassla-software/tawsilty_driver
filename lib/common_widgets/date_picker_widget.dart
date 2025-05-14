import 'package:flutter/material.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/styles.dart';


class DatePickerWidget extends StatefulWidget {
  final String title;
  final String text;
  final String image;
  final bool requiredField;
  final Function()? selectDate;
  const DatePickerWidget({super.key, required this.title,required this.text,required this.image, this.requiredField = false,this.selectDate});

  @override
  State<DatePickerWidget> createState() => _DatePickerWidgetState();
}

class _DatePickerWidgetState extends State<DatePickerWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
      Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
        child: RichText(
          text: TextSpan(text: widget.title, style: textMedium.copyWith(color: Theme.of(context).textTheme.bodyMedium!.color!),
            children: <TextSpan>[
              widget.requiredField ? TextSpan(text: '  *', style: textBold.copyWith(color: Colors.red)) : const TextSpan(),
            ],
          ),
        ),
      ),

      const SizedBox(height: Dimensions.paddingSizeExtraSmall),

      Container(height: 50,
        padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).hintColor, width: 0.2),
          borderRadius: BorderRadius.circular(Dimensions.paddingSizeOverLarge),
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
          Text(widget.text, style: textRegular.copyWith(fontSize: Dimensions.fontSizeDefault),),
          InkWell(onTap: widget.selectDate,
              child: SizedBox(width: 20,height: 20,child: Image.asset(widget.image))),
        ],
        ),
      ),

    ],);
  }
}
