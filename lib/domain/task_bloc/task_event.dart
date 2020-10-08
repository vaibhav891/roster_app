part of 'task_bloc.dart';

class TaskEvent extends Equatable {
  const TaskEvent({@required this.id});

  final String id;

  @override
  List<Object> get props => [id];
}
