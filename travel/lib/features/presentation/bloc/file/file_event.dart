// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'file_bloc.dart';

abstract class FileEvent extends Equatable {
  const FileEvent();

  @override
  List<Object?> get props => [];
}

class AddFileEvent extends FileEvent {
  final String travelId;
  final FileEntity file;

  const AddFileEvent({
    required this.travelId,
    required this.file,
  });

  @override
  List<Object?> get props => [travelId, file];
}

class FetchFilesEvent extends FileEvent {
  final String travelId;
  final String? cityId;
  final String? subCollection;

  const FetchFilesEvent({
    required this.travelId,
    this.cityId,
    this.subCollection,
  });

  @override
  List<Object?> get props => [travelId, cityId, subCollection];
}

class DeleteFileEvent extends FileEvent {
  final String travelId;
  final String fileId;
  final String? cityId;
  final String? subCollection;

  const DeleteFileEvent({
    required this.travelId,
    required this.fileId,
    this.cityId,
    this.subCollection,
  });

  @override
  List<Object?> get props => [travelId, fileId];
}

class UploadFileEvent extends FileEvent {
  final String travelId;
  final String? cityId;
  final File file;
  final String fileName;
  final String filetType;

  const UploadFileEvent(
    {
    required this.travelId,
    this.cityId,  
    required this.file,
    required this.fileName,
    required this.filetType
  });

  @override
  List<Object?> get props => [travelId, cityId, file, fileName];
}
