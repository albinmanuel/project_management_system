class Batch {
  final String batchId;
  final String batchTitle;

  Batch({required this.batchId, required this.batchTitle});

  factory Batch.fromJson(Map<String, dynamic> json) {
    return Batch(
      batchId: (json['batch_id'].toString()),
      batchTitle: json['batch_title'],
    );
  }
}