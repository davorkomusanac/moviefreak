import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AgreeTermsCheckbox extends StatelessWidget {
  const AgreeTermsCheckbox({
    Key? key,
    required this.isAgreed,
    required this.onChanged,
  }) : super(key: key);

  final bool isAgreed;
  final void Function(bool?)? onChanged;

  void _launchWebPage(BuildContext context) async {
    try {
      if (await canLaunchUrl(Uri.parse("https://www.explovid.com/"))) {
        await launchUrl(Uri.parse("https://www.explovid.com/"));
      } else {
        throw 'Could not launch web page';
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(left: 5, right: 5),
        child: ListTile(
          leading: Checkbox(
            value: isAgreed,
            onChanged: onChanged,
          ),
          title: RichText(
            text: TextSpan(
              text: "I confirm that I am over 18 and I agree to the ",
              style: const TextStyle(color: Colors.black),
              children: [
                TextSpan(
                  text: "Terms of Use",
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      _launchWebPage(context);
                    },
                ),
                const TextSpan(text: " and ", style: TextStyle()),
                TextSpan(
                  text: "Privacy Policy",
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      _launchWebPage(context);
                    },
                ),
              ],
            ),
          ),
        ),
      );
}
