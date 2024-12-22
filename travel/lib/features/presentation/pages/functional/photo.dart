import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel/core/resources/data_state.dart';
import 'package:travel/core/resources/format_functions.dart';
import 'package:travel/features/presentation/bloc/file/file_bloc.dart';

class PhotoPage extends StatelessWidget {
  final String tripId;
  final String cityId;

  const PhotoPage({
    super.key,
    required this.cityId,
    required this.tripId,
  });

  Future<void> _pickAndUploadFile(BuildContext context) async {
    final result = await FilePicker.platform.pickFiles();

    if (result != null && result.files.single.path != null) {
      final file = File(result.files.single.path!);
      if (context.mounted) {
      BlocProvider.of<FileBloc>(context).add(
        UploadFileEvent(
            travelId: tripId,
            cityId: cityId,
            file: file,
            fileName: normalizeFileName(result.files.single.name),
            filetType: 'photo'),
      );
      }
    }
  }

  @override
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          BlocProvider.of<FileBloc>(context)..add(FetchFilesEvent(travelId: tripId, cityId: cityId, subCollection: 'Photos')),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Gallery'),
        ),
        body: BlocBuilder<FileBloc, OperationState>(
          builder: (context, state) {
            if (state is OperationLoadingState) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is FileLoaded) {
              final photos = state.files.where((file) => file.fileType == 'photo').toList();

              if (photos.isEmpty) {
                return const Center(child: Text('Немає фото'));
              }

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, 
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 1,
                  ),
                  itemCount: photos.length,
                  itemBuilder: (context, index) {
                    final photo = photos[index];
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Stack(
                        children: [
                          Image.network(
                            photo.fileUrl,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          ),
                          Positioned(
                            top: 4,
                            right: 4,
                            child: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                BlocProvider.of<FileBloc>(context).add(
                                  DeleteFileEvent(
                                      travelId: tripId, fileId: photo.id!, cityId: cityId, subCollection: 'Photos'),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            }
            return const Center(child: Text('Немає файлів'));
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _pickAndUploadFile(context),
          child: const Icon(Icons.upload),
        ),
      ),
    );
  }
}