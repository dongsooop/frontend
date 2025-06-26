String formatRelativeTime(DateTime dateTime) {
  final now = DateTime.now();
  final difference = now.difference(dateTime);

  if (difference.inMinutes < 1) return '방금 전';
  if (difference.inMinutes < 60) return '${difference.inMinutes}분 전';
  if (difference.inHours < 24) return '${difference.inHours}시간 전';
  if (difference.inDays < 7) return '${difference.inDays}일 전';

  return '${dateTime.year}. ${dateTime.month}. ${dateTime.day}. ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
}
