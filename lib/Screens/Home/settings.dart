import "package:flutter/material.dart";
import "package:phosphor_flutter/phosphor_flutter.dart";

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: MediaQuery.of(context).size.width > 700 ? 600 : 300,
          flexibleSpace: SizedBox(
            child: Image.asset(
              "lib/assets/backgrounds/per.png",
              fit: BoxFit.cover,
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
            child: Column(
              children: [
                ListTile(
                  splashColor: Colors.amber.withOpacity(0.3),
                  onTap: () {},
                  title: const Text(
                    "Clear app cache",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: const Text(
                      "Clear out all temporary stored wallpapers in case your app is running slow"),
                  enabled: true,
                  trailing: PhosphorIcon(PhosphorIcons.regular.fileMinus),
                ),
                ListTile(
                  splashColor: Colors.amber.withOpacity(0.3),
                  onTap: () {},
                  title: const Text(
                    "Check for new wallpapers",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: const Text(
                      "Although the app automatically does, yet you can do this too"),
                  enabled: true,
                  trailing: PhosphorIcon(PhosphorIcons.regular.sparkle),
                ),
                ListTile(
                  splashColor: Colors.amber.withOpacity(0.3),
                  // onTap: () {},

                  title: const Text(
                    "Change theme",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: const Text(
                      "This is not yet available, but will be available soon, sooner tgan you think"),
                  enabled: false,
                  trailing: PhosphorIcon(PhosphorIcons.regular.paintRoller),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
