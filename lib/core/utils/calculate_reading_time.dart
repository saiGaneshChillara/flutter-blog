int calculateReadingTime(String content) {
  final wordCount = content.split(" ").length;

  final readingTime = wordCount / 250;

  return readingTime.ceil();
}