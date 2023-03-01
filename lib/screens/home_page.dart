import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workout_buddy/blocs/workout_cubit.dart';
import 'package:workout_buddy/helpers.dart';

import '../blocs/workouts_cubit.dart';
import '../models/workout.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: NetworkImage("https://wallpaperaccess.com/full/1244717.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.black45,
        appBar: AppBar(
          title: Text("Workout Time!"),
          actions: [
            IconButton(onPressed: () {}, icon: Icon(Icons.event_available)),
            IconButton(onPressed: () {}, icon: Icon(Icons.settings)),
          ],
        ),
        body: SingleChildScrollView(
          child: BlocBuilder<WorkoutsCubit, List<Workout>>(
            builder: (context, workouts) => Card(
              margin: EdgeInsets.all(10),
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              color: Colors.transparent,
              elevation: 2,
              child: ExpansionPanelList.radio(
                elevation: 3,
                children: workouts
                    .map(
                      (workout) => ExpansionPanelRadio(
                        backgroundColor: Colors.white38,
                        value: workout,
                        headerBuilder: (context, isExpanded) => ListTile(
                          visualDensity: VisualDensity(
                            horizontal: 0,
                            vertical: VisualDensity.maximumDensity,
                          ),
                          leading: IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () =>
                                BlocProvider.of<WorkoutCubit>(context)
                                    .editWorkout(
                              workout,
                              workouts.indexOf(workout),
                            ),
                          ),
                          title: Text(workout.title!),
                          trailing: Text(formatTime(workout.getTotal(), true)),
                          onTap: () => !isExpanded
                              ? BlocProvider.of<WorkoutCubit>(context)
                                  .startWorkout(workout)
                              : null,
                        ),
                        body: ListView.builder(
                          shrinkWrap: true,
                          itemCount: workout.exercises.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ListTile(
                              onTap: () {},
                              visualDensity: VisualDensity(
                                horizontal: 0,
                                vertical: VisualDensity.maximumDensity,
                              ),
                              leading: Text(formatTime(
                                  workout.exercises[index].prelude!, true)),
                              title: Text(
                                workout.exercises[index].title!,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                              trailing: Text(formatTime(
                                  workout.exercises[index].duration!, true)),
                            );
                          },
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
