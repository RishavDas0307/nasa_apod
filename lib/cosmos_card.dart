import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'theme_provider.dart';

class CosmosCard extends StatefulWidget {
  final Map<String, dynamic> data;
  final bool isExpanded;
  final VoidCallback onToggleExpand;
  final VoidCallback? onFavoritePressed;

  const CosmosCard({
    super.key,
    required this.data,
    required this.isExpanded,
    required this.onToggleExpand,
    this.onFavoritePressed,
  });

  @override
  State<CosmosCard> createState() => _CosmosCardState();
}

class _CosmosCardState extends State<CosmosCard> {
  String _formatDate(String dateString) {
    DateTime date = DateTime.parse(dateString);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final comparisonDate = DateTime(date.year, date.month, date.day);

    if (comparisonDate == today) {
      return 'Today';
    } else if (comparisonDate == yesterday) {
      return 'Yesterday';
    } else {
      return DateFormat('MMM dd, EEEE').format(date);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final colors = themeProvider.colors;
    final isLightTheme = !themeProvider.isDarkMode;

    return AnimatedContainer(
      duration: Duration(milliseconds: 400),
      curve: Curves.easeOutCubic,
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: colors.shadow.withOpacity(isLightTheme ? 0.12 : 0.08),
            blurRadius: isLightTheme ? 20 : 16,
            offset: Offset(0, isLightTheme ? 10 : 8),
            spreadRadius: isLightTheme ? 2 : 0,
          ),
          if (isLightTheme)
            BoxShadow(
              color: colors.shadow.withOpacity(0.06),
              blurRadius: 8,
              offset: Offset(0, 4),
              spreadRadius: 0,
            ),
        ],
        border: Border.all(
          color: colors.outline.withOpacity(isLightTheme ? 0.15 : 0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Hero(
                tag: 'image_${widget.data['date']}',
                child: ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                  child: widget.data['media_type'] == 'image'
                      ? Image.network(
                    widget.data['url'],
                    height: 260,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        height: 260,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              colors.accent.withOpacity(0.2),
                              colors.accent.withOpacity(0.4),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                                : null,
                            color: colors.accent,
                          ),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 260,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              colors.errorContainer.withOpacity(0.3),
                              colors.errorContainer.withOpacity(0.5),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.error_outline,
                                size: 48,
                                color: colors.onErrorContainer,
                              ),
                              SizedBox(height: 12),
                              Text(
                                'Failed to load image',
                                style: TextStyle(
                                  color: colors.onErrorContainer,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  )
                      : Container(
                    height: 260,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          colors.accent.withOpacity(0.8),
                          colors.accentVariant.withOpacity(0.8),
                          colors.accent.withOpacity(0.6),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: colors.surface.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Icon(
                              Icons.play_circle_outline,
                              size: 64,
                              color: isLightTheme ? Colors.white : colors.onSurface,
                            ),
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Video Content',
                            style: TextStyle(
                              color: isLightTheme ? Colors.white : colors.onSurface,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              // Positioned for title and date
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.3),
                        Colors.black.withOpacity(0.6),
                      ],
                    ),
                  ),
                  padding: EdgeInsets.fromLTRB(20, 30, 20, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.data['title'] ?? 'No Title',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              offset: Offset(0, 2),
                              blurRadius: 4,
                              color: Colors.black.withOpacity(0.6),
                            ),
                          ],
                          height: 1.2,
                        ),
                      ),
                      SizedBox(height: 8),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.calendar_today, size: 14, color: Colors.white),
                            SizedBox(width: 6),
                            Text(
                              _formatDate(widget.data['date'] ?? ''),
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          // Content below the image
          Padding(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Description/Explanation Text with AnimatedSize for smooth expansion
                AnimatedSize(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOutCubic,
                  child: Column(
                    children: [
                      if (widget.isExpanded) // Only show explanation if expanded
                        Container(
                          margin: EdgeInsets.only(bottom: 20),
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: colors.surfaceContainer,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: colors.outline.withOpacity(isLightTheme ? 0.2 : 0.1),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            widget.data['explanation'] ?? '',
                            style: TextStyle(
                              fontSize: 15,
                              height: 1.7,
                              color: colors.onSurfaceVariant,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: widget.onToggleExpand,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: isLightTheme ? [
                              colors.buttonSecondary,
                              colors.buttonSecondary.withOpacity(0.8),
                            ] : [
                              colors.buttonSecondary.withOpacity(0.08),
                              colors.buttonSecondary.withOpacity(0.12),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: colors.outline.withOpacity(isLightTheme ? 0.3 : 0.25),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: colors.shadow.withOpacity(isLightTheme ? 0.12 : 0.08),
                              blurRadius: isLightTheme ? 8 : 6,
                              offset: Offset(0, isLightTheme ? 3 : 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              widget.isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                              size: 20,
                              color: isLightTheme ? colors.onButtonSecondary : colors.onSecondary,
                            ),
                            SizedBox(width: 8),
                            Text(
                              widget.isExpanded ? 'Show Less' : 'Read More',
                              style: TextStyle(
                                fontSize: 14,
                                color: isLightTheme ? colors.onButtonSecondary : colors.onSecondary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: colors.surface,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: colors.shadow.withOpacity(isLightTheme ? 0.15 : 0.06),
                            blurRadius: isLightTheme ? 15 : 12,
                            offset: Offset(0, isLightTheme ? 5 : 4),
                            spreadRadius: isLightTheme ? 1 : 2,
                          ),
                        ],
                        border: Border.all(
                          color: colors.outline.withOpacity(isLightTheme ? 0.25 : 0.2),
                          width: 1,
                        ),
                      ),
                      child: IconButton(
                        icon: Icon(Icons.favorite_border, size: 20),
                        onPressed: widget.onFavoritePressed,
                        color: colors.onSurface.withOpacity(isLightTheme ? 0.7 : 0.85),
                        splashColor: colors.accent.withOpacity(0.2),
                        highlightColor: colors.accent.withOpacity(0.1),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}