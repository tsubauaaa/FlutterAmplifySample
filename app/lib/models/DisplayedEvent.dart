class DisplayedEvent {
  final String id;
  final String name;
  final String? description;
  final String? imageUrl;

  DisplayedEvent({
    required this.id,
    required this.name,
    this.description,
    this.imageUrl,
  });
}
