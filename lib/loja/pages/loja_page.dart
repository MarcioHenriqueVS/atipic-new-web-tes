import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../data/produtos_data.dart';
import 'components/product_details_dialog.dart';

class LojaPage extends StatefulWidget {
  const LojaPage({super.key});

  @override
  State<LojaPage> createState() => _LojaPageState();
}

class _LojaPageState extends State<LojaPage>
    with SingleTickerProviderStateMixin {
  int _selectedCategory = 0;
  final ProdutosData _produtosData = ProdutosData();
  List<Map<String, dynamic>> _products = [];
  List<Map<String, dynamic>> _categories = [];
  late AnimationController _controller;
  final ScrollController _scrollController = ScrollController();
  double _offset = 0;
  String _searchQuery = '';

  List<Map<String, dynamic>> get _filteredProducts {
    final products = _selectedCategory == 0
        ? _products
        : _products
            .where((p) => p['category'] == _selectedCategory - 1)
            .toList();

    if (_searchQuery.isEmpty) return products;

    return products
        .where((product) => product['name']
            .toString()
            .toLowerCase()
            .contains(_searchQuery.toLowerCase()))
        .toList();
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _scrollController.addListener(() {
      setState(() {
        _offset = _scrollController.offset;
      });
    });
    _products = _produtosData.products;
    _categories = _produtosData.categories;
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: _offset > 0 ? 4 : 0,
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
          'Loja AtiPic',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart, color: Colors.white),
            onPressed: () {
              // Implementar carrinho de compras
            },
          ),
        ],
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
            stops: const [0.0, 0.3, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Barra de pesquisa
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: TextField(
                  onChanged: (value) => setState(() => _searchQuery = value),
                  decoration: InputDecoration(
                    hintText: 'Pesquisar produtos...',
                    hintStyle: TextStyle(
                      color: Colors.grey[400],
                    ),
                    prefixIcon:
                        const Icon(Icons.search, color: Color(0xFF7C4DFF)),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear,
                                color: Color(0xFF7C4DFF)),
                            onPressed: () => setState(() => _searchQuery = ''),
                          )
                        : null,
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFF7C4DFF)),
                    ),
                  ),
                ),
              ),
              // Categorias
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: 100,
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _categories.length,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemBuilder: (context, index) {
                    return AnimatedScale(
                      scale: _selectedCategory == index ? 1.1 : 1.0,
                      duration: const Duration(milliseconds: 200),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedCategory = index;
                          });
                        },
                        child: Container(
                          width: 80,
                          margin: const EdgeInsets.only(right: 12),
                          decoration: BoxDecoration(
                            color: _selectedCategory == index
                                ? const Color(0xFF7C4DFF)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: TweenAnimationBuilder(
                            tween: Tween<double>(
                              begin: 0,
                              end: _selectedCategory == index ? 1 : 0,
                            ),
                            duration: const Duration(milliseconds: 300),
                            builder: (context, value, child) {
                              return Transform.scale(
                                scale: 0.9 + (value * 0.1),
                                child: child,
                              );
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  _categories[index]['icon'],
                                  color: _selectedCategory == index
                                      ? Colors.white
                                      : const Color(0xFF7C4DFF),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  _categories[index]['label'],
                                  style: TextStyle(
                                    color: _selectedCategory == index
                                        ? Colors.white
                                        : Colors.black87,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Expanded(
                child: _filteredProducts.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_off,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Nenhum produto encontrado',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      )
                    : GridView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(16),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.75,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        itemCount: _filteredProducts.length,
                        itemBuilder: (context, index) {
                          final product = _filteredProducts[index];
                          return Hero(
                            tag: 'product-${product['name']}',
                            child: Card(
                              elevation: 8,
                              shadowColor: Colors.black26,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: InkWell(
                                onTap: () {
                                  showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    backgroundColor: Colors.transparent,
                                    builder: (context) =>
                                        ProductDetailsDialog(product: product),
                                  );
                                },
                                child: Stack(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.grey[200],
                                              borderRadius:
                                                  const BorderRadius.vertical(
                                                top: Radius.circular(16),
                                              ),
                                            ),
                                            child: Center(
                                              child: Icon(
                                                Icons.image,
                                                size: 64,
                                                color: Colors.grey[400],
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(12),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                product['name'],
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                'R\$ ${product['price'].toStringAsFixed(2)}',
                                                style: TextStyle(
                                                  color: Colors.grey[800],
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Positioned(
                                      top: 8,
                                      right: 8,
                                      child: IconButton(
                                        icon: Icon(
                                          product['isFavorite'] ?? false
                                              ? Icons.favorite
                                              : Icons.favorite_border,
                                          color: const Color(0xFF7C4DFF),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            product['isFavorite'] =
                                                !(product['isFavorite'] ??
                                                    false);
                                          });
                                        },
                                      ),
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
