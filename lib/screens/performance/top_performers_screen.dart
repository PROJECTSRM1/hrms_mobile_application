import 'package:flutter/material.dart';
import 'package:hrms_mobile_application/models/top_performer.dart';
import 'package:hrms_mobile_application/services/performance_service.dart';

class TopPerformersScreen extends StatefulWidget {
  final List<TopPerformer> topPerformers;

  const TopPerformersScreen({
    super.key,
    required this.topPerformers,
  });

  @override
  State<TopPerformersScreen> createState() => _TopPerformersScreenState();
}

class _TopPerformersScreenState extends State<TopPerformersScreen> {
  final PerformanceService _performanceService = PerformanceService();
  List<TopPerformer> _performers = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _performers = widget.topPerformers;
  }

  Future<void> _refreshPerformers() async {
    setState(() => _isLoading = true);
    try {
      final performers = await _performanceService.getTopPerformers();
      setState(() {
        _performers = performers;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      appBar: AppBar(
        title: const Text('Top Performers'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _refreshPerformers,
              child: _performers.isEmpty
                  ? _buildEmptyState()
                  : GridView.builder(
                      padding: const EdgeInsets.all(16),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.75,
                      ),
                      itemCount: _performers.length,
                      itemBuilder: (context, index) {
                        return _buildPerformerCard(_performers[index]);
                      },
                    ),
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.emoji_events, size: 80, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            'No top performers yet',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Top performers will appear here',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPerformerCard(TopPerformer performer) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.grey.shade300,
            child: const Icon(Icons.person, size: 35, color: Colors.white),
          ),
          const SizedBox(height: 12),
          Text(
            'EMP ID: ${performer.empId}',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                performer.rating.toStringAsFixed(1),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(Icons.star, color: Colors.amber, size: 18),
            ],
          ),
        ],
      ),
    );
  }
}