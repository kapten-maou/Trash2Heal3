import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';

/// Enhanced data table wrapper with built-in features
class DataTableWrapper extends StatelessWidget {
  final List<DataColumn> columns;
  final List<DataRow> rows;
  final bool isLoading;
  final String? emptyMessage;
  final VoidCallback? onRefresh;
  final Widget? header;
  final List<Widget>? actions;
  final bool showCheckboxColumn;
  final int? sortColumnIndex;
  final bool? sortAscending;

  const DataTableWrapper({
    super.key,
    required this.columns,
    required this.rows,
    this.isLoading = false,
    this.emptyMessage,
    this.onRefresh,
    this.header,
    this.actions,
    this.showCheckboxColumn = false,
    this.sortColumnIndex,
    this.sortAscending,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          if (header != null || actions != null)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey.shade200),
                ),
              ),
              child: Row(
                children: [
                  if (header != null) Expanded(child: header!),
                  if (actions != null) ...actions!,
                ],
              ),
            ),

          // Table
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : rows.isEmpty
                    ? _buildEmptyState()
                    : PaginatedDataTable2(
                        columns: columns,
                        source: _DataSource(rows),
                        showCheckboxColumn: showCheckboxColumn,
                        sortColumnIndex: sortColumnIndex,
                        sortAscending: sortAscending ?? true,
                        columnSpacing: 12,
                        horizontalMargin: 16,
                        minWidth: 800,
                        border: TableBorder(
                          horizontalInside: BorderSide(
                            color: Colors.grey.shade200,
                          ),
                        ),
                        headingRowColor: MaterialStateProperty.all(
                          Colors.grey.shade50,
                        ),
                        rowsPerPage: 10,
                        availableRowsPerPage: const [10, 25, 50, 100],
                      ),
          ),
        ],
      ),
    );
  }

  /// Build empty state
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inbox_outlined,
            size: 64,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            emptyMessage ?? 'No data available',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
            ),
          ),
          if (onRefresh != null) ...[
            const SizedBox(height: 16),
            TextButton.icon(
              onPressed: onRefresh,
              icon: const Icon(Icons.refresh),
              label: const Text('Refresh'),
            ),
          ],
        ],
      ),
    );
  }
}

/// Data source for PaginatedDataTable2
class _DataSource extends DataTableSource {
  final List<DataRow> _rows;

  _DataSource(this._rows);

  @override
  DataRow? getRow(int index) {
    if (index >= _rows.length) return null;
    return _rows[index];
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => _rows.length;

  @override
  int get selectedRowCount => 0;
}

/// Simple data table for smaller datasets
class SimpleDataTable extends StatelessWidget {
  final List<String> headers;
  final List<List<String>> rows;
  final bool isLoading;
  final String? emptyMessage;

  const SimpleDataTable({
    super.key,
    required this.headers,
    required this.rows,
    this.isLoading = false,
    this.emptyMessage,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (rows.isEmpty) {
      return Center(
        child: Text(
          emptyMessage ?? 'No data available',
          style: TextStyle(color: Colors.grey.shade600),
        ),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: headers
            .map((header) => DataColumn(
                  label: Text(
                    header,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ))
            .toList(),
        rows: rows
            .map((row) => DataRow(
                  cells: row.map((cell) => DataCell(Text(cell))).toList(),
                ))
            .toList(),
        border: TableBorder.all(
          color: Colors.grey.shade300,
          width: 1,
        ),
      ),
    );
  }
}

/// Status badge widget for tables
class StatusBadge extends StatelessWidget {
  final String status;
  final Color? color;

  const StatusBadge({
    super.key,
    required this.status,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final badgeColor = color ?? _getStatusColor(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: badgeColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: badgeColor.withOpacity(0.3)),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: badgeColor,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
      case 'completed':
      case 'success':
      case 'approved':
        return Colors.green;
      case 'pending':
      case 'processing':
        return Colors.orange;
      case 'cancelled':
      case 'rejected':
      case 'failed':
        return Colors.red;
      case 'inactive':
      case 'suspended':
        return Colors.grey;
      default:
        return Colors.blue;
    }
  }
}

/// Action buttons for table rows
class TableRowActions extends StatelessWidget {
  final VoidCallback? onView;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const TableRowActions({
    super.key,
    this.onView,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (onView != null)
          IconButton(
            icon: const Icon(Icons.visibility_outlined, size: 20),
            tooltip: 'View',
            onPressed: onView,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        if (onEdit != null) ...[
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.edit_outlined, size: 20),
            tooltip: 'Edit',
            onPressed: onEdit,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
        if (onDelete != null) ...[
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.delete_outline, size: 20, color: Colors.red),
            tooltip: 'Delete',
            onPressed: onDelete,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ],
    );
  }
}
