import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter_cache_manager/flutter_cache_manager.dart";
import "package:flutter_svg/svg.dart";
import "package:flutter_vibrate/flutter_vibrate.dart";
import "package:fluttertoast/fluttertoast.dart";
import "package:phosphor_flutter/phosphor_flutter.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:wally/utils/config.dart";

import "../../utils/themes.dart";

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool col = false;
  bool dark = false;

  @override
  void initState() {
    getColumnsNo();
    getDark();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String brightness = Theme.of(context).brightness.toString();

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          leading: const SizedBox(),
          expandedHeight: MediaQuery.of(context).size.width > 700 ? 600 : 300,
          flexibleSpace: SizedBox(
            child: SvgPicture.asset(
              "lib/assets/backgrounds/per.svg",
              colorFilter: brightness == "Brightness.dark"
                  ? const ColorFilter.mode(
                      Color.fromARGB(68, 0, 0, 0), BlendMode.luminosity)
                  : const ColorFilter.mode(
                      Color.fromARGB(0, 0, 0, 0), BlendMode.darken),
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
                  enableFeedback: true,
                  splashColor: Colors.amber.withOpacity(0.3),
                  onTap: () {
                    Fluttertoast.showToast(
                        msg: "Cleared out all cache ",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.SNACKBAR,
                        timeInSecForIosWeb: 1,
                        textColor: Colors.white,
                        fontSize: 16.0);
                  },
                  title: Text(
                    "Clear app cache",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: brightness == "Brightness.light"
                          ? AppColors.textLight
                          : AppColors.textDark,
                    ),
                  ),
                  subtitle: Text(
                    "Clear out all temporary stored wallpapers in case your app is running slow",
                    style: TextStyle(
                        color: brightness == "Brightness.light"
                            ? AppColors.textLight.withOpacity(0.8)
                            : AppColors.textDark.withOpacity(0.8)),
                  ),
                  enabled: true,
                  trailing: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: PhosphorIcon(PhosphorIcons.regular.fileMinus),
                  ),
                ),
                ListTile(
                  enableFeedback: true,
                  splashColor: Colors.amber.withOpacity(0.3),
                  onTap: () async {
                    await DefaultCacheManager().emptyCache();
                  },
                  title: Text(
                    "Check for new wallpapers",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: brightness == "Brightness.light"
                          ? AppColors.textLight
                          : AppColors.textDark,
                    ),
                  ),
                  subtitle: Text(
                    "Although the app automatically does, yet you can do this too",
                    style: TextStyle(
                        color: brightness == "Brightness.light"
                            ? AppColors.textLight.withOpacity(0.8)
                            : AppColors.textDark.withOpacity(0.8)),
                  ),
                  enabled: true,
                  trailing: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: PhosphorIcon(PhosphorIcons.regular.sparkle),
                  ),
                ),
                MediaQuery.of(context).size.width < 600
                    ? ListTile(
                        splashColor: Colors.amber.withOpacity(0.3),
                        title: Text(
                          "Single Column display",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: brightness == "Brightness.light"
                                ? AppColors.textLight
                                : AppColors.textDark,
                          ),
                        ),
                        subtitle: Text(
                          "Enable this to display all wallpapers in single column aesthetics",
                          style: TextStyle(
                              color: brightness == "Brightness.light"
                                  ? AppColors.textLight.withOpacity(0.8)
                                  : AppColors.textDark.withOpacity(0.8)),
                        ),
                        enabled: true,
                        enableFeedback: true,
                        trailing: CupertinoSwitch(
                            applyTheme: true,
                            value: col,
                            onChanged: (value) async {
                              Vibrate.feedback(FeedbackType.success);
                              await changeColumns(value);
                              setState(() {
                                col = value;
                              });
                            }),
                      )
                    : const SizedBox(),
                MediaQuery.of(context).size.width < 600
                    ? ListTile(
                        splashColor: Colors.amber.withOpacity(0.3),
                        title: Text(
                          "Enable dark theme",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: brightness == "Brightness.light"
                                ? AppColors.textLight
                                : AppColors.textDark,
                          ),
                        ),
                        subtitle: Text(
                          "Toggle this to enable dark mode within the app",
                          style: TextStyle(
                              color: brightness == "Brightness.light"
                                  ? AppColors.textLight.withOpacity(0.8)
                                  : AppColors.textDark.withOpacity(0.8)),
                        ),
                        enabled: true,
                        enableFeedback: true,
                        trailing: CupertinoSwitch(
                            applyTheme: true,
                            value: dark,
                            onChanged: (value) async {
                              Vibrate.feedback(FeedbackType.success);
                              currentTheme.switchTheme();
                              setState(() {
                                dark = value;
                              });
                            }),
                      )
                    : const SizedBox(),
              ],
            ),
          ),
        )
      ],
    );
  }

  getColumnsNo() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final int? columns = prefs.getInt("mobColumns");

    if (columns != null) {
      if (columns == 1) {
        setState(() {
          col = true;
        });
      } else if (columns == 2) {
        setState(() {
          col = false;
        });
      }
    } else {
      setState(() {
        col = false;
      });
    }
  }

  changeColumns(bool cols) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt("mobColumns", cols == true ? 1 : 2);
  }

  getDark() {
    ThemeMode theme = currentTheme.currentTheme();
    if (theme == ThemeMode.light) {
      setState(() {
        dark = false;
      });
    } else {
      setState(() {
        dark = true;
      });
    }
  }
}
