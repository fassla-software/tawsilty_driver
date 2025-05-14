

extension StringExtension on String {
  String toCapitalized() => length > 0 ?'${this[0].toUpperCase()}${substring(1).toLowerCase()}':'';
  String toTitleCase() => replaceAll(RegExp('_'), ' ').split(' ').map((str) => str.toCapitalized()).join(' ');

  String camelCaseToSnakeCase() {
    return replaceAllMapped(
        RegExp(r'([A-Z])'),
            (Match match) =>
        "_${match.group(1)!.toLowerCase()}");
  }
}