
part of 'file_bloc.dart';

abstract class FileState extends Equatable {
  const FileState();

  @override
  List<Object?> get props => [];
}

class FileInitial extends OperationState {}

class FileLoaded extends OperationState {
  final List<FileEntity> files;

  const FileLoaded({required this.files});

  @override
  List<Object?> get props => [files];
}

