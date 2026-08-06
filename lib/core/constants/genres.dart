/// A story genre. `id` mirrors the backend's `stories.genre` CHECK
/// constraint values exactly (see core-backend migration
/// 0008_stories_genre_status.up.sql) — the two lists are kept in sync by
/// hand, deliberately, since the backend (Go) and frontend (Dart) don't
/// share a codegen source of truth for this enum.
class GenreConfig {
  const GenreConfig({required this.id, required this.labelKey});

  final String id;
  final String labelKey;
}

const List<GenreConfig> kGenres = [
  GenreConfig(id: 'romance', labelKey: 'genres.romance'),
  GenreConfig(id: 'fantasy', labelKey: 'genres.fantasy'),
  GenreConfig(id: 'sci_fi', labelKey: 'genres.sciFi'),
  GenreConfig(id: 'mystery', labelKey: 'genres.mystery'),
  GenreConfig(id: 'drama', labelKey: 'genres.drama'),
  GenreConfig(id: 'slice_of_life', labelKey: 'genres.sliceOfLife'),
  GenreConfig(id: 'horror', labelKey: 'genres.horror'),
  GenreConfig(id: 'adventure', labelKey: 'genres.adventure'),
];

/// Looks up a genre's localization key by its backend id, falling back to
/// the raw id itself if the backend ever returns a value not in [kGenres]
/// (e.g. a genre added server-side before the client catalog is updated).
String genreLabelKeyFor(String genreId) {
  for (final genre in kGenres) {
    if (genre.id == genreId) return genre.labelKey;
  }
  return genreId;
}
