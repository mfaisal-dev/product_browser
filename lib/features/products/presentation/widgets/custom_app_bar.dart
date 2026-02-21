import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool automaticallyImplyLeading;
  final Widget? leading;
  final bool centerTitle;
  final Color? backgroundColor;
  final double elevation;
  final PreferredSizeWidget? bottom;

  const CustomAppBar({
    super.key,
    required this.title,
    this.actions,
    this.automaticallyImplyLeading = true,
    this.leading,
    this.centerTitle = false,
    this.backgroundColor,
    this.elevation = 0,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AppBar(
      title: Text(
        title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: theme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
          color: isDark ? Colors.white : theme.colorScheme.onPrimary,
        ),
      ),
      automaticallyImplyLeading: automaticallyImplyLeading,
      leading: leading,
      centerTitle: true,
      backgroundColor: backgroundColor ??
          (isDark ? theme.appBarTheme.backgroundColor : theme.primaryColor),
      foregroundColor: isDark ? Colors.white : Colors.white,
      elevation: elevation,
      actions: actions,
      bottom: bottom,
      iconTheme: IconThemeData(
        color: isDark ? Colors.white : Colors.white,
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(
    kToolbarHeight + (bottom?.preferredSize.height ?? 0),
  );
}