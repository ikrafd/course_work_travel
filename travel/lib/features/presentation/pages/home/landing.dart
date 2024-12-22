import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel/features/presentation/bloc/authentication/user/user_bloc.dart';
import 'package:travel/features/presentation/bloc/landing/landing_page_bloc.dart';
import 'package:travel/features/presentation/bloc/landing/landing_page_event.dart';
import 'package:travel/features/presentation/bloc/landing/landing_page_state.dart';
import 'package:travel/features/presentation/bloc/trip/trip_bloc.dart';
import 'package:travel/features/presentation/pages/home/home.dart';
import 'package:travel/features/presentation/pages/home/my_travel.dart';
import 'package:travel/features/presentation/pages/home/profile.dart';  

List<BottomNavigationBarItem> bottomNavItems = const <BottomNavigationBarItem>[
  BottomNavigationBarItem(
    icon: Icon(Icons.home), 
    label: 'home'
  ),
  BottomNavigationBarItem(
    icon: Icon(Icons.track_changes),
    label: 'my travels'
  ),
  BottomNavigationBarItem(
    icon: Icon(Icons.person), 
    label: 'profile'
  )
];

const List<Widget> bottomNavScreen = <Widget>[
  HomePage(),      
  MyTravelPage(),  
  ProfilePage(), 
];

class LandingPage extends StatelessWidget {
  const LandingPage ({super.key});

  @override
  Widget build(BuildContext context) {
    
    return BlocConsumer<LandingPageBloc, LandingPageState>(
      listener: (context, state) {
        if (state.tabIndex == 2) {
          BlocProvider.of<UserBloc>(context).add(GetUserDataEvent());
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: Center(child: bottomNavScreen.elementAt(state.tabIndex)),
          bottomNavigationBar: BottomNavigationBar(
            items: bottomNavItems,
            currentIndex: state.tabIndex,
            selectedItemColor: Theme.of(context).colorScheme.primary,
            unselectedItemColor: Colors.grey,
            onTap: (index) {
              BlocProvider.of<LandingPageBloc>(context)
                  .add(TabChange(tabIndex: index));
              if (index == 1) {  
                BlocProvider.of<TripBloc>(context, listen: false).add(LoadTrip()); 
              }
              if (index == 2) {  
                BlocProvider.of<UserBloc>(context).add(GetUserDataEvent());
              }
            },
          ),
        );
      },
    ); 
  }
}

