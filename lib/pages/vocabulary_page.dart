import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../models/word.dart';

/// Halaman Vocabulary dengan UI modern dan fitur lengkap
/// Menampilkan daftar kata-kata dengan kategori, pencarian, dan filter
class VocabularyPage extends StatefulWidget {
  const VocabularyPage({super.key});

  @override
  State<VocabularyPage> createState() => _VocabularyPageState();
}

class _VocabularyPageState extends State<VocabularyPage>
    with TickerProviderStateMixin {
  String _searchQuery = '';
  String _selectedCategory = 'All';
  String _selectedPartOfSpeech = 'All';
  bool _showFavorites = false;
  
  // Animation controllers untuk efek visual
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    
    // Inisialisasi animasi
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic));
    
    // Mulai animasi
    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Modern SliverAppBar dengan gradient dan efek
          SliverAppBar(
            expandedHeight: 200,
            floating: false,
            pinned: true,
            stretch: true,
            leading: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => context.go('/'),
              ),
            ),
            actions: [
              Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  icon: Icon(
                    _showFavorites ? Icons.favorite : Icons.favorite_border,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      _showFavorites = !_showFavorites;
                    });
                  },
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'Vocabulary',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      offset: Offset(0, 1),
                      blurRadius: 3,
                      color: Colors.black26,
                    ),
                  ],
                ),
              ),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF667eea),
                      Color(0xFF764ba2),
                      Color(0xFF6B73FF),
                    ],
                  ),
                ),
                child: Stack(
                  children: [
                    // Background pattern
                    Positioned.fill(
                      child: Opacity(
                        opacity: 0.1,
                        child: Container(
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage('https://www.transparenttextures.com/patterns/cubes.png'),
                              repeat: ImageRepeat.repeat,
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Floating icons
                    Positioned(
                      top: 60,
                      right: 30,
                      child: Icon(
                        Icons.translate,
                        size: 60,
                        color: Colors.white.withOpacity(0.2),
                      ),
                    ),
                    Positioned(
                      bottom: 40,
                      left: 40,
                      child: Icon(
                        Icons.book,
                        size: 40,
                        color: Colors.white.withOpacity(0.15),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Search and filter section dengan animasi
          SliverToBoxAdapter(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Container(
                  margin: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // Search bar dengan shadow dan border radius
                      Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: TextField(
                          onChanged: (value) {
                            setState(() {
                              _searchQuery = value.toLowerCase();
                            });
                          },
                          decoration: InputDecoration(
                            hintText: 'Search words, translations...',
                            hintStyle: TextStyle(
                              color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.6),
                            ),
                            prefixIcon: Container(
                              margin: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: const Color(0xFF667eea).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons.search,
                                color: Color(0xFF667eea),
                              ),
                            ),
                            suffixIcon: _searchQuery.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.clear),
                                    onPressed: () {
                                      setState(() {
                                        _searchQuery = '';
                                      });
                                    },
                                  )
                                : null,
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 16,
                            ),
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Filter chips dengan animasi
                      Consumer<AppState>(
                        builder: (context, appState, child) {
                          final categories = ['All', ...appState.words.map((w) => w.category).toSet()];
                          final partsOfSpeech = ['All', ...appState.words.map((w) => w.partOfSpeech).toSet()];
                          
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Category filters
                              Row(
                                children: [
                                  Icon(
                                    Icons.category,
                                    size: 20,
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Categories',
                                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              SizedBox(
                                height: 40,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: categories.length,
                                  itemBuilder: (context, index) {
                                    final category = categories.elementAt(index);
                                    final isSelected = _selectedCategory == category;
                                    
                                    return Container(
                                      margin: const EdgeInsets.only(right: 8),
                                      child: AnimatedContainer(
                                        duration: const Duration(milliseconds: 200),
                                        child: FilterChip(
                                          label: Text(
                                            category,
                                            style: TextStyle(
                                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                            ),
                                          ),
                                          selected: isSelected,
                                          onSelected: (selected) {
                                            setState(() {
                                              _selectedCategory = category;
                                            });
                                          },
                                          backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                                          selectedColor: const Color(0xFF667eea).withOpacity(0.2),
                                          checkmarkColor: const Color(0xFF667eea),
                                          side: BorderSide(
                                            color: isSelected 
                                                ? const Color(0xFF667eea) 
                                                : Colors.transparent,
                                            width: 1.5,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              
                              const SizedBox(height: 16),
                              
                              // Part of speech filters
                              Row(
                                children: [
                                  Icon(
                                    Icons.text_fields,
                                    size: 20,
                                    color: Theme.of(context).colorScheme.secondary,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Parts of Speech',
                                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).colorScheme.secondary,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              SizedBox(
                                height: 40,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: partsOfSpeech.length,
                                  itemBuilder: (context, index) {
                                    final partOfSpeech = partsOfSpeech.elementAt(index);
                                    final isSelected = _selectedPartOfSpeech == partOfSpeech;
                                    
                                    return Container(
                                      margin: const EdgeInsets.only(right: 8),
                                      child: AnimatedContainer(
                                        duration: const Duration(milliseconds: 200),
                                        child: FilterChip(
                                          label: Text(
                                            partOfSpeech,
                                            style: TextStyle(
                                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                            ),
                                          ),
                                          selected: isSelected,
                                          onSelected: (selected) {
                                            setState(() {
                                              _selectedPartOfSpeech = partOfSpeech;
                                            });
                                          },
                                          backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                                          selectedColor: Theme.of(context).colorScheme.secondary.withOpacity(0.2),
                                          checkmarkColor: Theme.of(context).colorScheme.secondary,
                                          side: BorderSide(
                                            color: isSelected 
                                                ? Theme.of(context).colorScheme.secondary 
                                                : Colors.transparent,
                                            width: 1.5,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          
          // Statistics section
          SliverToBoxAdapter(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Consumer<AppState>(
                builder: (context, appState, child) {
                  final totalWords = appState.words.length;
                  final categories = appState.words.map((w) => w.category).toSet().length;
                  
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF667eea).withOpacity(0.1),
                          const Color(0xFF764ba2).withOpacity(0.1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color(0xFF667eea).withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildStatItem(
                            icon: Icons.book,
                            label: 'Total Words',
                            value: totalWords.toString(),
                            color: const Color(0xFF667eea),
                          ),
                        ),
                        Container(
                          width: 1,
                          height: 40,
                          color: const Color(0xFF667eea).withOpacity(0.2),
                        ),
                        Expanded(
                          child: _buildStatItem(
                            icon: Icons.category,
                            label: 'Categories',
                            value: categories.toString(),
                            color: const Color(0xFF764ba2),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          
          // Words grid dengan animasi stagger
          Consumer<AppState>(
            builder: (context, appState, child) {
              final filteredWords = appState.words.where((word) {
                final matchesSearch = _searchQuery.isEmpty ||
                    word.english.toLowerCase().contains(_searchQuery) ||
                    word.indonesian.toLowerCase().contains(_searchQuery) ||
                    word.translation.toLowerCase().contains(_searchQuery);
                final matchesCategory = _selectedCategory == 'All' ||
                    word.category == _selectedCategory;
                final matchesPartOfSpeech = _selectedPartOfSpeech == 'All' ||
                    word.partOfSpeech == _selectedPartOfSpeech;
                return matchesSearch && matchesCategory && matchesPartOfSpeech;
              }).toList();

              if (filteredWords.isEmpty) {
                return SliverToBoxAdapter(
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Container(
                      padding: const EdgeInsets.all(40),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Icon(
                              Icons.search_off,
                              size: 64,
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            'No words found',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Try adjusting your search or filter criteria',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton.icon(
                            onPressed: () {
                              setState(() {
                                _searchQuery = '';
                                _selectedCategory = 'All';
                                _selectedPartOfSpeech = 'All';
                              });
                            },
                            icon: const Icon(Icons.refresh),
                            label: const Text('Reset Filters'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF667eea),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }

              return SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final word = filteredWords[index];
                      return AnimatedContainer(
                        duration: Duration(milliseconds: 200 + (index * 50)),
                        curve: Curves.easeOutCubic,
                        child: _buildEnhancedWordCard(context, word, index),
                      );
                    },
                    childCount: filteredWords.length,
                  ),
                ),
              );
            },
          ),
          
          const SliverToBoxAdapter(
            child: SizedBox(height: 32),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: color.withOpacity(0.8),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildEnhancedWordCard(BuildContext context, Word word, int index) {
    final categoryColor = _getCategoryColor(word.category);
    
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 600 + (index * 100)),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 50 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: Card(
              clipBehavior: Clip.antiAlias,
              elevation: 4,
              shadowColor: categoryColor.withOpacity(0.3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: InkWell(
                onTap: () {
                  _showEnhancedWordDetails(context, word);
                },
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        categoryColor.withOpacity(0.1),
                        categoryColor.withOpacity(0.05),
                        Colors.white,
                      ],
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header dengan category dan part of speech
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: categoryColor.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  word.category,
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: categoryColor,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            const SizedBox(width: 4),
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                _getPartOfSpeechIcon(word.partOfSpeech),
                                size: 12,
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 12),
                        
                        // English word dengan styling yang lebih menarik
                        Text(
                          word.english,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: categoryColor.withOpacity(0.9),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        
                        const SizedBox(height: 8),
                        
                        // Pronunciation dengan styling yang lebih baik
                        if (word.pronunciation.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              word.pronunciation,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                fontStyle: FontStyle.italic,
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                                fontFamily: 'monospace',
                              ),
                            ),
                          ),
                        
                        const Spacer(),
                        
                        // Indonesian translation dengan emphasis
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: categoryColor.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: categoryColor.withOpacity(0.2),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            word.indonesian,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.onSurface,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        
                        const SizedBox(height: 12),
                        
                        // Action buttons dengan animasi hover
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      categoryColor.withOpacity(0.8),
                                      categoryColor.withOpacity(0.6),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () {
                                      // TODO: Implement text-to-speech
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('🔊 Playing pronunciation: ${word.english}'),
                                          backgroundColor: categoryColor,
                                          behavior: SnackBarBehavior.floating,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                        ),
                                      );
                                    },
                                    borderRadius: BorderRadius.circular(8),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(vertical: 8),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            Icons.volume_up,
                                            size: 16,
                                            color: Colors.white,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            'Listen',
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showEnhancedWordDetails(BuildContext context, Word word) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Column(
          children: [
            // Handle bar dengan styling yang lebih menarik
            Container(
              margin: const EdgeInsets.only(top: 16),
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.3),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header dengan kategori dan close button
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                _getCategoryColor(word.category).withOpacity(0.2),
                                _getCategoryColor(word.category).withOpacity(0.1),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: _getCategoryColor(word.category).withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                _getPartOfSpeechIcon(word.partOfSpeech),
                                size: 16,
                                color: _getCategoryColor(word.category),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                word.category,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: _getCategoryColor(word.category),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.close),
                            iconSize: 20,
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // English word dengan styling yang menarik
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            _getCategoryColor(word.category).withOpacity(0.1),
                            _getCategoryColor(word.category).withOpacity(0.05),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: _getCategoryColor(word.category).withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'English',
                            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                              color: _getCategoryColor(word.category),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            word.english,
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: _getCategoryColor(word.category),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Pronunciation dengan design yang lebih baik
                    if (word.pronunciation.isNotEmpty)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.record_voice_over,
                                size: 20,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Pronunciation',
                                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    word.pronunciation,
                                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      fontStyle: FontStyle.italic,
                                      fontFamily: 'monospace',
                                      color: Theme.of(context).colorScheme.onSurface,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    
                    const SizedBox(height: 24),
                    
                    // Indonesian translation dengan design yang menarik
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.3),
                            Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.1),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Theme.of(context).colorScheme.secondary.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.translate,
                                size: 20,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Indonesian Translation',
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.secondary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            word.indonesian,
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Part of Speech dengan design yang menarik
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.tertiaryContainer.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Theme.of(context).colorScheme.tertiary.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.tertiary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              _getPartOfSpeechIcon(word.partOfSpeech),
                              size: 20,
                              color: Theme.of(context).colorScheme.tertiary,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Part of Speech',
                                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  word.partOfSpeech,
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).colorScheme.tertiary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Example sentence dengan design yang menarik
                    if (word.exampleSentence.isNotEmpty) ...[
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
                              Theme.of(context).colorScheme.primaryContainer.withOpacity(0.1),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.format_quote,
                                  size: 20,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Example Sentence',
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              word.exampleSentence,
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                fontStyle: FontStyle.italic,
                                height: 1.5,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                    
                    // Action buttons dengan design yang menarik
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  _getCategoryColor(word.category),
                                  _getCategoryColor(word.category).withOpacity(0.8),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: _getCategoryColor(word.category).withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ElevatedButton.icon(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('🔊 Playing pronunciation: "${word.english}"'),
                                    backgroundColor: _getCategoryColor(word.category),
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.volume_up, color: Colors.white),
                              label: const Text(
                                'Listen',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('❤️ Added "${word.english}" to favorites'),
                                  backgroundColor: Colors.pink,
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              );
                            },
                            icon: Icon(
                              Icons.favorite_border,
                              color: _getCategoryColor(word.category),
                            ),
                            label: Text(
                              'Favorite',
                              style: TextStyle(
                                color: _getCategoryColor(word.category),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(
                                color: _getCategoryColor(word.category),
                                width: 2,
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Mendapatkan icon yang sesuai untuk part of speech
  IconData _getPartOfSpeechIcon(String partOfSpeech) {
    switch (partOfSpeech.toLowerCase()) {
      case 'noun':
        return Icons.person;
      case 'verb':
        return Icons.directions_run;
      case 'adjective':
        return Icons.palette;
      case 'adverb':
        return Icons.speed;
      case 'preposition':
        return Icons.arrow_forward;
      case 'pronoun':
        return Icons.account_circle;
      case 'conjunction':
        return Icons.link;
      case 'interjection':
        return Icons.campaign;
      default:
        return Icons.text_fields;
    }
  }

  /// Mendapatkan warna yang sesuai untuk kategori kata
  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'greetings':
        return const Color(0xFF4CAF50); // Green
      case 'family':
        return const Color(0xFFE91E63); // Pink
      case 'food':
        return const Color(0xFFFF9800); // Orange
      case 'animals':
        return const Color(0xFF795548); // Brown
      case 'colors':
        return const Color(0xFF9C27B0); // Purple
      case 'numbers':
        return const Color(0xFF2196F3); // Blue
      case 'education':
        return const Color(0xFF607D8B); // Blue Grey
      case 'actions':
        return const Color(0xFFF44336); // Red
      case 'adjectives':
        return const Color(0xFF00BCD4); // Cyan
      case 'time':
        return const Color(0xFF8BC34A); // Light Green
      case 'noun':
        return const Color(0xFF2196F3); // Blue
      case 'verb':
        return const Color(0xFF4CAF50); // Green
      case 'adjective':
        return const Color(0xFFFF9800); // Orange
      case 'adverb':
        return const Color(0xFF9C27B0); // Purple
      case 'preposition':
        return const Color(0xFFF44336); // Red
      default:
        return const Color(0xFF667eea); // Default gradient color
    }
  }
}