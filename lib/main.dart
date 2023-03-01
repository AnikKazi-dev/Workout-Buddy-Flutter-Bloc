import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:workout_buddy/blocs/workouts_cubit.dart';
import 'package:workout_buddy/blocs/workout_cubit.dart';
import 'package:workout_buddy/screens/edit_workout_screen.dart';
import 'package:workout_buddy/screens/home_page.dart';
import 'package:workout_buddy/screens/workout_progress.dart';
import 'package:workout_buddy/states/workout_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final storage = await HydratedStorage.build(
    storageDirectory: await getApplicationDocumentsDirectory(),
  );

  HydratedBlocOverrides.runZoned(
    () => runApp(const MyApp()),
    storage: storage,
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Workout Buddy',
      theme: ThemeData(
        primarySwatch: Colors.grey,
        textTheme: const TextTheme(
          bodyText2: TextStyle(color: Color.fromARGB(255, 66, 74, 96)),
        ),
      ),
      home: MultiBlocProvider(
        providers: [
          BlocProvider<WorkoutsCubit>(
            create: (BuildContext context) {
              WorkoutsCubit workoutsCubit = WorkoutsCubit();
              if (workoutsCubit.state.isEmpty) {
                workoutsCubit.getWorkouts();
              } else {}
              return workoutsCubit;
            },
          ),
          BlocProvider<WorkoutCubit>(
            create: (BuildContext context) => WorkoutCubit(),
          ),
        ],
        child: BlocBuilder<WorkoutCubit, WorkoutState>(
          builder: (context, state) {
            if (state is WorkoutInitial) {
              return HomePage();
            } else if (state is WorkoutEditing) {
              return EditWorkoutScreen();
            }
            return WorkoutProgress();
          },
        ),
      ),
    );
  }
}
