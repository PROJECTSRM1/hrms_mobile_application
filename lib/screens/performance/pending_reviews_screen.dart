import 'package:flutter/material.dart';
import 'package:hrms_mobile_application/models/pending_review.dart';
import 'package:hrms_mobile_application/screens/performance/add_review_screen.dart';
import 'package:hrms_mobile_application/services/performance_service.dart';

class PendingReviewsScreen extends StatefulWidget {
  final List<PendingReview> pendingReviews;

  const PendingReviewsScreen({
    super.key,
    required this.pendingReviews,
  });

  @override
  State<PendingReviewsScreen> createState() => _PendingReviewsScreenState();
}

class _PendingReviewsScreenState extends State<PendingReviewsScreen> {
  final PerformanceService _performanceService = PerformanceService();
  List<PendingReview> _reviews = [];
  bool _isLoading = false;
  int _currentPage = 0;
  final int _itemsPerPage = 7;

  @override
  void initState() {
    super.initState();
    _reviews = widget.pendingReviews;
  }

  Future<void> _refreshReviews() async {
    setState(() => _isLoading = true);
    try {
      final reviews = await _performanceService.getPendingReviews();
      setState(() {
        _reviews = reviews;
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

  List<PendingReview> _getPaginatedReviews() {
    final startIndex = _currentPage * _itemsPerPage;
    final endIndex = (startIndex + _itemsPerPage).clamp(0, _reviews.length);
    return _reviews.sublist(startIndex, endIndex);
  }

  int get _totalPages => (_reviews.length / _itemsPerPage).ceil();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Pending Reviews'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _refreshReviews,
              child: Column(
                children: [
                  Expanded(
                    child: _reviews.isEmpty
                        ? _buildEmptyState()
                        : SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                children: [
                                  _buildTable(),
                                  const SizedBox(height: 20),
                                  if (_totalPages > 1) _buildPagination(),
                                ],
                              ),
                            ),
                          ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_circle_outline, size: 80, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            'No pending reviews',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'All reviews are up to date',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTable() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          _buildTableHeader(),
          ..._getPaginatedReviews().map((review) => _buildTableRow(review)),

        ],
      ),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
      ),
      child: const Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(
              'EMP ID',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'Employee Name',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(width: 120),
        ],
      ),
    );
  }

  Widget _buildTableRow(PendingReview review) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(review.empId.toString()),
          ),
          Expanded(
            flex: 2,
            child: Text(review.employeeName),
          ),
          SizedBox(
            width: 120,
            child: ElevatedButton(
              onPressed: () => _navigateToAddReview(review),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add, size: 16),
                  SizedBox(width: 4),
                  Text('Add Review', style: TextStyle(fontSize: 12)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPagination() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: _currentPage > 0
              ? () => setState(() => _currentPage--)
              : null,
        ),
        ...List.generate(_totalPages, (index) {
          if (index == 0 ||
              index == _totalPages - 1 ||
              (index >= _currentPage - 1 && index <= _currentPage + 1)) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: GestureDetector(
                onTap: () => setState(() => _currentPage = index),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: _currentPage == index ? Colors.blue : Colors.white,
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(
                        color: _currentPage == index ? Colors.white : Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            );
          } else if (index == _currentPage - 2 || index == _currentPage + 2) {
            return const Padding(
              padding: EdgeInsets.symmetric(horizontal: 4),
              child: Text('...'),
            );
          }
          return const SizedBox.shrink();
        }),
        IconButton(
          icon: const Icon(Icons.chevron_right),
          onPressed: _currentPage < _totalPages - 1
              ? () => setState(() => _currentPage++)
              : null,
        ),
      ],
    );
  }

  Future<void> _navigateToAddReview(PendingReview review) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddReviewScreen(
          empId: review.empId,
          employeeName: review.employeeName,
        ),
      ),
    );

    if (result == true) {
      _refreshReviews();
    }
  }
}