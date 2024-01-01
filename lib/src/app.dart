import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:myclasses/src/app_routes.dart';
import 'package:myclasses/src/utils/firebase/listeners/auth_listener.dart';
import 'package:myclasses/src/utils/localization/l10n.dart';
import 'package:myclasses/src/utils/material_theme/color_schemes.g.dart';

import 'settings/settings_controller.dart';

/// The Widget that configures your application.
class MyApp extends StatefulWidget {
  const MyApp({
    super.key,
    required this.settingsController,
  });

  final SettingsController settingsController;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    AuthListener.loginListener();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
      final theme = Theme.of(context);
      return RedErrorWidget(theme: theme, errorDetails: errorDetails);
    };

    // Glue the SettingsController to the MaterialApp.
    //
    // The ListenableBuilder Widget listens to the SettingsController for changes.
    // Whenever the user updates their settings, the MaterialApp is rebuilt.

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: ListenableBuilder(
        listenable: widget.settingsController,
        builder: (BuildContext context, Widget? child) {
          return LayoutBuilder(builder: (context, constraints) {
            double? width;
            if (kIsWeb) {
              if (constraints.maxWidth > 600) {
                width = 600;
              }
            }
            return Center(
              child: SizedBox(
                width: width,
                child: MaterialApp.router(
                  // Providing a restorationScopeId allows the Navigator built by the
                  // MaterialApp to restore the navigation stack when a user leaves and
                  // returns to the app after it has been killed while running in the
                  // background.
                  restorationScopeId: 'app',
                  localizationsDelegates: const [
                    AppLocalizations.delegate,
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                  ],
                  supportedLocales: const [
                    Locale('pt', 'BR'),
                  ],
                  onGenerateTitle: (BuildContext context) =>
                      AppLocalizations.of(context).appTitle,
                  theme: ThemeData(
                    useMaterial3: true,
                    colorScheme: lightColorScheme,
                    fontFamily: 'RobotoMono',
                  ),
                  darkTheme: ThemeData(
                    useMaterial3: true,
                    colorScheme: darkColorScheme,
                    fontFamily: 'RobotoMono',
                  ),
                  themeMode: widget.settingsController.themeMode,

                  routerConfig: AppRoutes.router,
                ),
              ),
            );
          });
        },
      ),
    );
  }
}

class RedErrorWidget extends StatefulWidget {
  const RedErrorWidget({
    super.key,
    required this.theme,
    required this.errorDetails,
  });

  final ThemeData theme;
  final FlutterErrorDetails errorDetails;

  @override
  State<RedErrorWidget> createState() => _RedErrorWidgetState();
}

class _RedErrorWidgetState extends State<RedErrorWidget> {
  bool isOpen = false;
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: Card(
          margin: const EdgeInsets.all(16),
          color: widget.theme.colorScheme.onError,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ExpansionPanelList(
                  expansionCallback: (panelIndex, isExpanded) => setState(() {
                    isOpen = isExpanded;
                  }),
                  children: [
                    ExpansionPanel(
                      isExpanded: isOpen,
                      headerBuilder: (context, expanded) => Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Erro:',
                            style: widget.theme.textTheme.bodyLarge?.copyWith(
                                color: widget.theme.colorScheme.error),
                          ),
                        ),
                      ),
                      body: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          widget.errorDetails.exceptionAsString(),
                          style: widget.theme.textTheme.bodyMedium
                              ?.copyWith(color: widget.theme.colorScheme.error),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Center(
                  child: OutlinedButton(
                    onPressed: () => context.pushNamed('/'),
                    child: Text(
                      'Reload',
                      style: widget.theme.textTheme.bodyLarge
                          ?.copyWith(color: widget.theme.colorScheme.error),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
