/// A data class representing all information related to
/// a bet with an associated image URL.
class DataBet {
  final String id;
  final String imgUrl;
  final String? metadata;

  DataBet({
    required this.id,
    required this.imgUrl,
    this.metadata,
  });
}
