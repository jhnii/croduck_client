import 'package:flutter/material.dart';
import '../../domain/entities/message_entity.dart';

class MessageBubbleWidget extends StatelessWidget {
  final MessageEntity message;

  const MessageBubbleWidget({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isFromUser = message.sender == MessageSender.user;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment:
            isFromUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isFromUser) ...[
            CircleAvatar(
              backgroundColor: theme.colorScheme.primary,
              radius: 16,
              child: const Icon(
                Icons.smart_toy,
                size: 16,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: isFromUser 
                  ? CrossAxisAlignment.end 
                  : CrossAxisAlignment.start,
              children: [
                Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.75,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: isFromUser
                        ? theme.colorScheme.primary
                        : (isDark 
                            ? const Color(0xFF37474F) 
                            : const Color(0xFFFFF3E0)),
                    borderRadius: BorderRadius.circular(18).copyWith(
                      bottomRight: isFromUser
                          ? const Radius.circular(4)
                          : const Radius.circular(18),
                      bottomLeft: !isFromUser
                          ? const Radius.circular(4)
                          : const Radius.circular(18),
                    ),
                    border: !isFromUser && !isDark
                        ? Border.all(
                            color: const Color(0xFFFFE0B2),
                            width: 1,
                          )
                        : null,
                  ),
                  child: Text(
                    message.content,
                    style: TextStyle(
                      color: isFromUser
                          ? Colors.white
                          : theme.colorScheme.onSurface,
                      fontSize: 15,
                      height: 1.4,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _formatTime(message.createdAt),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                        fontSize: 12,
                      ),
                    ),
                    if (isFromUser) ...[
                      const SizedBox(width: 4),
                      _buildStatusIcon(message.status, theme),
                    ],
                  ],
                ),
              ],
            ),
          ),
          if (isFromUser) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              backgroundColor: isDark 
                  ? const Color(0xFF546E7A)
                  : const Color(0xFFFFCC02),
              radius: 16,
              child: Icon(
                Icons.person,
                size: 16,
                color: isDark ? Colors.white : const Color(0xFF333333),
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  Widget _buildStatusIcon(MessageStatus status, ThemeData theme) {
    switch (status) {
      case MessageStatus.sending:
        return SizedBox(
          width: 12,
          height: 12,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: theme.colorScheme.onSurface.withOpacity(0.6),
          ),
        );
      case MessageStatus.sent:
        return Icon(
          Icons.check,
          size: 12,
          color: theme.colorScheme.onSurface.withOpacity(0.6),
        );
      case MessageStatus.delivered:
        return Icon(
          Icons.done_all,
          size: 12,
          color: theme.colorScheme.primary,
        );
      case MessageStatus.failed:
        return Icon(
          Icons.error_outline,
          size: 12,
          color: theme.colorScheme.error,
        );
    }
  }
} 