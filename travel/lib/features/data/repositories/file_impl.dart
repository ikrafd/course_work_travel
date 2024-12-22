import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:travel/features/data/data_sources/firebase_service.dart';
import 'package:travel/features/domain/entities/file.dart';
import 'package:travel/features/domain/repository/file_repository.dart';

class FileRepositoryImpl implements FileRepository{
  final FirebaseFirestore _firestore = FirebaseService().firestore;
  final AuthService _authService;


  FileRepositoryImpl (this._authService);

  CollectionReference _fileCollection(String travelId, {String? cityId, String? subCollection}) {
    String userId = _authService.getUserId();
    var collection = _firestore.collection('user').doc(userId).collection('Trips').doc(travelId);

    if (cityId != null && subCollection != null) {
      return collection.collection('Cities').doc(cityId).collection(subCollection);
    }

    return collection.collection('Tickets'); 
  }

  @override
  Future<void> addFile(String travelId, FileEntity file, {String? cityId, String? subCollection}) async {
    try {
    DocumentReference fileRef = await _fileCollection(travelId, cityId: cityId, subCollection: subCollection).add(file.toDocument());

    await fileRef.update({'fileID': fileRef.id});
    } catch (e) {
      throw Exception('Failed to add file: $e');
    }
  }

  @override
  Future<List<FileEntity>> getFiles(String travelId, {String? cityId, String? subCollection}) async {
    try {
      final snapshot = await _fileCollection(travelId, cityId: cityId, subCollection: subCollection).get();
      return snapshot.docs.map((doc) {
        return FileEntity.fromDocument(doc.data() as Map<String, dynamic>).copyWith(id: doc.id);
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch files: $e');
    }
  }

  @override
  Future<void> deleteFile(String travelId, String fileId, {String? cityId, String? subCollection}) async {
    try {
      await _fileCollection(travelId, cityId: cityId, subCollection: subCollection).doc(fileId).delete();
    } catch (e) {
      throw Exception('Failed to delete file: $e');
    }
  }

  @override
  Future<void> updateFilePDF(String travelId, FileEntity file) async {
    if (file.id == null || file.id!.isEmpty) {
      throw Exception('File ID is required for updating');
    }
    try {
      await _fileCollection(travelId).doc(file.id).update(file.toDocument());
    } catch (e) {
      throw Exception('Failed to update file: $e');
    }
  }

  @override
  Future<String> uploadFileAndGetUrl(File file, String bucketName, String directoryName) async {
   try {
    final supabase = Supabase.instance.client;

    final filePath = '$bucketName/$directoryName/${file.uri.pathSegments.last}';
    final response = await supabase.storage.from(bucketName).upload(filePath, file);

    if (response.isEmpty) {
      throw Exception('Failed to upload file.');
    }
    final url = supabase.storage.from(bucketName).getPublicUrl(filePath);
    return url;
  } catch (e) {
    throw Exception('Error uploading file: $e');
  }
}

  
}

