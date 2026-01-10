// ========== Updated HomeScreen with new nav ==========
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:trash2heal_app/core/constants/app_images.dart';
import '../../providers/home_provider.dart';
import '../../widgets/membership_card.dart';
import '../../widgets/member_status_card.dart';
import '../../widgets/points_card.dart';
import '../../widgets/quick_actions_row.dart';
import '../../widgets/edu_carousel.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _currentTipIndex = 0;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(homeProvider.notifier).loadHomeData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(homeProvider);
    final user = state.user;

    Widget _buildHeader() {
      final notifCount = state.notificationsCount ?? 0;
      return Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF18A558),
              Color(0xFF0F7A38),
            ],
          ),
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(24),
            bottomRight: Radius.circular(24),
          ),
          image: const DecorationImage(
            image: NetworkImage(AppImages.headerCity),
            fit: BoxFit.cover,
            colorFilter:
                ColorFilter.mode(Colors.black26, BlendMode.darken),
          ),
        ),
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 22),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: Colors.white.withOpacity(0.2),
              child: Text(
                user?.name.isNotEmpty == true
                    ? user!.name[0].toUpperCase()
                    : 'U',
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hi, ${user?.name ?? 'Sahabat T2H'} 👋',
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Colors.white),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Jemput sampah, dapat poin, jadi berkah',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.18),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.recycling,
                      color: Colors.white, size: 20),
                ),
                const SizedBox(width: 8),
                Stack(
                  children: [
                    IconButton(
                      onPressed: () => context.push('/notifications'),
                      icon: const Icon(Icons.notifications_none,
                          color: Colors.white),
                    ),
                    if (notifCount > 0)
                      Positioned(
                        right: 6,
                        top: 8,
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: const BoxDecoration(
                            color: Colors.redAccent,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '$notifCount',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 10),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SafeArea(
        child: state.isLoading || user == null
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Stack(
                      children: [
                        _buildHeader(),
                        Positioned(
                          right: 16,
                          bottom: 0,
                          child: Opacity(
                            opacity: 0.12,
                            child: Icon(
                              Icons.eco,
                              size: 90,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Membership Card
                    if (state.membership != null)
                      MemberStatusCard(
                        tier: state.membership!.tier.name,
                        expiryDate: state.membership!.endDate,
                        onExtend: () => context.push('/membership/plans'),
                      )
                    else
                      MembershipCard(
                        membershipTier: null,
                        expiryDate: null,
                        onUpgrade: () => context.push('/membership/plans'),
                      ),

                    const SizedBox(height: 12),

                    // Points Card (hero)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: PointsCard(
                        pointBalance: user.pointBalance,
                        onRedeem: () => context.push('/redeem'),
                        onHistory: () => context.push('/points/history'),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Voucher & FAQ row
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          Expanded(
                            child: _SmallInfoCard(
                              title: 'Kupon Aktif',
                              value: state.voucherCount != null
                                  ? '${state.voucherCount} kupon'
                                  : '0 kupon',
                              subtitle: state.voucherValue != null
                                  ? 'Total Rp ${state.voucherValue}'
                                  : 'Tukar poin jadi voucher',
                              icon: Icons.confirmation_num_outlined,
                              onTap: () => context.push('/redeem'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _SmallInfoCard(
                              title: 'FAQ Member',
                              value: 'Benefit & Syarat',
                              subtitle: 'Cek paket & keuntungannya',
                              icon: Icons.help_outline,
                              onTap: () => context.push('/membership/plans'),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Quick Actions
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'Aksi Cepat',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: QuickActionsRow(),
                    ),

                    const SizedBox(height: 20),

                    // Education Carousel
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'Tips Kelola Sampah',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.only(left: 16),
                      height: 200,
                      child: PageView.builder(
                        itemCount: sampleTips.length,
                        controller:
                            PageController(viewportFraction: 0.9, initialPage: 0),
                        itemBuilder: (context, index) {
                          final tip = sampleTips[index];
                          return Container(
                            margin: const EdgeInsets.only(right: 12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              gradient: const LinearGradient(
                                colors: [Color(0xFF18A558), Color(0xFF0F7A38)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.08),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    tip.title,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    tip.description,
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        onPageChanged: (index) {
                          setState(() {
                            _currentTipIndex = index;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        sampleTips.length,
                        (index) => Container(
                          width: 8,
                          height: 8,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _currentTipIndex == index
                                ? Theme.of(context).colorScheme.primary
                                : const Color(0xFFE5E7EB),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Event Banner
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'Event & Promo',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    EventBanner(
                      title: state.events.isNotEmpty
                          ? state.events.first.title
                          : 'Double Poin Weekend!',
                      subtitle: state.events.isNotEmpty
                          ? state.events.first.organizer
                          : 'Dapatkan poin ekstra di akhir pekan',
                      imageUrl: state.events.isNotEmpty
                          ? state.events.first.imageUrl
                          : AppImages.eventCommunity,
                      onTap: () => context.push('/events'),
                    ),

                    const SizedBox(height: 80), // space for bottom nav
                  ],
                ),
              ),
      ),
    );
  }
}

class EventBanner extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? imageUrl;
  final VoidCallback? onTap;

  const EventBanner({
    super.key,
    required this.title,
    this.subtitle,
    this.imageUrl,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final hasImage = imageUrl != null && imageUrl!.isNotEmpty;
    final isNetwork = hasImage && imageUrl!.startsWith('http');
    final imageProvider = isNetwork
        ? NetworkImage(imageUrl!)
        : const NetworkImage(AppImages.eventCommunity);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: 180,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Theme.of(context).colorScheme.primary.withOpacity(0.8),
                Theme.of(context).colorScheme.primary,
              ],
            ),
            boxShadow: [
              BoxShadow(
                color:
                    Theme.of(context).colorScheme.primary.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
            image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.3),
                BlendMode.darken,
              ),
            ),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.7),
                ],
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (subtitle != null) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      subtitle!,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                const Row(
                  children: [
                    Text(
                      'Lihat Detail',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                      size: 16,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SmallInfoCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final VoidCallback? onTap;

  const _SmallInfoCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE5E7EB)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: const Color(0xFF18A558), size: 18),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Color(0xFF111827),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF18A558),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF6B7280),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
