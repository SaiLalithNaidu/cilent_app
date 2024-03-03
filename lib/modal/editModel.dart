class EditedModelStatus {
  String? docId;
  late String imageUrl;
  String title;
  String descriptionOrMessage;

  EditedModelStatus(
      this.docId, this.imageUrl, this.title, this.descriptionOrMessage);
  Map<String, dynamic> toMap() {
    return {
      'docId': docId,
      'imageUrl': imageUrl,
      'title': title,
      'descriptionOrMessage': descriptionOrMessage,
    };
  }
}
