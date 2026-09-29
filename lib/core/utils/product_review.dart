/// Whether saving an edit sends a product to the admin for review.
///
/// On an approved (live) product, the backend applies a status change
/// (enable or disable) at once, with no review, and puts any other change
/// in review as Pending Update, which takes the product off the store until
/// the admin approves it (backend, 2026-09-29). The app lists the images and
/// categories on every save, so they count only when they really changed:
/// an image added or removed, or a category ticked or unticked.
bool editGoesToReview({
  required bool live,
  required Iterable<String> changedFields,
  required List<dynamic> images,
  required int savedImageCount,
  required Iterable<dynamic> categoryIds,
  required Iterable<dynamic> savedCategoryIds,
}) {
  if (!live) return false;
  final otherFields = changedFields.any((field) => field != 'status');
  final imagesChanged = images.length != savedImageCount ||
      images.any((image) => image is Map && image.containsKey('content'));
  final ids = categoryIds.map((id) => '$id').toSet();
  final savedIds = savedCategoryIds.map((id) => '$id').toSet();
  final categoriesChanged =
      ids.length != savedIds.length || !ids.containsAll(savedIds);
  return otherFields || imagesChanged || categoriesChanged;
}
