import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Professional {
  final String name;
  final String specialty;
  final String imageUrl;
  final double rating;
  final String location;

  Professional({
    required this.name,
    required this.specialty,
    required this.imageUrl,
    required this.rating,
    required this.location,
  });
}

class ProfissionaisPage extends StatefulWidget {
  const ProfissionaisPage({super.key});

  @override
  State<ProfissionaisPage> createState() => _ProfissionaisPageState();
}

class _ProfissionaisPageState extends State<ProfissionaisPage> {
  final List<String> _categories = [
    'Todos',
    'Psiquiatras',
    'Psicólogos',
    'Fonoaudiólogos',
    'Nutricionistas',
  ];

  String _selectedCategory = 'Todos';

  final List<Professional> _professionals = [
    Professional(
      name: 'Dra. Maria Silva',
      specialty: 'Psiquiatra',
      imageUrl: 'https://i.pravatar.cc/150?img=1',
      rating: 4.8,
      location: 'São Paulo, SP',
    ),
    Professional(
      name: 'Dr. João Santos',
      specialty: 'Psicólogo',
      imageUrl: 'https://i.pravatar.cc/150?img=2',
      rating: 4.9,
      location: 'São Paulo, SP',
    ),
    // ... você pode adicionar mais profissionais aqui
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF7C4DFF), Color(0xFF6200EA)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: const Text(
          'Profissionais',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFF7C4DFF),
              const Color(0xFF6200EA).withOpacity(0.8),
              Colors.white,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: const [0.0, 0.2, 0.4],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 20),
              // Categorias
              SizedBox(
                height: 50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _categories.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Text(_categories[index]),
                        selected: _selectedCategory == _categories[index],
                        onSelected: (selected) {
                          setState(() {
                            _selectedCategory = _categories[index];
                          });
                        },
                        backgroundColor: Colors.white,
                        selectedColor: const Color(0xFF7C4DFF),
                        labelStyle: TextStyle(
                          color: _selectedCategory == _categories[index]
                              ? Colors.white
                              : Colors.black87,
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              // Lista de profissionais
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _professionals.length,
                  itemBuilder: (context, index) {
                    final professional = _professionals[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      elevation: 4,
                      shadowColor: Colors.black26,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: InkWell(
                        onTap: () {
                          // Implementar navegação para detalhes do profissional
                        },
                        borderRadius: BorderRadius.circular(16),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 35,
                                backgroundImage:
                                    NetworkImage(professional.imageUrl),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      professional.name,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      professional.specialty,
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.star,
                                          size: 16,
                                          color: Colors.amber[700],
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          professional.rating.toString(),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Icon(
                                          Icons.location_on,
                                          size: 16,
                                          color: Colors.grey[600],
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          professional.location,
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(
                                Icons.arrow_forward_ios,
                                size: 16,
                                color: Color(0xFF7C4DFF),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
