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
    this.plusActive = false,
  });

  final MateyaBottomTab? currentTab;
  final VoidCallback onHomeTap;
  final VoidCallback onExploreTap;
  final VoidCallback onPlusTap;
  final VoidCallback onChatTap;
  final VoidCallback onProfileTap;
  final bool plusActive;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
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
                child: Transform.translate(
                  offset: const Offset(0, -6),
                  child: _TapScale(
                    pressedScale: 0.92,
                    borderRadius: BorderRadius.circular(14),
                    child: Material(
                      color: Colors.transparent,
                      child: Ink(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: plusActive
                              ? AppColors.brandGreen
                              : AppColors.brandGreenLight,
                          borderRadius: BorderRadius.all(Radius.circular(14)),
                          boxShadow: const <BoxShadow>[
                            BoxShadow(
                              color: Color(0x16000000),
                              blurRadius: 3,
                              offset: Offset(0, 1),
                            ),
                            BoxShadow(
                              color: Color(0x26000000),
                              blurRadius: 14,
                              offset: Offset(0, 10),
                            ),
                          ],
                        ),
                        child: InkWell(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(14),
                          ),
                          splashColor: Colors.white24,
                          highlightColor: Colors.white10,
                          onTap: onPlusTap,
                          child: const Center(
                            child: Icon(
                              Icons.add_rounded,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ),
                      ),
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

    return _TapScale(
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        splashColor: color.withValues(alpha: 0.12),
        highlightColor: color.withValues(alpha: 0.08),
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
      ),
    );
  }
}

class _TapScale extends StatefulWidget {
  const _TapScale({
    required this.child,
    this.borderRadius,
    this.pressedScale = 0.96,
  });

  final Widget child;
  final BorderRadius? borderRadius;
  final double pressedScale;

  @override
  State<_TapScale> createState() => _TapScaleState();
}

class _TapScaleState extends State<_TapScale> {
  bool _isPressed = false;

  void _setPressed(bool value) {
    if (_isPressed == value) {
      return;
    }
    setState(() {
      _isPressed = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final child = widget.borderRadius == null
        ? widget.child
        : ClipRRect(borderRadius: widget.borderRadius!, child: widget.child);

    return Listener(
      onPointerDown: (_) => _setPressed(true),
      onPointerUp: (_) => _setPressed(false),
      onPointerCancel: (_) => _setPressed(false),
      child: AnimatedScale(
        scale: _isPressed ? widget.pressedScale : 1,
        duration: const Duration(milliseconds: 110),
        curve: Curves.easeOutCubic,
        child: child,
      ),
    );
  }
}
