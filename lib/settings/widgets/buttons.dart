import 'package:flutter/material.dart';

const kTitleTextStyle = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.w600,
);

class SettingsButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final Function onPressed;
  final bool hasNavgigation;

  const SettingsButton(
      {super.key,
      required this.icon,
      required this.text,
      required this.onPressed,
      this.hasNavgigation = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      margin: const EdgeInsets.symmetric(horizontal: 40).copyWith(bottom: 20),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Theme.of(context).cardColor),
      child: InkWell(
        onTap: () {
          onPressed(context);
        },
        borderRadius: BorderRadius.circular(30),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Icon(
                icon,
                size: 30,
              ),
              const SizedBox(
                width: 8,
              ),
              SizedBox(
                width: hasNavgigation
                    ? MediaQuery.of(context).size.width * 0.55
                    : MediaQuery.of(context).size.width * 0.61,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    text,
                    style:
                        kTitleTextStyle.copyWith(fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              const Spacer(),
              Visibility(
                visible: hasNavgigation,
                child: const Icon(
                  Icons.keyboard_arrow_right,
                  // IconlyLight.arrow_right_2,
                  size: 30,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SettingsSwitchButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool value;
  final Function(bool) onChanged;

  const SettingsSwitchButton({
    super.key,
    required this.icon,
    required this.text,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      margin: const EdgeInsets.symmetric(horizontal: 40).copyWith(bottom: 20),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Theme.of(context).cardColor),
      child: InkWell(
        onTap: () {
          // Optional: You could toggle the switch on tap if desired
          onChanged(!value);
        },
        borderRadius: BorderRadius.circular(30),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Icon(
                icon,
                size: 30,
              ),
              const SizedBox(
                width: 8,
              ),
              SizedBox(
                // width: MediaQuery.of(context).size.width * 0.55,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    text,
                    style:
                        kTitleTextStyle.copyWith(fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              const Spacer(),
              Switch(
                value: value,
                onChanged: onChanged,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SettingsToggleButtons extends StatelessWidget {
  final IconData icon;
  final String text;
  final List<bool> isSelected;
  final List<Widget> children;
  final Function(int) onPressed;

  const SettingsToggleButtons({
    super.key,
    required this.icon,
    required this.text,
    required this.isSelected,
    required this.children,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 40).copyWith(bottom: 20),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Theme.of(context).cardColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 30,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    text,
                    style:
                        kTitleTextStyle.copyWith(fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8), // Spacing between text and ToggleButtons
          ToggleButtons(
            textStyle: const TextStyle(
              fontSize: 15,
            ),
            isSelected: isSelected,
            onPressed: onPressed,
            borderRadius: BorderRadius.circular(20),
            children: children,
          ),
        ],
      ),
    );
  }
}
