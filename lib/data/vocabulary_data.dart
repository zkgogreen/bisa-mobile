import '../models/word.dart';

/// Data vocabulary lengkap dengan berbagai kategori
/// Berisi kata-kata umum yang sering digunakan dalam pembelajaran bahasa Inggris
class VocabularyData {
  static List<Word> getAllWords() {
    return [
      // === GREETINGS & BASIC PHRASES ===
      Word(
        term: 'Hello',
        translation: 'Halo',
        partOfSpeech: 'interjection',
        example: 'Hello, how are you today?',
        pronunciation: '/həˈloʊ/',
        category: 'Greetings',
      ),
      Word(
        term: 'Goodbye',
        translation: 'Selamat tinggal',
        partOfSpeech: 'interjection',
        example: 'Goodbye, see you tomorrow!',
        pronunciation: '/ɡʊdˈbaɪ/',
        category: 'Greetings',
      ),
      Word(
        term: 'Thank you',
        translation: 'Terima kasih',
        partOfSpeech: 'phrase',
        example: 'Thank you for your help.',
        pronunciation: '/θæŋk juː/',
        category: 'Greetings',
      ),
      Word(
        term: 'Please',
        translation: 'Tolong/Silakan',
        partOfSpeech: 'adverb',
        example: 'Please help me with this.',
        pronunciation: '/pliːz/',
        category: 'Greetings',
      ),
      Word(
        term: 'Excuse me',
        translation: 'Permisi',
        partOfSpeech: 'phrase',
        example: 'Excuse me, where is the library?',
        pronunciation: '/ɪkˈskjuːz miː/',
        category: 'Greetings',
      ),

      // === FAMILY & RELATIONSHIPS ===
      Word(
        term: 'Mother',
        translation: 'Ibu',
        partOfSpeech: 'noun',
        example: 'My mother is a teacher.',
        pronunciation: '/ˈmʌðər/',
        category: 'Family',
      ),
      Word(
        term: 'Father',
        translation: 'Ayah',
        partOfSpeech: 'noun',
        example: 'My father works in an office.',
        pronunciation: '/ˈfɑːðər/',
        category: 'Family',
      ),
      Word(
        term: 'Sister',
        translation: 'Saudara perempuan',
        partOfSpeech: 'noun',
        example: 'I have one younger sister.',
        pronunciation: '/ˈsɪstər/',
        category: 'Family',
      ),
      Word(
        term: 'Brother',
        translation: 'Saudara laki-laki',
        partOfSpeech: 'noun',
        example: 'My brother is studying medicine.',
        pronunciation: '/ˈbrʌðər/',
        category: 'Family',
      ),
      Word(
        term: 'Friend',
        translation: 'Teman',
        partOfSpeech: 'noun',
        example: 'She is my best friend.',
        pronunciation: '/frend/',
        category: 'Family',
      ),

      // === FOOD & DRINKS ===
      Word(
        term: 'Apple',
        translation: 'Apel',
        partOfSpeech: 'noun',
        example: 'I eat an apple every day.',
        pronunciation: '/ˈæpəl/',
        category: 'Food',
      ),
      Word(
        term: 'Water',
        translation: 'Air',
        partOfSpeech: 'noun',
        example: 'Please drink more water.',
        pronunciation: '/ˈwɔːtər/',
        category: 'Food',
      ),
      Word(
        term: 'Rice',
        translation: 'Nasi',
        partOfSpeech: 'noun',
        example: 'We eat rice for lunch.',
        pronunciation: '/raɪs/',
        category: 'Food',
      ),
      Word(
        term: 'Coffee',
        translation: 'Kopi',
        partOfSpeech: 'noun',
        example: 'I drink coffee in the morning.',
        pronunciation: '/ˈkɔːfi/',
        category: 'Food',
      ),
      Word(
        term: 'Bread',
        translation: 'Roti',
        partOfSpeech: 'noun',
        example: 'She bought fresh bread from the bakery.',
        pronunciation: '/bred/',
        category: 'Food',
      ),

      // === ANIMALS ===
      Word(
        term: 'Cat',
        translation: 'Kucing',
        partOfSpeech: 'noun',
        example: 'The cat is sleeping on the sofa.',
        pronunciation: '/kæt/',
        category: 'Animals',
      ),
      Word(
        term: 'Dog',
        translation: 'Anjing',
        partOfSpeech: 'noun',
        example: 'My dog loves to play fetch.',
        pronunciation: '/dɔːɡ/',
        category: 'Animals',
      ),
      Word(
        term: 'Bird',
        translation: 'Burung',
        partOfSpeech: 'noun',
        example: 'The bird is singing beautifully.',
        pronunciation: '/bɜːrd/',
        category: 'Animals',
      ),
      Word(
        term: 'Fish',
        translation: 'Ikan',
        partOfSpeech: 'noun',
        example: 'We saw colorful fish in the aquarium.',
        pronunciation: '/fɪʃ/',
        category: 'Animals',
      ),
      Word(
        term: 'Elephant',
        translation: 'Gajah',
        partOfSpeech: 'noun',
        example: 'The elephant is the largest land animal.',
        pronunciation: '/ˈeləfənt/',
        category: 'Animals',
      ),

      // === COLORS ===
      Word(
        term: 'Red',
        translation: 'Merah',
        partOfSpeech: 'adjective',
        example: 'She wore a red dress to the party.',
        pronunciation: '/red/',
        category: 'Colors',
      ),
      Word(
        term: 'Blue',
        translation: 'Biru',
        partOfSpeech: 'adjective',
        example: 'The sky is blue today.',
        pronunciation: '/bluː/',
        category: 'Colors',
      ),
      Word(
        term: 'Green',
        translation: 'Hijau',
        partOfSpeech: 'adjective',
        example: 'The grass is green in spring.',
        pronunciation: '/ɡriːn/',
        category: 'Colors',
      ),
      Word(
        term: 'Yellow',
        translation: 'Kuning',
        partOfSpeech: 'adjective',
        example: 'The sun looks yellow in the morning.',
        pronunciation: '/ˈjeloʊ/',
        category: 'Colors',
      ),
      Word(
        term: 'Black',
        translation: 'Hitam',
        partOfSpeech: 'adjective',
        example: 'He drives a black car.',
        pronunciation: '/blæk/',
        category: 'Colors',
      ),

      // === NUMBERS ===
      Word(
        term: 'One',
        translation: 'Satu',
        partOfSpeech: 'number',
        example: 'I have one book.',
        pronunciation: '/wʌn/',
        category: 'Numbers',
      ),
      Word(
        term: 'Two',
        translation: 'Dua',
        partOfSpeech: 'number',
        example: 'There are two cats in the garden.',
        pronunciation: '/tuː/',
        category: 'Numbers',
      ),
      Word(
        term: 'Three',
        translation: 'Tiga',
        partOfSpeech: 'number',
        example: 'I bought three apples.',
        pronunciation: '/θriː/',
        category: 'Numbers',
      ),
      Word(
        term: 'Ten',
        translation: 'Sepuluh',
        partOfSpeech: 'number',
        example: 'The class starts at ten o\'clock.',
        pronunciation: '/ten/',
        category: 'Numbers',
      ),
      Word(
        term: 'Hundred',
        translation: 'Seratus',
        partOfSpeech: 'number',
        example: 'There are one hundred students in the school.',
        pronunciation: '/ˈhʌndrəd/',
        category: 'Numbers',
      ),

      // === SCHOOL & EDUCATION ===
      Word(
        term: 'Book',
        translation: 'Buku',
        partOfSpeech: 'noun',
        example: 'I read a book every night.',
        pronunciation: '/bʊk/',
        category: 'Education',
      ),
      Word(
        term: 'School',
        translation: 'Sekolah',
        partOfSpeech: 'noun',
        example: 'Children go to school to learn.',
        pronunciation: '/skuːl/',
        category: 'Education',
      ),
      Word(
        term: 'Teacher',
        translation: 'Guru',
        partOfSpeech: 'noun',
        example: 'Our teacher is very kind.',
        pronunciation: '/ˈtiːtʃər/',
        category: 'Education',
      ),
      Word(
        term: 'Student',
        translation: 'Siswa/Mahasiswa',
        partOfSpeech: 'noun',
        example: 'Every student should study hard.',
        pronunciation: '/ˈstuːdənt/',
        category: 'Education',
      ),
      Word(
        term: 'Pencil',
        translation: 'Pensil',
        partOfSpeech: 'noun',
        example: 'Please write with a pencil.',
        pronunciation: '/ˈpensəl/',
        category: 'Education',
      ),

      // === ACTIONS & VERBS ===
      Word(
        term: 'Run',
        translation: 'Lari',
        partOfSpeech: 'verb',
        example: 'He runs every morning.',
        pronunciation: '/rʌn/',
        category: 'Actions',
      ),
      Word(
        term: 'Walk',
        translation: 'Berjalan',
        partOfSpeech: 'verb',
        example: 'Let\'s walk to the park.',
        pronunciation: '/wɔːk/',
        category: 'Actions',
      ),
      Word(
        term: 'Eat',
        translation: 'Makan',
        partOfSpeech: 'verb',
        example: 'We eat dinner at 7 PM.',
        pronunciation: '/iːt/',
        category: 'Actions',
      ),
      Word(
        term: 'Sleep',
        translation: 'Tidur',
        partOfSpeech: 'verb',
        example: 'I sleep eight hours every night.',
        pronunciation: '/sliːp/',
        category: 'Actions',
      ),
      Word(
        term: 'Study',
        translation: 'Belajar',
        partOfSpeech: 'verb',
        example: 'Students study for their exams.',
        pronunciation: '/ˈstʌdi/',
        category: 'Actions',
      ),

      // === ADJECTIVES ===
      Word(
        term: 'Beautiful',
        translation: 'Indah/Cantik',
        partOfSpeech: 'adjective',
        example: 'What a beautiful day!',
        pronunciation: '/ˈbjuːtəfəl/',
        category: 'Adjectives',
      ),
      Word(
        term: 'Big',
        translation: 'Besar',
        partOfSpeech: 'adjective',
        example: 'That\'s a big house.',
        pronunciation: '/bɪɡ/',
        category: 'Adjectives',
      ),
      Word(
        term: 'Small',
        translation: 'Kecil',
        partOfSpeech: 'adjective',
        example: 'She has a small bag.',
        pronunciation: '/smɔːl/',
        category: 'Adjectives',
      ),
      Word(
        term: 'Happy',
        translation: 'Bahagia',
        partOfSpeech: 'adjective',
        example: 'I am happy to see you.',
        pronunciation: '/ˈhæpi/',
        category: 'Adjectives',
      ),
      Word(
        term: 'Good',
        translation: 'Baik',
        partOfSpeech: 'adjective',
        example: 'This is a good book.',
        pronunciation: '/ɡʊd/',
        category: 'Adjectives',
      ),

      // === TIME & WEATHER ===
      Word(
        term: 'Today',
        translation: 'Hari ini',
        partOfSpeech: 'adverb',
        example: 'Today is a beautiful day.',
        pronunciation: '/təˈdeɪ/',
        category: 'Time',
      ),
      Word(
        term: 'Tomorrow',
        translation: 'Besok',
        partOfSpeech: 'adverb',
        example: 'We will meet tomorrow.',
        pronunciation: '/təˈmɔːroʊ/',
        category: 'Time',
      ),
      Word(
        term: 'Yesterday',
        translation: 'Kemarin',
        partOfSpeech: 'adverb',
        example: 'I went to the cinema yesterday.',
        pronunciation: '/ˈjestərdeɪ/',
        category: 'Time',
      ),
      Word(
        term: 'Morning',
        translation: 'Pagi',
        partOfSpeech: 'noun',
        example: 'Good morning, everyone!',
        pronunciation: '/ˈmɔːrnɪŋ/',
        category: 'Time',
      ),
      Word(
        term: 'Night',
        translation: 'Malam',
        partOfSpeech: 'noun',
        example: 'Good night, sleep well.',
        pronunciation: '/naɪt/',
        category: 'Time',
      ),
    ];
  }

  /// Mendapatkan kata-kata berdasarkan kategori
  static List<Word> getWordsByCategory(String category) {
    return getAllWords().where((word) => word.category == category).toList();
  }

  /// Mendapatkan semua kategori yang tersedia
  static List<String> getAllCategories() {
    return getAllWords().map((word) => word.category).toSet().toList()..sort();
  }

  /// Mendapatkan kata-kata acak untuk latihan
  static List<Word> getRandomWords(int count) {
    final allWords = getAllWords();
    allWords.shuffle();
    return allWords.take(count).toList();
  }
}