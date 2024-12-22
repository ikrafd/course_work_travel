import 'dart:io';

import 'package:travel/features/domain/entities/file.dart';

abstract class FileRepository{
  
  Future<List<FileEntity>> getFiles(String travelId, {String? cityId, String? subCollection});
  Future<void> deleteFile(String travelId, String fileId, {String? cityId, String? subCollection}) ;
  Future<void> updateFilePDF(String travelId, FileEntity file);
  Future<String> uploadFileAndGetUrl(File file, String bucketName, String directoryName);
  Future<void> addFile(String travelId, FileEntity file, {String? cityId, String? subCollection});


}
