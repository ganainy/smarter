class Event {
  final String url;

//<editor-fold desc="Data Methods">

  const Event({
    required this.url,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Event && runtimeType == other.runtimeType && url == other.url);

  @override
  int get hashCode => url.hashCode;

  @override
  String toString() {
    return 'Event{' + ' url: $url,' + '}';
  }

  Event copyWith({
    String? url,
  }) {
    return Event(
      url: url ?? this.url,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'url': this.url,
    };
  }

  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      url: map['url'] as String,
    );
  }

//</editor-fold>
}
