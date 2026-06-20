import 'package:flutter/material.dart';

import '../../../../shared/theme/app_tokens.dart';
import '../../../../shared/widgets/mateya_profile_avatar.dart';
import '../../../../shared/widgets/mateya_interaction.dart';
import '../../domain/chat_models.dart';
import 'chat_formatters.dart';

class ChatFilterBar extends StatelessWidget {
  const ChatFilterBar({
    super.key,
    required this.currentFilter,
    required this.onChanged,
  });

  final ChatListFilter currentFilter;
  final ValueChanged<ChatListFilter> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final filters = ChatListFilter.values;
    final selectedIndex = filters.indexOf(currentFilter);

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.disabledSurface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: SizedBox(
        height: 40,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final indicatorWidth = constraints.maxWidth / filters.length;

            return Stack(
              fit: StackFit.expand,
              children: <Widget>[
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeOutCubic,
                  top: 0,
                  bottom: 0,
                  left: indicatorWidth * selectedIndex,
                  width: indicatorWidth,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const <BoxShadow>[
                        BoxShadow(
                          color: Color(0x14000000),
                          blurRadius: 2,
                          offset: Offset(0, 0),
                        ),
                        BoxShadow(
                          color: Color(0x14000000),
                          blurRadius: 8.5,
                          offset: Offset(0, 6),
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  children: filters
                      .map((filter) {
                        final selected = filter == currentFilter;
                        return Expanded(
                          child: MateyaPressable(
                            onTap: () => onChanged(filter),
                            borderRadius: BorderRadius.circular(12),
                            pressedScale: 0.98,
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            child: Center(
                              child: Text(
                                filter.label,
                                textAlign: TextAlign.center,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: AppColors.textPrimary,
                                  fontWeight: selected
                                      ? FontWeight.w600
                                      : FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                        );
                      })
                      .toList(growable: false),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class ChatRoomTile extends StatelessWidget {
  const ChatRoomTile({super.key, required this.room, required this.onTap});

  final ChatRoom room;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          NetworkAvatar(imageUrl: room.imageUrl, label: room.title, size: 54),
          const SizedBox(width: 15),
          Expanded(
            child: SizedBox(
              height: 66,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    room.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    room.lastMessagePreview,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.fieldBorder,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 54, minHeight: 56),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                if (room.lastMessageAt != null)
                  Text(
                    formatRoomTimestamp(room.lastMessageAt!),
                    textAlign: TextAlign.right,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.fieldBorder,
                    ),
                  ),
                if (room.lastMessageAt != null && room.unreadCount > 0)
                  const SizedBox(height: 8),
                if (room.unreadCount > 0) UnreadBadge(count: room.unreadCount),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class NetworkAvatar extends StatelessWidget {
  const NetworkAvatar({
    super.key,
    required this.imageUrl,
    required this.label,
    required this.size,
  });

  final String? imageUrl;
  final String label;
  final double size;

  @override
  Widget build(BuildContext context) {
    return MateyaProfileAvatar(imageUrl: imageUrl, size: size);
  }
}

class FallbackAvatar extends StatelessWidget {
  const FallbackAvatar({super.key, required this.label, required this.size});

  final String label;
  final double size;

  @override
  Widget build(BuildContext context) {
    final trimmed = label.trim();
    final initials = trimmed.isEmpty ? '?' : trimmed.substring(0, 1);

    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: <Color>[Color(0xFF90E0A0), Color(0xFF5AC366)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Text(
          initials,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class UnreadBadge extends StatelessWidget {
  const UnreadBadge({super.key, required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final label = count > 20 ? '20+' : '$count';

    return Container(
      constraints: const BoxConstraints(minWidth: 25, minHeight: 25),
      padding: const EdgeInsets.symmetric(horizontal: 7),
      decoration: BoxDecoration(
        color: AppColors.brandGreen,
        borderRadius: BorderRadius.circular(12.5),
      ),
      alignment: Alignment.center,
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
