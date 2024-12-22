import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel/core/resources/data_state.dart';
import 'package:travel/core/resources/format_functions.dart';
import 'package:travel/features/domain/entities/file.dart';
import 'package:travel/features/domain/repository/file_repository.dart';

part 'file_event.dart';
part 'file_state.dart';


class FileBloc extends Bloc<FileEvent, OperationState> {
  final FileRepository _fileRepository;

  FileBloc(this._fileRepository)
     : super(OperationLoadingState()){
    on<AddFileEvent>((event, emit) async {
      try {
      emit(OperationLoadingState());
      await _fileRepository.addFile(event.travelId, event.file);

      add(FetchFilesEvent(travelId: event.travelId));
    } catch (e) {
      emit(OperationErrorState( e.toString()));
    }
    });
    on<FetchFilesEvent>((event, emit) async {
      try {
      emit(OperationLoadingState());
      final files = await _fileRepository.getFiles(event.travelId, cityId: event.cityId, subCollection: event.subCollection);
      emit(FileLoaded(files: files));
    } catch (e) {
      emit(OperationErrorState(e.toString()));
    }
    });
    on<DeleteFileEvent>((event, emit) async {
      try {
      emit(OperationLoadingState());

      await _fileRepository.deleteFile(event.travelId, event.fileId, cityId: event.cityId, subCollection: event.subCollection);
      add(FetchFilesEvent(travelId: event.travelId));
    } catch (e) {
      emit(OperationErrorState(e.toString()));
    }
    });
    
    on<UploadFileEvent>((event, emit) async {
  try {
    emit(OperationLoadingState());

    final formatMap = {
      'pdf': ['pdf'],
      'photo': ['jpg', 'jpeg', 'png'],
    };

    final directoryMap = {
      'pdf': 'tickets',
      'photo': 'photos',
    };

    final supportedFormats = formatMap[event.filetType] ?? [];
    final directory = directoryMap[event.filetType] ?? '';

    if (!isSupportedFormat(event.fileName, supportedFormats)) {
      throw Exception('Unsupported format: ${event.fileName}');
    }

    final fileUrl = await _fileRepository.uploadFileAndGetUrl(
      event.file,
      'files',
      directory,
    );

    final fileEntity = FileEntity(
      name: event.fileName,
      fileUrl: fileUrl,
      fileType: event.filetType,
    );

    if (event.filetType == 'pdf') {
      await _fileRepository.addFile(event.travelId, fileEntity);
      add(FetchFilesEvent(travelId: event.travelId));
    } else if (event.filetType == 'photo') {
      if (event.cityId == null) {
        throw Exception('City ID is required for photos');
      }
      await _fileRepository.addFile(
        event.travelId,
        fileEntity,
        cityId: event.cityId,
        subCollection: 'Photos',
      );
      add(FetchFilesEvent(travelId: event.travelId, cityId: event.cityId, subCollection: 'Photos'));
    }

    
  } catch (e) {
    emit(OperationErrorState(e.toString()));
  }
});



  }

}
