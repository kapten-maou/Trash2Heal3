import 'package:flutter/material.dart';
import 'package:trash2heal_app/core/constants/app_images.dart';

/// Educational carousel for waste tips
class EduCarousel extends StatelessWidget {
  final List<EducationTip> tips;
  final ValueChanged<int>? onTipTap;

  const EduCarousel({
    super.key,
    required this.tips,
    this.onTipTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Tips Pilah Sampah',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF111827),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 160,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: tips.length,
            itemBuilder: (context, index) {
              return _buildTipCard(context, tips[index], index);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTipCard(BuildContext context, EducationTip tip, int index) {
    final bgImage = index < sampleTipImages.length
        ? sampleTipImages[index]
        : AppImages.eduPlastic;

    return Container(
      width: 280,
      margin: const EdgeInsets.only(right: 12),
      child: InkWell(
        onTap: () => onTipTap?.call(index),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Theme.of(context).colorScheme.primary.withOpacity(0.1),
                Theme.of(context).colorScheme.primary.withOpacity(0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
              width: 1,
            ),
            image: DecorationImage(
              image: NetworkImage(bgImage),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.12),
                BlendMode.darken,
              ),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      tip.icon,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      tip.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF111827),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Expanded(
                child: Text(
                  tip.description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF6B7280),
                    height: 1.4,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Education tip model
class EducationTip {
  final String title;
  final String description;
  final IconData icon;

  const EducationTip({
    required this.title,
    required this.description,
    required this.icon,
  });
}

/// Sample tips data
final sampleTips = [
  const EducationTip(
    title: 'Pisahkan Plastik',
    description:
        'Pisahkan botol plastik dari tutupnya. Cuci dan keringkan sebelum disetorkan.',
    icon: Icons.recycling,
  ),
  const EducationTip(
    title: 'Kardus Dilipat',
    description:
        'Lipat kardus agar tidak memakan banyak tempat dan lebih mudah diangkut.',
    icon: Icons.inventory_2,
  ),
  const EducationTip(
    title: 'Kaca & Kaleng',
    description:
        'Kumpulkan botol kaca dan kaleng di wadah terpisah untuk keamanan.',
    icon: Icons.local_drink,
  ),
];

final sampleTipImages = [
  AppImages.eduPlastic,
  AppImages.eduCardboard,
  AppImages.eduMetalGlass,
];
