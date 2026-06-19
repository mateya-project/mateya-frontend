import 'package:flutter/material.dart';

import '../theme/app_tokens.dart';

enum MateyaBottomTab { home, explore, chat, profile }

class MateyaBottomNavigation extends StatelessWidget {
  const MateyaBottomNavigation({
    super.key,
    required this.onHomeTap,
    required this.onExploreTap,
    required this.onPlusTap,
    required this.onChatTap,
    required this.onProfileTap,
    this.currentTab,
  });

  final MateyaBottomTab? currentTab;
  final VoidCallback onHomeTap;
  final VoidCallback onExploreTap;
  final VoidCallback onPlusTap;
  final VoidCallback onChatTap;
  final VoidCallback onProfileTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: AppColors.divider)),
        ),
        child: SafeArea(
          top: false,
          child: Row(
            children: <Widget>[
              Expanded(
                child: _BottomItem(
                  label: 'Home',
                  icon: Icons.home_rounded,
                  active: currentTab == MateyaBottomTab.home,
                  onTap: onHomeTap,
                ),
              ),
              Expanded(
                child: _BottomItem(
                  label: 'Explore',
                  icon: Icons.explore_rounded,
                  active: currentTab == MateyaBottomTab.explore,
                  onTap: onExploreTap,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: GestureDetector(
                  onTap: onPlusTap,
                  child: Container(
                    width: 56,
                    height: 56,
                    decoration: const BoxDecoration(
                      color: AppColors.brandGreenLight,
                      shape: BoxShape.circle,
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: Color(0x14000000),
                          blurRadius: 2,
                          offset: Offset(0, 0),
                        ),
                        BoxShadow(
                          color: Color(0x1F000000),
                          blurRadius: 8,
                          offset: Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.add_rounded,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: _BottomItem(
                  label: 'Chat',
                  icon: Icons.chat_bubble_rounded,
                  active: currentTab == MateyaBottomTab.chat,
                  onTap: onChatTap,
                ),
              ),
              Expanded(
                child: _BottomItem(
                  label: 'Profile',
                  icon: Icons.person_rounded,
                  active: currentTab == MateyaBottomTab.profile,
                  onTap: onProfileTap,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomItem extends StatelessWidget {
  const _BottomItem({
    required this.label,
    required this.icon,
    required this.active,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = active ? AppColors.brandGreenLight : AppColors.navInactive;

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(icon, size: 24, color: color),
            const SizedBox(height: 6),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: color,
                fontWeight: active ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
