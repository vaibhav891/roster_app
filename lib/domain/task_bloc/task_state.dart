// part of 'task_bloc.dart';

// class TaskState extends Equatable {
//   const TaskState({this.isLoading, this.isCheckedIn, this.failure});

//   final bool isLoading;
//   final bool isCheckedIn;
//   final AuthFailure failure;

//   @override
//   List<Object> get props => [isLoading, isCheckedIn, failure];

//   factory TaskState.initial() => TaskState(
//         isLoading: false,
//         isCheckedIn: false,
//         failure: null,
//       );

//   TaskState copyWith({
//     bool isLoading,
//     bool isCheckedIn,
//     AuthFailure failure,
//   }) {
//     return TaskState(
//       isLoading: isLoading ?? this.isLoading,
//       isCheckedIn: isCheckedIn ?? this.isCheckedIn,
//       failure: failure ?? this.failure,
//     );
//   }
// }
