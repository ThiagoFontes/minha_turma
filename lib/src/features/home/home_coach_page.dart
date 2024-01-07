import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myclasses/src/features/home/home_notifier.dart';
import 'package:myclasses/src/features/home/vmodels/cards_home_vmodel.dart';
import 'package:myclasses/src/features/home/widgets/profile_app_bar.dart';
import 'package:myclasses/src/features/home/widgets/square_button.dart';
import 'package:myclasses/src/utils/firebase/models/user_model.dart';
import 'package:myclasses/src/utils/material_theme/theme_extension.dart';
import 'package:myclasses/src/utils/widgets/error/messages.dart';

class HomeCoachPage extends StatefulWidget {
  static const String route = '/home_coach';

  const HomeCoachPage({super.key});

  @override
  State<HomeCoachPage> createState() => _HomeCoachPageState();
}

class _HomeCoachPageState extends State<HomeCoachPage> {
  @override
  void initState() {
    context.read<HomeNotifier>().initHome();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    context.read<HomeNotifier>().onBuild();

    final isAdmin = context.select<HomeNotifier, bool>(
      (notifier) => notifier.user?.roles.contains('admin') ?? false,
    );

    final user = context.select<HomeNotifier, UserModel?>(
      (notifier) => notifier.user,
    );

    final cardsToShow = List<CardsHomeVModel>.from(
      context.select<HomeNotifier, List<CardsHomeVModel>>(
        (notifier) => notifier.cards,
      ),
    );

    cardsToShow.removeWhere(
      (card) {
        if (card.roles.isEmpty) return false;

        return !card.roles.any(
          (element) => (user?.roles ?? []).contains(element),
        );
      },
    );

    return Scaffold(
      appBar: ProfileAppBar(
        displayName: user?.name,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 8,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Gerenciar',
                style: context.theme.textTheme.titleSmall,
              ),
              const SizedBox(height: 16),
              GridView.count(
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 24,
                crossAxisSpacing: 24,
                shrinkWrap: true,
                crossAxisCount: 2,
                childAspectRatio: 2 / 1,
                children: List.generate(
                  cardsToShow.length,
                  (index) => CardButton(
                    cardVModel: cardsToShow[index],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              const CheckGoalsWidget(),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   items: const <BottomNavigationBarItem>[
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.home),
      //       label: 'Home',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.auto_graph),
      //       label: 'Ranking',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.settings),
      //       label: 'Settings',
      //     ),
      //   ],
      //   selectedItemColor: theme.colorScheme.primary,
      //   unselectedItemColor: theme.colorScheme.onBackground,
      //   backgroundColor: theme.colorScheme.background,
      // ),
    );
  }
}

class CheckGoalsWidget extends StatelessWidget {
  const CheckGoalsWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: Messages.todo,
      child: Card(
        color: context.theme.colorScheme.primaryContainer,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CircularProgressIndicator(
                value: 0.3,
                backgroundColor: context.theme.canvasColor.withOpacity(0.5),
              ),
              const SizedBox(width: 16),
              Flexible(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Não esqueça de conferir suas metas',
                      style: context.theme.textTheme.titleMedium,
                    ),
                    const Text('10 de 30 concluídas'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
