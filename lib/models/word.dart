class Word {
  final String term;
  final String translation;
  final String partOfSpeech;
  final String example;
  final String english;
  final String exampleSentence;
  final String pronunciation;
  final String category;
  final String indonesian;

  Word({
    required this.term,
    required this.translation,
    required this.partOfSpeech,
    required this.example,
    String? english,
    String? exampleSentence,
    String? pronunciation,
    String? category,
    String? indonesian,
  }) : english = english ?? term, // Use term as english if not provided
       exampleSentence = exampleSentence ?? example, // Use example as exampleSentence if not provided
       pronunciation = pronunciation ?? '/$term/', // Default pronunciation format
       category = category ?? partOfSpeech, // Use partOfSpeech as category if not provided
       indonesian = indonesian ?? translation; // Use translation as indonesian if not provided
}