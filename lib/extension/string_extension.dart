extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  }

  String nameTrim() {
    return this.split(' ').where((element) => element.isNotEmpty).map((e) =>  e.capitalize()).join(' ');
  }
}
