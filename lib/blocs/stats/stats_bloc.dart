import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_todos/blocs/stats/stats_event.dart';
import 'package:flutter_todos/blocs/stats/stats_state.dart';
import 'package:flutter_todos/blocs/todos/todos.dart';

class StatsBloc extends Bloc<StatsEvent, StatsState>{
  final TodosBloc todosBloc;
  StreamSubscription todosSubscription;

  StatsBloc({@required this.todosBloc}) : super(StatsLoadInProgess()) {
    todosSubscription = todosBloc.listen((state) {
      if (state is TodosLoadSuccess) {
        add(StatsUpdated(state.todos));
      }
    });
  }

  @override
  Stream<StatsState> mapEventToState(StatsEvent event) async*{
    if(event is StatsUpdated){
      int numActive = event.todos.where((todo) => !todo.complete).toList().length;
      int numCompleted = event.todos.where((todo) => todo.complete).toList().length;
      yield StatsLoadSuccess(numActive, numCompleted);
    }
  }

  @override
  Future<void> close() {
    todosSubscription.cancel();
    return super.close();
  }

}