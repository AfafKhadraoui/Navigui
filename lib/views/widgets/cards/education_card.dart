import 'package:flutter/material.dart';
import 'package:navigui/commons/themes/style_simple/colors.dart';

class EducationCard extends StatefulWidget {
  final String title;
  final String badge1;
  final String badge2;
  final String badge3;
  final Color backgroundColor;
  final String? imagePath;
  final bool isLiked;
  final VoidCallback? onTap;
  final String? description;
  final String? author;
  final String? publishedDate;
  final int? viewsCount;

  const EducationCard({
    super.key,
    required this.title,
    required this.badge1,
    required this.badge2,
    required this.badge3,
    required this.backgroundColor,
    this.imagePath,
    this.isLiked = false,
    this.onTap,
    this.description,
    this.author,
    this.publishedDate,
    this.viewsCount,
  });

  @override
  State<EducationCard> createState() => _EducationCardState();
}

class _EducationCardState extends State<EducationCard> {
  late bool _isLiked;

  @override
  void initState() {
    super.initState();
    _isLiked = widget.isLiked;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: 224,
        height: 158,
        decoration: BoxDecoration(
          color: widget.backgroundColor,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Stack(
          children: [
            // Image
            if (widget.imagePath != null)
              Positioned(
                right: 10,
                top: 10,
                child: Image.asset(
                  widget.imagePath!,
                  width: 125,
                  height: 120,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 125,
                      height: 120,
                      color: Colors.grey.withOpacity(0.2),
                    );
                  },
                ),
              ),

            // Text content
            Positioned(
              left: 14,
              top: 15,
              right: 70,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: TextStyle(
                      color: AppColors.black,
                      fontSize: 16,
                      fontFamily: 'Aclonica',
                      height: 1.1,
                      letterSpacing: -0.5,
                    ),
                    maxLines: widget.description != null ? 2 : 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (widget.description != null) ...[
                    const SizedBox(height: 6),
                    Text(
                      widget.description!,
                      style: TextStyle(
                        color: AppColors.black.withOpacity(0.7),
                        fontSize: 11,
                        fontFamily: 'Acme',
                        height: 1.2,
                        letterSpacing: -0.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      if (widget.author != null) ...[
                        Icon(
                          Icons.person_outline,
                          size: 11,
                          color: AppColors.black.withOpacity(0.6),
                        ),
                        const SizedBox(width: 3),
                        Text(
                          widget.author!,
                          style: TextStyle(
                            color: AppColors.black.withOpacity(0.6),
                            fontSize: 10,
                            fontFamily: 'Acme',
                            letterSpacing: -0.3,
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                      if (widget.publishedDate != null) ...[
                        Icon(
                          Icons.access_time,
                          size: 11,
                          color: AppColors.black.withOpacity(0.6),
                        ),
                        const SizedBox(width: 3),
                        Text(
                          widget.publishedDate!,
                          style: TextStyle(
                            color: AppColors.black.withOpacity(0.6),
                            fontSize: 10,
                            fontFamily: 'Acme',
                            letterSpacing: -0.3,
                          ),
                        ),
                      ] else ...[
                        Text(
                          'explore →',
                          style: TextStyle(
                            color: AppColors.black,
                            fontSize: 12,
                            fontFamily: 'Aclonica',
                            letterSpacing: -0.5,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),

            // Like button - Always show on top right (consistent position with job cards)
            Positioned(
              right: 9,
              top: 7,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _isLiked = !_isLiked;
                  });
                },
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: AppColors.black,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _isLiked ? Icons.favorite : Icons.favorite_border,
                    color: _isLiked ? AppColors.red1 : AppColors.white,
                    size: 16,
                  ),
                ),
              ),
            ),

            // Info badges
            Positioned(
              left: 9,
              right: 9,
              bottom: 14,
              child: Row(
                children: [
                  _buildBadge(widget.badge1, widget.backgroundColor),
                  const SizedBox(width: 3),
                  _buildBadge(widget.badge2, widget.backgroundColor),
                  if (widget.badge3.isNotEmpty) ...[
                    const SizedBox(width: 3),
                    _buildBadge(widget.badge3, widget.backgroundColor),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge(String label, Color textColor) {
    return Container(
      height: 18,
      padding: const EdgeInsets.symmetric(horizontal: 9),
      decoration: BoxDecoration(
        color: AppColors.black,
        borderRadius: BorderRadius.circular(99),
      ),
      child: Center(
        child: Text(
          label,
          style: TextStyle(
            color: textColor,
            fontSize: 10,
            fontFamily: 'Acme',
            letterSpacing: -0.5,
          ),
        ),
      ),
    );
  }
}
