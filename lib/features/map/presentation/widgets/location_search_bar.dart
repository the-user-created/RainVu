import "package:flutter/material.dart";
import "package:rain_wise/flutter_flow/flutter_flow_theme.dart";

class LocationSearchBar extends StatefulWidget {
  const LocationSearchBar({super.key});

  @override
  State<LocationSearchBar> createState() => _LocationSearchBarState();
}

class _LocationSearchBarState extends State<LocationSearchBar> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    final FlutterFlowTheme theme = FlutterFlowTheme.of(context);

    // TODO: Implement location search functionality
    return SafeArea(
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: theme.secondaryBackground,
          boxShadow: const [
            BoxShadow(
              blurRadius: 4,
              color: Color(0x33000000),
              offset: Offset(0, 2),
            ),
          ],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: TextFormField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: "Search a location...",
              hintStyle: theme.bodyMedium.override(
                fontFamily: "Inter",
                color: theme.secondaryText,
                letterSpacing: 0,
              ),
              prefixIcon: Icon(
                Icons.search,
                color: theme.primaryText,
                size: 24,
              ),
              filled: true,
              fillColor: theme.alternate,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: theme.primary),
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 8),
            ),
            style: theme.bodyMedium.override(
              fontFamily: "Inter",
              letterSpacing: 0,
            ),
          ),
        ),
      ),
    );
  }
}
