import 'package:json_annotation/json_annotation.dart';

part 'api_response.g.dart';

@JsonSerializable(genericArgumentFactories: true, createToJson: false)
class PaginatedResponse<T> {
  final int page;
  final int size;
  final int totalElements;
  final int totalPages;
  final List<T> content;

  const PaginatedResponse({
    required this.page,
    required this.size,
    required this.totalElements,
    required this.totalPages,
    required this.content,
  });

  factory PaginatedResponse.fromJson(Map<String, dynamic> json, T Function(Object? json) fromJsonT) =>
      _$PaginatedResponseFromJson(json, fromJsonT);
}

@JsonSerializable(genericArgumentFactories: true, createToJson: false)
class ApiResponse<T> {
  final T data;
  String? message;

  ApiResponse({required this.data, this.message});

  factory ApiResponse.fromJson(Map<String, dynamic> json, T Function(Object?) fromJsonT) => _$ApiResponseFromJson(json, fromJsonT);
}