/// Applies the category boxes the tree reports as tapped to [ids], the
/// product's category ids as strings, the way Magento sends them.
///
/// The tree hands over each tapped node already set to its new state:
/// 'checked' is 2 when ticked and 0 when not. The form used to look the
/// node's int id up in the string list, which never matched, so unticking a
/// category added it again and it could not be removed.
void applyCategoryChecks(List<String> ids, List<Map<String, dynamic>> tapped) {
  for (final node in tapped) {
    final id = '${node['id']}';
    ids.removeWhere((existing) => existing == id);
    if (node['checked'] == 2) ids.add(id);
  }
}
