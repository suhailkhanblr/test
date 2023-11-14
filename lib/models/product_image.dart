import 'dart:io';

class ProductImage {
  String? url;
  String? urlPrefix;
  File? file;
  bool isLocal;

  ProductImage({
    this.file,
    this.url,
    this.urlPrefix,
    required this.isLocal,
  });
}
