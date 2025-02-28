// Format date string to month abbreviation and day
String dateFormatString(String dateString) {
  try {
    // Check if already in the correct format (like "Feb 28")
    if (dateString.contains(" ")) {
      return dateString;
    }

    List<String> parts = dateString.split('/');
    if (parts.length != 2) return dateString;

    int month = int.tryParse(parts[0]) ?? 1;
    int day = int.tryParse(parts[1]) ?? 1;

    List<String> monthNames = [
      'Jan', //TODO: lang
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];

    return "${monthNames[month - 1]} $day";
  } catch (e) {
    return dateString;
  }
}

  // Format the date as month abbreviation + day
String dateFormatDateTime(DateTime pickedDate) {
  // TODO: lang
  List<String> monthNames = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];

  return "${monthNames[pickedDate.month - 1]} ${pickedDate.day}";
}