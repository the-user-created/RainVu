import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:font_awesome_flutter/font_awesome_flutter.dart";
import "package:rain_wise/flutter_flow/flutter_flow_theme.dart";
import "package:rain_wise/flutter_flow/flutter_flow_util.dart";
import "package:rain_wise/tabs/home/home_widget.dart";
import "package:rain_wise/tabs/insights/insights_widget.dart";
import "package:rain_wise/tabs/map/map_widget.dart";
import "package:rain_wise/tabs/settings/settings_widget.dart";

class NavBarPage extends StatefulWidget {
  const NavBarPage({super.key, this.initialPage, this.page});

  final String? initialPage;
  final Widget? page;

  @override
  NavBarPageState createState() => NavBarPageState();

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty("initialPage", initialPage));
  }
}

/// This is the private State class that goes with NavBarPage.
class NavBarPageState extends State<NavBarPage> {
  String _currentPageName = "home";
  late Widget? _currentPage;

  @override
  void initState() {
    super.initState();
    _currentPageName = widget.initialPage ?? _currentPageName;
    _currentPage = widget.page;
  }

  @override
  Widget build(final BuildContext context) {
    final Map<String, StatefulWidget> tabs = {
      "home": const HomeWidget(),
      "insights": const InsightsWidget(),
      "map": const MapWidget(),
      "settings": const SettingsWidget(),
    };
    final int currentIndex = tabs.keys.toList().indexOf(_currentPageName);

    return Scaffold(
      body: _currentPage ?? tabs[_currentPageName],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (final i) => safeSetState(() {
          _currentPage = null;
          _currentPageName = tabs.keys.toList()[i];
        }),
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        selectedItemColor: FlutterFlowTheme.of(context).secondary,
        unselectedItemColor: FlutterFlowTheme.of(context).secondaryText,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: FaIcon(
              FontAwesomeIcons.house,
            ),
            label: "",
            tooltip: "",
          ),
          BottomNavigationBarItem(
            icon: FaIcon(
              FontAwesomeIcons.chartLine,
            ),
            label: "Home",
            tooltip: "",
          ),
          BottomNavigationBarItem(
            icon: FaIcon(
              FontAwesomeIcons.mapLocationDot,
            ),
            label: "",
            tooltip: "",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.settings_rounded,
            ),
            label: "Settings",
            tooltip: "",
          ),
        ],
      ),
    );
  }
}
