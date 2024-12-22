import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel/core/resources/data_state.dart';
import 'package:travel/features/domain/entities/user.dart';
import 'package:travel/features/presentation/bloc/authentication/user/user_bloc.dart';
import 'package:travel/features/presentation/pages/authorization/welcome.dart';
import 'package:travel/features/presentation/widgets/decoration/app_bar.dart';
import 'package:travel/features/presentation/widgets/decoration/gradient.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppbar(),
      body: Container(
        decoration: getGradientDecoration(),
        child: BlocBuilder<UserBloc, OperationState>(
          builder: (context, state) {
            if (state is UserLoadingState) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is UserSuccessState) {
              final user = state.user;
              return _buildProfileContent(user, context);
            } else if (state is UserErrorState) {
              return Center(child: Text('Error: ${state.errorMessage}'));
            } else if (state is OperationSuccessState &&
                state.successMessage == 'User logged out successfully') {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const WelcomePage(),
                  ),
                );
              });
              return const Center(child: CircularProgressIndicator());
            }
            return const Center(child: Text('Unknown state'));
          },
        ),
      ),
    );
  }

  Widget _buildProfileContent(UserEntity user, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user.name,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                user.email,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              context.read<UserBloc>().add(LogOutEvent());
            },
            child: const Text('Log Out'),
          ),

          const SizedBox(height: 16),
          Expanded(
            child: _buildUserAchievements(user),
          ),
        ],
      ),
    );
  }

  Widget _buildUserAchievements(UserEntity user) {
    return ListView(
      children: [
        _buildAchievementCard('Trips Count', user.tripsCount, 5),
        _buildAchievementCard('Visited Places', user.visitedPlacesCount, 3),
        _buildAchievementCard('Spent Money', user.spentMoney.toInt(), 1000),
        _buildAchievementCard('Cities Count', user.citiesCount, 10),
      ],
    );
  }

  Widget _buildAchievementCard(String title, int userValue, int targetValue) {
    bool isAchieved = userValue >= targetValue;

    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: isAchieved ? Colors.green.shade100 : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$userValue / $targetValue',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isAchieved ? Colors.green : Colors.grey.shade600,
                  ),
                ),
              ],
            ),
            Icon(
              isAchieved ? Icons.check_circle : Icons.radio_button_unchecked,
              color: isAchieved ? Colors.green : Colors.grey,
              size: 28,
            ),
          ],
        ),
      ),
    );
  }
}
