import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel/core/resources/data_state.dart';
import 'package:travel/core/resources/format_functions.dart';
import 'package:travel/features/presentation/bloc/file/file_bloc.dart';
import 'package:travel/features/presentation/pages/functional/pdf_prview.dart';

class TicketsPage extends StatelessWidget {
  final String tripId;

  const TicketsPage({
    super.key,
    required this.tripId,
  });

  Future<void> _pickAndUploadFile(BuildContext context) async {
    final result = await FilePicker.platform.pickFiles();

    if (result != null && result.files.single.path != null) {
      final file = File(result.files.single.path!);

      BlocProvider.of<FileBloc>(context).add(
        UploadFileEvent(
            travelId: tripId,
            file: file,
            fileName: normalizeFileName(result.files.single.name),
            filetType: 'pdf'),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          BlocProvider.of<FileBloc>(context)..add(FetchFilesEvent(travelId: tripId)),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Files'),
        ),
        body: BlocListener<FileBloc, OperationState>(
          listener: (context, state) {
            if (state is OperationErrorState) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Error'),
                    content: Text(state.errorMessage),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(); 
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  );
                },
              );
            } else if (state is OperationSuccessState) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Success'),
                    content: Text(state.successMessage),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          BlocProvider.of<FileBloc>(context)
                              .add(FetchFilesEvent(travelId: tripId));
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  );
                },
              );
            }
          },
          child: BlocBuilder<FileBloc, OperationState>(
            builder: (context, state) {
              if (state is OperationLoadingState) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is FileLoaded) {
                return ListView.builder(
                  itemCount: state.files.length,
                  itemBuilder: (context, index) {
                    final file = state.files[index];
                    return ListTile(
                      title: Text(file.name),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.open_in_new),
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      PdfViewerPage(fileUrl: file.fileUrl),
                                ),
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              BlocProvider.of<FileBloc>(context).add(
                                DeleteFileEvent(
                                    travelId: tripId, fileId: file.id!),
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              }
              return const Center(child: Text('No files available.'));
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _pickAndUploadFile(context),
          child: const Icon(Icons.upload),
        ),
      ),
    );
  }
}
