import 'package:equatable/equatable.dart';
import 'package:travel/features/domain/entities/file.dart';

class FileModel extends Equatable {
  final String id;
  final String name;
  final String fileUrl;
  final String fileType;

  const FileModel({
    required this.id,
    required this.name,
    required this.fileUrl,
    required this.fileType,
  });

  FileEntity toEntity() {
    return FileEntity(
      id: id,
      name: name,
      fileUrl: fileUrl,
      fileType: fileType,
    );
  }

  static FileModel fromEntity(FileEntity entity) {
    return FileModel(
      id: entity.id ?? '',
      name: entity.name,
      fileUrl: entity.fileUrl,
      fileType: entity.fileType,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        fileUrl,
        fileType,
      ];

  FileModel copyWith({
    String? id,
    String? name,
    String? fileUrl,
    String? fileType,
  }) {
    return FileModel(
      id: id ?? this.id,
      name: name ?? this.name,
      fileUrl: fileUrl ?? this.fileUrl,
      fileType: fileType ?? this.fileType,
    );
  }
}
