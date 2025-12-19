import 'dart:convert';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'package:csv/csv.dart';
import 'package:intl/intl.dart';

/// Export utilities for admin dashboard
class ExportUtils {
  ExportUtils._();

  /// Export data to CSV
  static void exportToCSV({
    required List<Map<String, dynamic>> data,
    required List<String> headers,
    required List<String> keys,
    String filename = 'export',
  }) {
    if (data.isEmpty) {
      return;
    }

    // Create CSV rows
    final rows = <List<dynamic>>[
      headers, // Header row
      ...data.map((item) => keys.map((key) => item[key] ?? '').toList()),
    ];

    // Convert to CSV string
    final csvString = const ListToCsvConverter().convert(rows);

    // Create blob and download
    final bytes = utf8.encode(csvString);
    final blob = html.Blob([bytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..setAttribute('download', '$filename.csv')
      ..click();
    html.Url.revokeObjectUrl(url);
  }

  /// Export pickup requests to CSV
  static void exportPickupRequests(List<Map<String, dynamic>> requests) {
    exportToCSV(
      data: requests,
      headers: [
        'ID',
        'User',
        'Waste Type',
        'Weight (kg)',
        'Status',
        'Scheduled Date',
        'Address',
        'Created At',
      ],
      keys: [
        'id',
        'userName',
        'wasteType',
        'estimatedWeight',
        'status',
        'scheduledDate',
        'address',
        'createdAt',
      ],
      filename: 'pickup_requests_${_getDateString()}',
    );
  }

  /// Export users to CSV
  static void exportUsers(List<Map<String, dynamic>> users) {
    exportToCSV(
      data: users,
      headers: [
        'ID',
        'Name',
        'Email',
        'Phone',
        'Role',
        'Points',
        'Status',
        'Joined Date',
      ],
      keys: [
        'id',
        'name',
        'email',
        'phone',
        'role',
        'points',
        'isActive',
        'createdAt',
      ],
      filename: 'users_${_getDateString()}',
    );
  }

  /// Export transactions to CSV
  static void exportTransactions(List<Map<String, dynamic>> transactions) {
    exportToCSV(
      data: transactions,
      headers: [
        'ID',
        'Type',
        'User',
        'Amount',
        'Status',
        'Description',
        'Date',
      ],
      keys: [
        'id',
        'type',
        'userName',
        'amount',
        'status',
        'description',
        'createdAt',
      ],
      filename: 'transactions_${_getDateString()}',
    );
  }

  /// Export events to CSV
  static void exportEvents(List<Map<String, dynamic>> events) {
    exportToCSV(
      data: events,
      headers: [
        'ID',
        'Title',
        'Start Date',
        'End Date',
        'Points Required',
        'Status',
        'Participants',
      ],
      keys: [
        'id',
        'title',
        'startDate',
        'endDate',
        'pointsRequired',
        'isActive',
        'participantCount',
      ],
      filename: 'events_${_getDateString()}',
    );
  }

  /// Export point ledger to CSV
  static void exportPointLedger(List<Map<String, dynamic>> ledger) {
    exportToCSV(
      data: ledger,
      headers: [
        'ID',
        'User',
        'Type',
        'Points',
        'Description',
        'Date',
      ],
      keys: [
        'id',
        'userName',
        'type',
        'points',
        'description',
        'createdAt',
      ],
      filename: 'point_ledger_${_getDateString()}',
    );
  }

  /// Export pickup rates to CSV
  static void exportPickupRates(List<Map<String, dynamic>> rates) {
    exportToCSV(
      data: rates,
      headers: [
        'ID',
        'Waste Type',
        'Price per KG',
        'Points per KG',
        'Status',
      ],
      keys: [
        'id',
        'wasteType',
        'pricePerKg',
        'pointsPerKg',
        'isActive',
      ],
      filename: 'pickup_rates_${_getDateString()}',
    );
  }

  /// Export pickup slots to CSV
  static void exportPickupSlots(List<Map<String, dynamic>> slots) {
    exportToCSV(
      data: slots,
      headers: [
        'ID',
        'Date',
        'Start Time',
        'End Time',
        'Max Capacity',
        'Current Bookings',
        'Status',
      ],
      keys: [
        'id',
        'date',
        'startTime',
        'endTime',
        'maxCapacity',
        'currentBookings',
        'isActive',
      ],
      filename: 'pickup_slots_${_getDateString()}',
    );
  }

  /// Get formatted date string for filename
  static String _getDateString() {
    return DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
  }

  /// Export to JSON (for debugging or API consumption)
  static void exportToJSON({
    required List<Map<String, dynamic>> data,
    String filename = 'export',
  }) {
    final jsonString = const JsonEncoder.withIndent('  ').convert(data);
    final bytes = utf8.encode(jsonString);
    final blob = html.Blob([bytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..setAttribute('download', '$filename.json')
      ..click();
    html.Url.revokeObjectUrl(url);
  }

  /// Print table (opens print dialog)
  static void printTable() {
    html.window.print();
  }
}
