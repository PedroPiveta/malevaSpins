import 'package:flutter/material.dart';

class PillTabView extends StatefulWidget {
  const PillTabView({super.key, required this.tabs, this.height = 44});

  final List<({IconData icon, String label, Widget child})> tabs;
  final double height;

  @override
  State<PillTabView> createState() => _PillTabViewState();
}

class _PillTabViewState extends State<PillTabView> {
  late final PageController _pageController = PageController();
  double _pageOffset = 0;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() => _pageOffset = _pageController.page ?? 0);
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToPage(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final count = widget.tabs.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Container(
            height: widget.height,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: scheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(100),
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final tabWidth = constraints.maxWidth / count;

                return Stack(
                  children: [
                    AnimatedBuilder(
                      animation: _pageController,
                      builder: (context, _) {
                        return Positioned(
                          left: _pageOffset * tabWidth,
                          top: 0,
                          bottom: 0,
                          width: tabWidth,
                          child: Container(
                            decoration: BoxDecoration(
                              color: scheme.primary,
                              borderRadius: BorderRadius.circular(100),
                            ),
                          ),
                        );
                      },
                    ),
                    // Labels
                    Row(
                      children: List.generate(count, (i) {
                        return Expanded(
                          child: GestureDetector(
                            onTap: () => _goToPage(i),
                            behavior: HitTestBehavior.opaque,
                            child: AnimatedBuilder(
                              animation: _pageController,
                              builder: (context, _) {
                                final selected = (1 - (_pageOffset - i).abs())
                                    .clamp(0.0, 1.0);
                                final color = Color.lerp(
                                  scheme.onSurfaceVariant,
                                  scheme.onPrimary,
                                  selected,
                                )!;

                                return Center(
                                  child: Row(
                                    spacing: 4,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        widget.tabs[i].icon,
                                        size: 16,
                                        color: color,
                                      ),
                                      Text(
                                        widget.tabs[i].label,
                                        style: TextStyle(
                                          color: color,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      }),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: PageView(
            controller: _pageController,
            children: widget.tabs.map((t) => t.child).toList(),
          ),
        ),
      ],
    );
  }
}
