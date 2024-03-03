class CreateFolderNotification {
  bool? imagesUploaded;

  bool? documentsAnalyzed;

  CreateFolderNotification(
      {this.imagesUploaded, this.documentsAnalyzed});

  factory CreateFolderNotification.fromMap(Map<String, dynamic> map) {
    return CreateFolderNotification(
      imagesUploaded: map['imagesUploaded'],
      documentsAnalyzed: map['documentsAnalyzed'],
    );
  }
}
