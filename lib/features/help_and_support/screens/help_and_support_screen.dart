import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/features/help_and_support/widgets/support_card_widget.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';
import 'package:ride_sharing_user_app/features/help_and_support/controllers/help_and_support_controller.dart';
import 'package:ride_sharing_user_app/features/splash/controllers/splash_controller.dart';
import 'package:ride_sharing_user_app/common_widgets/app_bar_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/type_button_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpAndSupportScreen extends StatefulWidget {
  const HelpAndSupportScreen({super.key});

  @override
  State<HelpAndSupportScreen> createState() => _HelpAndSupportScreenState();
}

class _HelpAndSupportScreenState extends State<HelpAndSupportScreen> {
  @override
  void initState() {
    Get.find<HelpAndSupportController>().getPredefineFaqList();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<HelpAndSupportController>(builder: (helpAndSupportController) {
        String data =
            '${Get.find<SplashController>().config!.legal?.shortDescription??''}\n${Get.find<SplashController>().config!.legal?.longDescription??''}';
        return Stack(children: [
          Column(children: [
            AppBarWidget(title: 'support_center'.tr, regularAppbar: false),
            const SizedBox(height: 30),


            helpAndSupportController.helpAndSupportIndex == 0 ?
            Padding(padding: const EdgeInsets.symmetric(horizontal : Dimensions.paddingSizeExtraLarge),
              child: Column(children: [
                Padding(
                  padding:  const EdgeInsets.all(Dimensions.paddingSizeExtraLarge),
                  child: Center(child: SizedBox(width: 200, child: Image.asset(Images.supportDesk))),
                ),

                Text('contact_for_support'.tr,style: textBold),
                const SizedBox(height: Dimensions.paddingSizeLarge),

                InkWell(
                  onTap: ()=> _launchUrl("tel:${Get.find<SplashController>().config!.businessContactPhone!}",false),
                  child: SupportCardWidget(
                    contextText: 'call_to_our_customer_support',
                    iconPath: Images.supportCallIcon,
                  ),
                ),
                const SizedBox(height: Dimensions.paddingSizeLarge),

                InkWell(
                  onTap: ()=> _launchUrl("sms:${Get.find<SplashController>().config!.businessContactEmail!}",true),
                  child: SupportCardWidget(
                    contextText: 'you_can_send_us_email_through',
                    iconPath: Images.supportMailIcon,
                  ),
                ),
                const SizedBox(height: Dimensions.paddingSizeLarge),

                if(Get.find<SplashController>().config?.chattingSetupStatus ?? false)
                  InkWell(
                    onTap: ()=> helpAndSupportController.createChannel(),
                    child: SupportCardWidget(contextText: 'chat_with_support',iconPath: Images.supportChatIcon),
                  ),

              ]),
            ) :
            Expanded(child: SingleChildScrollView(
              padding:  const EdgeInsets.all(Dimensions.paddingSizeSmall),
              physics: const BouncingScrollPhysics(),
              child: HtmlWidget(data, key: const Key( 'privacy_policy')),
            )) ,

          ]),

          Positioned(top: 90,left: 10,right: 10,
            child: SizedBox(height: Dimensions.headerCardHeight,
              child: ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                scrollDirection: Axis.horizontal,
                itemCount: helpAndSupportController.helpAndSupportTypeList.length,
                itemBuilder: (context, index){
                  return TypeButtonWidget(
                      index: index,
                      name: helpAndSupportController.helpAndSupportTypeList[index],
                      selectedIndex: helpAndSupportController.helpAndSupportIndex,
                      cardWidth: Get.width/2.2,
                      onTap: () => helpAndSupportController.setHelpAndSupportIndex(index)
                  );
                },
              ),
            ),
          ),
        ]);
      }),
    );
  }
}

final Uri params = Uri(
  scheme: 'mailto',
  path: '',
  query: 'subject=support Feedback&body=',
);


Future<void> _launchUrl(String url, bool isMail) async {
  if (!await launchUrl(Uri.parse(isMail? params.toString() :url))) {
    throw 'Could not launch $url';
  }
}
