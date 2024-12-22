import 'package:equatable/equatable.dart';

class FileEntity extends Equatable {
  final String? id;
  final String name;
  final String fileUrl;
  final String fileType; 

  const FileEntity({
    this.id = '',
    required this.name,
    required this.fileUrl,
    required this.fileType,
  });

   static FileEntity fromDocument(Map<String, dynamic> doc) {
    return FileEntity(
      id: doc['id'] ?? '',
      name: doc['name'],
      fileUrl: doc['fileUrl'],
      fileType: doc['fileType'],
    );
  }

  Map<String, Object> toDocument() {
    return {
      'id': id ?? '',
      'name': name,
      'fileUrl': fileUrl,
      'fileType': fileType,
    };
  }

  @override
  List<Object?> get props => [
        id,
        name,
        fileUrl,
        fileType,
      ];

  FileEntity copyWith({
    String? id,
    String? name,
    String? fileUrl,
    String? fileType,
  }) {
    return FileEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      fileUrl: fileUrl ?? this.fileUrl,
      fileType: fileType ?? this.fileType,
    );
  }
}
