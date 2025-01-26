extension IterableExtensions<T extends dynamic> on Iterable<T> {
  ///MARK: - Get List Item with index safely
  T? getIterableItem(int index) => (length > index) ? elementAt(index) : null;
}
