import 'package:flutter/material.dart';
import '../../../commons/themes/style_simple/colors.dart';
import '../../../commons/themes/style_simple/styles.dart';
import '../../../utils/mock_data.dart';
import '../../../data/models/service_model.dart';

/// Services Marketplace Section Widget (Fiverr-like)
/// Purpose: Display services offered by students (design, tutoring, etc.)
///
/// Features to implement:
/// - Load services using MockData.loadServices()
/// - Filter active services (isActive == true)
/// - Display in horizontal scrolling cards (200px wide)
/// - Show: service image/icon, title, category, rating, review count, starting price
/// - Navigate to service details on card tap
/// - "See All" button to navigate to services marketplace
///
/// UI Requirements:
/// - Card with image placeholder at top (120px height)
/// - Star rating with amber color
/// - Price in "From X DA" format
/// - 240px total card height
/// - Loading state with CircularProgressIndicator
/// - Empty state message
class ServicesSection extends StatefulWidget {
  const ServicesSection({super.key});

  @override
  State<ServicesSection> createState() => _ServicesSectionState();
}

class _ServicesSectionState extends State<ServicesSection> {
  // TODO: Add state variables
  // List<ServiceModel> _services = [];
  // bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // TODO: Load services from MockData
    // Call _loadServices() method
  }

  // TODO: Implement _loadServices() method
  // - Use MockData.loadServices() to get all services
  // - Filter by isActive == true
  // - Take first 10 services
  // - Update state with setState()

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // TODO: Add section header with "Services Marketplace" title and "See All" button

        // TODO: Add horizontal ListView.builder
        // - Height: 240px
        // - Scroll direction: Axis.horizontal
        // - Card width: 200px
        // - Show loading spinner if _isLoading
        // - Show empty message if _services.isEmpty
        // - Build service cards with image, title, category, rating, price
      ],
    );
  }
}
